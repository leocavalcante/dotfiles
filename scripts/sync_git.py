#!/usr/bin/env python3
"""Run config-sync Git transport with a deadline, including credential helpers."""

import os
import signal
import subprocess
import sys


TIMEOUT_SECONDS = 30


def main(args):
    process = subprocess.Popen(["git", *args], start_new_session=True)
    try:
        return process.wait(timeout=TIMEOUT_SECONDS)
    except subprocess.TimeoutExpired:
        print(
            f"Git timed out after {TIMEOUT_SECONDS} seconds. Check your network "
            "and unlock your login keyring/keychain if credentials are locked. "
            "Check the remote HEAD before retrying a push.",
            file=sys.stderr,
        )
        return 124
    except KeyboardInterrupt:
        return 130
    finally:
        if process.poll() is None:
            os.killpg(process.pid, signal.SIGKILL)
            process.wait()


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
