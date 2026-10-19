#!/usr/bin/env python3
"""Regression tests for tmux-status on Termux (no Android calls)."""

import os
from pathlib import Path
import subprocess
import tempfile
import time
import unittest


SCRIPT = Path(__file__).with_name("tmux-status")
TERMUX_PREFIX = "/data/data/com.termux/files/usr"


class TmuxStatusTest(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        root = Path(temp.name)
        self.path = root / "proj"
        self.path.mkdir()
        self.calls = root / "calls"
        bin_dir = root / "bin"
        bin_dir.mkdir()
        # A fixed clock makes a present or absent clock unambiguous.
        self.command(bin_dir, "date",
                     "#!/bin/sh\nif [ \"$1\" = \"+%s\" ]; then echo 1735689600; else echo 'Mon 1 Jan 00:00'; fi\n")
        self.command(bin_dir, "termux-battery-status",
                     f"#!/bin/sh\necho call >> '{self.calls}'\nprintf '%s\\n' '{{\"percentage\":84,\"status\":\"CHARGING\"}}'\n")
        # Keep the nested-tmux check independent from the test runner's parent.
        self.command(bin_dir, "ps", "#!/bin/sh\necho 1\n")
        self.env = dict(os.environ, HOME=str(root),
                        PATH=f"{bin_dir}:{os.environ['PATH']}")
        for name in ("AWS_PROFILE", "PREFIX", "TERMUX_VERSION", "SSH_CONNECTION"):
            self.env.pop(name, None)

    def command(self, bin_dir, name, content):
        path = bin_dir / name
        path.write_text(content)
        path.chmod(0o755)

    def status(self, client_pid="", **env):
        result = subprocess.run(["sh", str(SCRIPT), str(self.path), str(client_pid)],
                                env={**self.env, **env}, capture_output=True,
                                text=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stderr)
        return result.stdout

    def test_termux_omits_battery_and_clock(self):
        for env in ({"TERMUX_VERSION": "test"}, {"PREFIX": TERMUX_PREFIX}):
            with self.subTest(env=env):
                self.assertEqual(self.status(**env), "proj  ")
        self.assertFalse(self.calls.exists(), "Termux:API must not be polled")

    def test_termux_local_client_omits_battery_and_clock(self):
        if not Path(f"/proc/{os.getpid()}/environ").exists():
            self.skipTest("client environment detection requires /proc")
        client = subprocess.Popen(["sleep", "30"], env={**self.env, "TERM": "xterm-256color"},
                                  stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        try:
            self.assertEqual(self.status(client.pid, TERMUX_VERSION="test"), "proj  ")
            self.assertFalse(self.calls.exists(), "Termux:API must not be polled")
        finally:
            client.terminate()
            client.wait()

    def test_remote_termux_client_shows_battery_and_clock(self):
        if not Path(f"/proc/{os.getpid()}/environ").exists():
            self.skipTest("client environment detection requires /proc")
        client = subprocess.Popen(["sleep", "30"],
                                  env={**self.env, "TERM": "xterm-256color", "SSH_CONNECTION": "test"},
                                  stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        try:
            first = self.status(client.pid, TERMUX_VERSION="test")
            self.assertTrue(first.endswith("Mon 1 Jan 00:00  "))

            cache = Path(self.env["HOME"]) / ".cache/tmux-status/flip-battery"
            deadline = time.monotonic() + 3
            while time.monotonic() < deadline:
                try:
                    fields = cache.read_text().split()
                except FileNotFoundError:
                    fields = []
                if len(fields) >= 2 and fields[1] == "84":
                    break
                time.sleep(0.02)
            else:
                self.fail("background battery refresh did not populate the cache")

            self.assertIn("84%+  Mon 1 Jan 00:00", self.status(client.pid, TERMUX_VERSION="test"))
            self.assertEqual(self.calls.read_text().splitlines(), ["call"])
        finally:
            client.terminate()
            client.wait()

    def test_other_hosts_keep_the_clock(self):
        # Another PREFIX does not make a host Termux.
        self.assertTrue(self.status(PREFIX="/usr").endswith("Mon 1 Jan 00:00  "))


if __name__ == "__main__":
    unittest.main()
