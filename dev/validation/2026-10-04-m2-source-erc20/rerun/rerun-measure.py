"""Stand-in for /usr/bin/time -l inside the Seatbelt sandbox.

/usr/bin/time -l dies on `sysctl kern.clockrate: Operation not permitted`
and masks the child exit code. This wrapper reads the same wait4 rusage
(ru_maxrss in bytes on macOS) and keeps the child exit code.
Usage: python3 -P rerun-measure.py OUT ERR CMD...
"""
import os
import subprocess
import sys
import time

out_path, err_path, command = sys.argv[1], sys.argv[2], sys.argv[3:]
start = time.monotonic()
with open(out_path, 'wb') as out, open(err_path, 'wb') as err:
    child = subprocess.Popen(command, stdout=out, stderr=err)
    _, status, usage = os.wait4(child.pid, 0)
code = os.waitstatus_to_exitcode(status)
print(f'rc={code} secs={time.monotonic() - start:.1f} peak_rss_bytes={usage.ru_maxrss}')
sys.exit(code if code >= 0 else 128 - code)
