#!/usr/bin/env python3
"""Regression tests for detached Termux battery polling (no Android calls)."""

import os
from pathlib import Path
import shlex
import shutil
import subprocess
import sys
import tempfile
import time
import unittest


SCRIPT = Path(__file__).with_name("tmux-status")


class BatteryPollingTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.bin = self.root / "bin"
        self.bin.mkdir()
        self.cache = self.root / "cache" / "tmux"
        self.env = dict(os.environ, HOME=str(self.root),
                        XDG_CACHE_HOME=str(self.root / "cache"),
                        TERMUX_VERSION="test", PATH=f"{self.bin}:{os.environ['PATH']}")
        self.command("hostname", "#!/bin/sh\nprintf 'localhost\\n'\n")
        # Ignore the test host's physical battery, but preserve other awk uses.
        awk = shlex.quote(shutil.which("awk"))
        self.command("awk", f'''#!/bin/sh
case "$*" in *'/sys/class/power_supply/'*) exit 1 ;; esac
exec {awk} "$@"
''')
        self.command("termux-battery-status", f'''#!{sys.executable}
import os
from pathlib import Path
import time
root = Path(os.environ["HOME"])
with (root / "calls").open("a") as calls:
    calls.write("call\\n")
if os.environ.get("BATTERY_FAIL"):
    raise SystemExit(1)
end = time.monotonic() + 10
while not (root / "release").exists():
    if time.monotonic() > end:
        raise SystemExit(1)
    time.sleep(0.02)
print('{{\\n  "percentage": 88,\\n  "status": "CHARGING"\\n}}')
''')

    def command(self, name, content):
        path = self.bin / name
        path.write_text(content)
        path.chmod(0o755)

    def tearDown(self):
        (self.root / "release").touch()
        # Let any detached test worker complete before deleting its cache.
        time.sleep(0.15)
        self.temp.cleanup()

    def status(self):
        start = time.monotonic()
        result = subprocess.run(["sh", str(SCRIPT), str(self.root), ""],
                                env=self.env, capture_output=True, text=True, timeout=1)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertLess(time.monotonic() - start, 1)
        return result.stdout

    def wait_for(self, predicate):
        end = time.monotonic() + 3
        while not predicate():
            if time.monotonic() > end:
                self.fail("Detached poll did not reach the expected state")
            time.sleep(0.02)

    def call_count(self):
        calls = self.root / "calls"
        return len(calls.read_text().splitlines()) if calls.exists() else 0

    def test_slow_poll_survives_and_does_not_overlap(self):
        self.assertNotIn("88%", self.status())
        self.wait_for(lambda: self.call_count() == 1)
        # The old timeout killed requests after two seconds.
        time.sleep(2.2)
        for _ in range(5):
            self.assertNotIn("88%", self.status())
        self.assertEqual(self.call_count(), 1)
        (self.root / "release").touch()
        self.wait_for(lambda: (self.cache / "battery.json").exists())
        self.assertIn("88%+", self.status())
        time.sleep(0.1)
        self.assertEqual(self.call_count(), 1, "Fresh cache should throttle polls")

    def test_failed_poll_preserves_cache_and_throttles_retries(self):
        self.cache.mkdir(parents=True)
        (self.cache / "battery.json").write_text('{\n  "percentage": 42,\n  "status": "DISCHARGING"\n}\n')
        self.env["BATTERY_FAIL"] = "1"
        self.assertIn("42%", self.status())
        self.wait_for(lambda: self.call_count() == 1)
        time.sleep(0.1)
        self.assertIn("42%", self.status())
        time.sleep(0.1)
        self.assertEqual(self.call_count(), 1)
        self.assertFalse((self.cache / "battery.tmp").exists())


if __name__ == "__main__":
    unittest.main()
