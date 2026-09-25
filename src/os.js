// The native boundary exposes only filesystem and literal-argv process effects.
function os_attempt(effect, failure) {
  try { return effect(); } catch (error) { return failure(error); }
}
function nativeio_failure(error) {
  return { $: 'Fail', error: io_tup(Math.abs(error.errno || 5) >>> 0,
    Buffer.from(String(error.message || error), 'utf8').toString('latin1')) };
}
function nativeio_exit(code) { process.exit(code); }
// The generated runtime consumes "--", "--threads" and "--gpu" from the process
// arguments before the program starts, and answers "--help" with its own usage
// and exit 0. Keep the real vector here and leave the runtime an empty one: the
// driver must see every token and answer an unknown one with usage and exit 64.
const nativeio_argv = process.argv.slice(2);
process.argv = process.argv.slice(0, 2);
function nativeio_args() {
  let args = { $: 'Nil' };
  for (let i = nativeio_argv.length; i > 0; --i) args = { $: 'Con', head: Buffer.from(nativeio_argv[i - 1], 'utf8').toString('latin1'), tail: args };
  return args;
}
function nativeio_output(fd, text) {
  const bytes = Buffer.from(text, 'latin1');
  const pause = new Int32Array(new SharedArrayBuffer(4));
  let at = 0;
  while (at < bytes.length) {
    const count = os_attempt(() => require('fs').writeSync(fd, bytes, at, bytes.length - at), error => {
      if (error.code === 'EAGAIN' || error.code === 'EINTR') return 0;
      if (fd !== 2) nativeio_output(2, String(error.message || error) + '\n');
      process.exit(1);
    });
    if (count === 0) Atomics.wait(pause, 0, 0, 1);
    else at += count;
  }
  return { $: 'Unit' };
}
function nativeio_stdout(text) { return nativeio_output(1, text); }
function nativeio_die(code, text) { nativeio_output(2, text + '\n'); process.exit(code); }
function nativeio_open(path, mode) {
  return os_attempt(() => io_done(require('fs').openSync(Buffer.from(path, 'latin1'), mode, 0o644)),
    nativeio_failure);
}
function nativeio_read_bytes(file, max) {
  const bytes = Buffer.alloc(Math.min(max, 65536));
  return os_attempt(() => {
    const count = require('fs').readSync(file, bytes, 0, bytes.length, null);
    let result = { $: 'Nil' };
    for (let i = count; i > 0; --i) result = { $: 'Con', head: bytes[i - 1], tail: result };
    return io_tup(file, io_done(result));
  }, error => io_tup(file, nativeio_failure(error)));
}
function nativeio_write_bytes(file, bytes) {
  return os_attempt(() => {
    const values = [];
    for (let xs = bytes; xs.$ === 'Con'; xs = xs.tail) values.push(xs.head);
    const buffer = Buffer.from(values);
    let at = 0;
    while (at < buffer.length) at += require('fs').writeSync(file, buffer, at, buffer.length - at);
    return io_tup(file, io_done({ $: 'Unit' }));
  }, error => io_tup(file, nativeio_failure(error)));
}
function os_regular(path) {
  return os_attempt(() => require('fs').statSync(Buffer.from(path, 'latin1')).isDirectory() ? 0 : 1, () => 0);
}
function os_mkdir_new(path) {
  return os_attempt(() => {
    const fs = require('fs');
    const bytes = Buffer.from(path, 'latin1');
    if (fs.existsSync(bytes) || !fs.statSync(Buffer.from(require('path').dirname(path), 'latin1')).isDirectory()) return 0;
    fs.mkdirSync(bytes, { mode: 0o755 });
    return 1;
  }, () => 0);
}
function os_basename(path) {
  const p = require('path');
  const base = p.basename(path);
  return base.slice(0, base.length - p.extname(base).length);
}
function os_root() { return Buffer.from(process.env.ASSAY_ROOT || process.cwd(), 'utf8').toString('latin1'); }
function os_executable(name) {
  const fs = require('fs'), p = require('path');
  for (const dir of (process.env.PATH || '').split(p.delimiter).filter(Boolean)) {
    const file = p.join(dir, name);
    const executable = os_attempt(() => {
      const stat = fs.statSync(file);
      return !stat.isDirectory() && (stat.mode & 0o111);
    }, () => false);
    if (executable) return { $: 'Some', value: Buffer.from(file, 'utf8').toString('latin1') };
  }
  return { $: 'None' };
}
function os_run(program, args) {
  const argv = [];
  for (let xs = args; xs.$ === 'Con'; xs = xs.tail) argv.push(Buffer.from(xs.head, 'latin1').toString('utf8'));
  return os_attempt(() => {
    const result = require('child_process').spawnSync(Buffer.from(program, 'latin1').toString('utf8'), argv, {
      stdio: ['inherit', 'pipe', 'inherit'], maxBuffer: 1024 * 1024 * 1024
    });
    return { $: 'OS.Process', kind: result.signal ? 1 : result.error ? 2 : 0,
      code: result.status === null ? 127 : result.status,
      signal: result.signal || '', output: (result.stdout || Buffer.alloc(0)).toString('latin1') };
  }, () => ({ $: 'OS.Process', kind: 2, code: 127, signal: '', output: '' }));
}
