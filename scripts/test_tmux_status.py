#!/usr/bin/env python3
"""Regression tests for tmux-status on Termux (no Android calls)."""

import os
from pathlib import Path
import subprocess
import tempfile
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
        self.command(bin_dir, "date", "#!/bin/sh\necho 'Mon 1 Jan 00:00'\n")
        self.command(bin_dir, "termux-battery-status",
                     f"#!/bin/sh\necho call >> '{self.calls}'\n")
        self.env = dict(os.environ, HOME=str(root),
                        PATH=f"{bin_dir}:{os.environ['PATH']}")
        for name in ("AWS_PROFILE", "PREFIX", "TERMUX_VERSION"):
            self.env.pop(name, None)

    def command(self, bin_dir, name, content):
        path = bin_dir / name
        path.write_text(content)
        path.chmod(0o755)

    def status(self, **env):
        result = subprocess.run(["sh", str(SCRIPT), str(self.path), ""],
                                env={**self.env, **env}, capture_output=True,
                                text=True, timeout=5)
        self.assertEqual(result.returncode, 0, result.stderr)
        return result.stdout

    def test_termux_omits_battery_and_clock(self):
        for env in ({"TERMUX_VERSION": "test"}, {"PREFIX": TERMUX_PREFIX}):
            with self.subTest(env=env):
                self.assertEqual(self.status(**env), "proj  ")
        self.assertFalse(self.calls.exists(), "Termux:API must not be polled")

    def test_other_hosts_keep_the_clock(self):
        # Another PREFIX does not make a host Termux.
        self.assertTrue(self.status(PREFIX="/usr").endswith("Mon 1 Jan 00:00  "))


if __name__ == "__main__":
    unittest.main()
