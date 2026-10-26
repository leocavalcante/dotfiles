#!/usr/bin/env python3
"""Exercise zsh config sync against local bare remotes, without real updates.

Requires zsh, git, python3, and ~/.agents/scripts/git_commit.py.
"""

from contextlib import redirect_stderr
import io
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import time
import unittest
from unittest.mock import patch

import sync_git


ZSHRC = Path(__file__).resolve().parents[1] / ".zshrc"
COMMIT_HELPER = Path.home() / ".agents/scripts/git_commit.py"


class ConfigSyncTest(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix="config-sync-")
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)
        self.home = self.root / "home"
        self.home.mkdir()
        bin_dir = self.root / "bin"
        bin_dir.mkdir()
        self.env = dict(
            os.environ,
            HOME=str(self.home),
            PATH=f"{bin_dir}:{os.environ['PATH']}",
            GIT_CONFIG_GLOBAL=os.devnull,
            GIT_CONFIG_NOSYSTEM="1",
            GIT_CONFIG_COUNT="2",
            GIT_CONFIG_KEY_0="user.name",
            GIT_CONFIG_VALUE_0="leocavalcante",
            GIT_CONFIG_KEY_1="user.email",
            GIT_CONFIG_VALUE_1="git@leocavalcante.dev",
            GIT_TERMINAL_PROMPT="0",
            PYTHONDONTWRITEBYTECODE="1",
        )
        self.env.pop("TERMUX_VERSION", None)
        self.env.pop("PREFIX", None)
        self.functions = self.root / "functions.zsh"
        self.functions.write_text("\n\n".join(re.findall(
            r"^(?:_sync_config_repo|dot|agents|keep-it-up)\(\) \{\n.*?^\}",
            ZSHRC.read_text(), re.MULTILINE | re.DOTALL,
        )))
        for name, exit_var in (
            ("stow", "STOW_EXIT_CODE"), ("pi", "PI_EXIT_CODE"),
            ("npm", "NPM_EXIT_CODE"),
        ):
            command = bin_dir / name
            command.write_text(
                f'#!/bin/sh\nprintf "%s\\n" "{name} $*" >> "$HOME/calls"\n'
                f'exit "${{{exit_var}:-0}}"\n'
            )
            command.chmod(0o755)
        self.repos = {}
        self.remotes = {}
        for name, dirname in (("dot", ".dotfiles"), ("agents", ".agents")):
            remote = self.root / f"{name}.git"
            seed = self.root / f"{name}-seed"
            self.run_command("git", "init", "--bare", "--initial-branch=main", str(remote))
            self.run_command("git", "init", "--initial-branch=main", str(seed))
            (seed / "tracked.txt").write_text("initial\n")
            (seed / "delete.txt").write_text("delete me\n")
            (seed / ".gitignore").write_text(".env\n")
            self.commit(seed, "chore: seed sync fixture")
            self.git(seed, "remote", "add", "origin", str(remote))
            self.git(seed, "push", "origin", "main")
            repo = self.home / dirname
            self.run_command("git", "clone", str(remote), str(repo))
            self.repos[name] = repo
            self.remotes[name] = remote
        transport = self.repos["dot"] / "scripts/sync_git.py"
        transport.parent.mkdir()
        shutil.copyfile(Path(sync_git.__file__), transport)
        with (self.repos["dot"] / ".git/info/exclude").open("a") as handle:
            handle.write("\n/scripts/sync_git.py\n")
        # The real helper runs locally; its private source is never published.
        helper = self.home / ".agents/scripts/git_commit.py"
        helper.parent.mkdir()
        shutil.copyfile(COMMIT_HELPER, helper)
        exclude = self.repos["agents"] / ".git/info/exclude"
        with exclude.open("a") as handle:
            handle.write("\n/scripts/git_commit.py\n")

    def run_command(self, *args, check=True, input=None):
        result = subprocess.run(
            args, cwd=self.home, env=self.env, input=input,
            capture_output=True, text=True, timeout=15,
        )
        if check:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def git(self, repo, *args, **kwargs):
        return self.run_command("git", "-C", str(repo), *args, **kwargs)

    def commit(self, repo, message):
        self.git(repo, "add", "--all", "--", ".")
        self.run_command(
            "python3", str(COMMIT_HELPER), "--repo-dir", str(repo),
            "--message-file", "-", input=message + "\n",
        )
        return self.git(repo, "rev-parse", "HEAD").stdout.strip()

    def sync(self, name):
        return self.run_command(
            "zsh", "-f", "-c", 'source "$1"; "$2"',
            "zsh", str(self.functions), name, check=False,
        )

    def peer(self, name):
        repo = self.root / f"{name}-peer"
        self.run_command("git", "clone", str(self.remotes[name]), str(repo))
        return repo

    def assert_synced(self, name):
        repo = self.repos[name]
        head = self.git(repo, "rev-parse", "HEAD").stdout
        self.assertEqual(head, self.git(self.remotes[name], "rev-parse", "main").stdout)
        self.assertEqual(self.git(repo, "status", "--porcelain").stdout, "")
        self.assertEqual(self.git(repo, "stash", "list").stdout, "")
        return head.strip()

    def test_clean_sync_is_idempotent(self):
        for name, repo in self.repos.items():
            with self.subTest(name=name):
                head = self.git(repo, "rev-parse", "HEAD").stdout.strip()
                for _ in range(2):
                    result = self.sync(name)
                    self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                    self.assertEqual(self.assert_synced(name), head)

    def test_sync_announces_remote_operations(self):
        result = self.sync("dot")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Fetching dotfiles from origin/main (30s deadline)...", result.stdout)
        self.assertIn("Verifying dotfiles commits...", result.stdout)
        self.assertIn("Pushing dotfiles to origin/main (30s deadline)...", result.stdout)
        self.assertIn("Checking dotfiles remote HEAD (30s deadline)...", result.stdout)

    def test_commits_all_nonignored_local_changes(self):
        for name, repo in self.repos.items():
            with self.subTest(name=name):
                (repo / "tracked.txt").write_text("local\n")
                (repo / "delete.txt").unlink()
                (repo / "new.txt").write_text("new\n")
                (repo / "staged.txt").write_text("staged\n")
                self.git(repo, "add", "--", "staged.txt")
                (repo / ".env").write_text("fixture ignored file\n")
                result = self.sync(name)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assert_synced(name)
                self.assertEqual(self.git(repo, "show", "HEAD:tracked.txt").stdout, "local\n")
                self.assertEqual(self.git(repo, "show", "HEAD:new.txt").stdout, "new\n")
                self.assertEqual(self.git(repo, "show", "HEAD:staged.txt").stdout, "staged\n")
                self.assertNotEqual(self.git(repo, "cat-file", "-e", "HEAD:delete.txt", check=False).returncode, 0)
                self.assertNotEqual(self.git(repo, "ls-files", "--error-unmatch", ".env", check=False).returncode, 0)
                message = self.git(repo, "log", "-1", "--format=%B").stdout
                self.assertIn("Signed-off-by: leocavalcante <git@leocavalcante.dev>", message)
                self.assertNotIn("Co-authored-by:", message)

    def test_pushes_existing_local_commits(self):
        for name, repo in self.repos.items():
            with self.subTest(name=name):
                (repo / "tracked.txt").write_text("already committed\n")
                head = self.commit(repo, "chore: local fixture change")
                result = self.sync(name)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertEqual(self.assert_synced(name), head)

    def test_fast_forwards_remote_changes(self):
        for name, repo in self.repos.items():
            with self.subTest(name=name):
                peer = self.peer(name)
                (peer / "tracked.txt").write_text("remote\n")
                remote_head = self.commit(peer, "chore: remote fixture change")
                self.git(peer, "push", "origin", "main")
                result = self.sync(name)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assertEqual(self.assert_synced(name), remote_head)
                self.assertEqual((repo / "tracked.txt").read_text(), "remote\n")

    def test_merges_divergent_local_and_remote_changes(self):
        for name, repo in self.repos.items():
            with self.subTest(name=name):
                peer = self.peer(name)
                (peer / "remote.txt").write_text("remote\n")
                remote_head = self.commit(peer, "chore: remote fixture change")
                self.git(peer, "push", "origin", "main")
                (repo / "tracked.txt").write_text("local\n")
                result = self.sync(name)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assert_synced(name)
                parents = self.git(repo, "log", "-1", "--format=%P").stdout.split()
                self.assertEqual(len(parents), 2)
                self.assertEqual(parents[1], remote_head)
                self.assertEqual((repo / "tracked.txt").read_text(), "local\n")
                self.assertEqual((repo / "remote.txt").read_text(), "remote\n")

    def test_merges_divergent_commits_with_identical_trees(self):
        for name, repo in self.repos.items():
            with self.subTest(name=name):
                peer = self.peer(name)
                (peer / "tracked.txt").write_text("same change\n")
                remote_head = self.commit(peer, "chore: remote fixture change")
                self.git(peer, "push", "origin", "main")
                (repo / "tracked.txt").write_text("same change\n")
                local_head = self.commit(repo, "chore: local fixture change")
                result = self.sync(name)
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                self.assert_synced(name)
                self.assertEqual(self.git(repo, "log", "-1", "--format=%P").stdout.split(),
                                 [local_head, remote_head])

    def test_conflicts_preserve_both_sides_and_refuse_retry(self):
        for name, repo in self.repos.items():
            with self.subTest(name=name):
                peer = self.peer(name)
                (peer / "tracked.txt").write_text("remote\n")
                remote_head = self.commit(peer, "chore: remote fixture change")
                self.git(peer, "push", "origin", "main")
                (repo / "tracked.txt").write_text("local\n")
                self.assertNotEqual(self.sync(name).returncode, 0)
                local_head = self.git(repo, "rev-parse", "HEAD").stdout
                self.assertEqual(self.git(repo, "show", "HEAD:tracked.txt").stdout, "local\n")
                self.assertTrue((repo / ".git/MERGE_HEAD").exists())
                conflicts = self.git(repo, "ls-files", "--unmerged").stdout
                self.assertIn("tracked.txt", conflicts)
                self.assertNotEqual(self.sync(name).returncode, 0)
                self.assertEqual(self.git(repo, "rev-parse", "HEAD").stdout, local_head)
                self.assertEqual(self.git(repo, "ls-files", "--unmerged").stdout, conflicts)
                self.assertEqual(self.git(self.remotes[name], "rev-parse", "main").stdout.strip(), remote_head)
        self.assertFalse((self.home / "calls").exists())

    def test_refuses_non_main_branches(self):
        for name, repo in self.repos.items():
            with self.subTest(name=name):
                self.git(repo, "switch", "-c", "in-progress")
                (repo / "new.txt").write_text("local\n")
                head = self.git(repo, "rev-parse", "HEAD").stdout
                self.assertNotEqual(self.sync(name).returncode, 0)
                self.assertEqual(self.git(repo, "rev-parse", "HEAD").stdout, head)
                self.assertEqual(self.git(repo, "diff", "--cached", "--name-only").stdout, "")

    def test_fetch_failure_does_not_stage_or_commit(self):
        for name, repo in self.repos.items():
            with self.subTest(name=name):
                self.git(repo, "remote", "set-url", "origin", str(self.root / "missing.git"))
                (repo / "tracked.txt").write_text("local\n")
                head = self.git(repo, "rev-parse", "HEAD").stdout
                self.assertNotEqual(self.sync(name).returncode, 0)
                self.assertEqual(self.git(repo, "rev-parse", "HEAD").stdout, head)
                self.assertEqual(self.git(repo, "diff", "--cached", "--name-only").stdout, "")
                self.assertEqual((repo / "tracked.txt").read_text(), "local\n")

    def test_push_failure_stops_keep_it_up(self):
        remote = self.remotes["dot"]
        remote_head = self.git(remote, "rev-parse", "main").stdout
        hook = remote / "hooks/pre-receive"
        hook.write_text("#!/bin/sh\necho 'fixture rejected push' >&2\nexit 1\n")
        hook.chmod(0o755)
        (self.repos["dot"] / "tracked.txt").write_text("local\n")
        self.assertNotEqual(self.sync("keep-it-up").returncode, 0)
        self.assertEqual(self.git(remote, "rev-parse", "main").stdout, remote_head)
        self.assertEqual(self.git(self.repos["dot"], "show", "HEAD:tracked.txt").stdout, "local\n")
        self.assertFalse((self.home / "calls").exists())

    def test_push_timeout_stops_keep_it_up(self):
        transport = self.repos["dot"] / "scripts/sync_git.py"
        transport.write_text(transport.read_text().replace(
            "TIMEOUT_SECONDS = 30", "TIMEOUT_SECONDS = 0.2",
        ))
        remote = self.remotes["dot"]
        remote_head = self.git(remote, "rev-parse", "main").stdout
        hook = remote / "hooks/pre-receive"
        hook.write_text('#!/bin/sh\nprintf started > "$HOME/push-started"\nsleep 2\n')
        hook.chmod(0o755)
        for repo in self.repos.values():
            (repo / "tracked.txt").write_text("local\n")
        result = self.sync("keep-it-up")
        self.assertEqual(result.returncode, 124, result.stdout + result.stderr)
        self.assertTrue((self.home / "push-started").exists())
        self.assertIn("Git timed out", result.stderr)
        self.assertEqual(self.git(remote, "rev-parse", "main").stdout, remote_head)
        self.assertEqual(self.git(self.repos["dot"], "show", "HEAD:tracked.txt").stdout, "local\n")
        self.assertEqual(self.git(self.repos["agents"], "show", "HEAD:tracked.txt").stdout, "initial\n")
        self.assertFalse((self.home / "calls").exists())

    def test_keep_it_up_syncs_both_repos_before_pi_updates(self):
        for repo in self.repos.values():
            (repo / "tracked.txt").write_text("local\n")
        result = self.sync("keep-it-up")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        for name in self.repos:
            self.assert_synced(name)
        calls = (self.home / "calls").read_text().splitlines()
        self.assertTrue(calls[0].startswith("stow "))
        self.assertIn("--no-folding", calls[0])
        self.assertEqual(calls[1:], ["pi update", "pi update --extensions"])

    def test_keep_it_up_uses_npm_on_termux(self):
        for markers in (
            {"TERMUX_VERSION": "0.118.3"},
            {"PREFIX": "/data/data/com.termux/files/usr"},
        ):
            with self.subTest(markers=markers):
                self.env.pop("TERMUX_VERSION", None)
                self.env.pop("PREFIX", None)
                self.env.update(markers)
                (self.home / "calls").write_text("")
                result = self.sync("keep-it-up")
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
                calls = (self.home / "calls").read_text().splitlines()
                self.assertTrue(calls[0].startswith("stow "))
                self.assertEqual(calls[1:], [
                    "npm install -g --ignore-scripts @earendil-works/pi-coding-agent",
                    "pi update --extensions",
                ])

    def test_termux_npm_failure_stops_keep_it_up(self):
        self.env.update(TERMUX_VERSION="0.118.3", NPM_EXIT_CODE="23")
        result = self.sync("keep-it-up")
        self.assertEqual(result.returncode, 23, result.stdout + result.stderr)
        calls = (self.home / "calls").read_text().splitlines()
        self.assertEqual(calls[1:], [
            "npm install -g --ignore-scripts @earendil-works/pi-coding-agent",
        ])

    def test_pi_self_update_failure_stops_keep_it_up(self):
        self.env["PI_EXIT_CODE"] = "23"
        result = self.sync("keep-it-up")
        self.assertEqual(result.returncode, 23, result.stdout + result.stderr)
        calls = (self.home / "calls").read_text().splitlines()
        self.assertEqual(calls[1:], ["pi update"])

    def test_termux_extension_failure_is_returned(self):
        self.env.update(TERMUX_VERSION="0.118.3", PI_EXIT_CODE="23")
        result = self.sync("keep-it-up")
        self.assertEqual(result.returncode, 23, result.stdout + result.stderr)
        calls = (self.home / "calls").read_text().splitlines()
        self.assertEqual(calls[1:], [
            "npm install -g --ignore-scripts @earendil-works/pi-coding-agent",
            "pi update --extensions",
        ])

    def test_stow_failure_stops_keep_it_up(self):
        self.env["STOW_EXIT_CODE"] = "23"
        result = self.sync("keep-it-up")
        self.assertEqual(result.returncode, 23, result.stdout + result.stderr)
        self.assertEqual(len((self.home / "calls").read_text().splitlines()), 1)


class GitDeadlineTest(unittest.TestCase):
    def test_preserves_git_exit_code(self):
        with patch.object(sync_git.subprocess, "Popen") as popen:
            popen.return_value.wait.return_value = 23
            popen.return_value.poll.return_value = 23
            self.assertEqual(sync_git.main(["push", "origin", "main"]), 23)
            popen.assert_called_once_with(
                ["git", "push", "origin", "main"], start_new_session=True,
            )

    def test_timeout_kills_git_and_credential_helpers(self):
        with tempfile.TemporaryDirectory(prefix="config-sync-timeout-") as temp:
            root = Path(temp)
            started = root / "started"
            leaked = root / "leaked"
            git = root / "git"
            git.write_text(
                '#!/bin/sh\n'
                '(sleep 0.5; printf leaked > "$LEAK_MARKER") &\n'
                'printf started > "$START_MARKER"\n'
                'wait\n'
            )
            git.chmod(0o755)
            error = io.StringIO()
            with patch.dict(os.environ, {
                "PATH": f"{root}:{os.environ['PATH']}",
                "START_MARKER": str(started),
                "LEAK_MARKER": str(leaked),
            }), patch.object(sync_git, "TIMEOUT_SECONDS", 0.2), redirect_stderr(error):
                self.assertEqual(sync_git.main(["push", "origin", "main"]), 124)
            self.assertTrue(started.exists(), "fixture did not reach the credential helper")
            self.assertIn("timed out", error.getvalue())
            self.assertIn("unlock your login keyring/keychain", error.getvalue())
            self.assertIn("Check the remote HEAD", error.getvalue())
            time.sleep(0.7)
            self.assertFalse(leaked.exists(), "credential helper survived the deadline")

    def test_interrupt_terminates_git_process_group(self):
        with patch.object(sync_git.subprocess, "Popen") as popen, \
                patch.object(sync_git.os, "killpg") as killpg:
            process = popen.return_value
            process.wait.side_effect = [KeyboardInterrupt, 0]
            process.poll.return_value = None
            self.assertEqual(sync_git.main(["fetch", "origin"]), 130)
            killpg.assert_called_once_with(process.pid, sync_git.signal.SIGKILL)


if __name__ == "__main__":
    unittest.main()
