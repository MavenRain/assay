// Test instrumentation only. The routing function is supplied by native Bend.
function assay_route_sample(route, value) { return run_loop(route(value)); }
function testperf_measure(inputs, route) {
  const samples = [];
  for (let xs = inputs; xs.$ === 'Con'; xs = xs.tail) {
    // A boxed string is an identity sentinel. String reconstruction loses it.
    // Flatten ropes before measurement, as the original fixtures were flat.
    const value = new String(xs.head);
    value.charCodeAt(value.length - 1);
    samples.push(value);
  }
  for (let warm = 0; warm < 20; ++warm) {
    for (const value of samples) run_loop(route(value));
  }
  const session = new (require('inspector').Session)();
  session.connect();
  let started = false;
  session.post('HeapProfiler.startSampling', {
    samplingInterval: 1,
    includeObjectsCollectedByMajorGC: true,
    includeObjectsCollectedByMinorGC: true
  }, error => { started = !error; });
  if (!started) {
    session.disconnect();
    return { $: 'TestPerf.Measurement', ok: 0, bytes: 0 };
  }
  let same = samples.length === 3;
  globalThis.ASSAY_ROUTE_OBSERVATIONS = [];
  for (const value of samples) {
    const observed = assay_route_sample(route, value);
    globalThis.ASSAY_ROUTE_OBSERVATIONS.push(observed);
    same = same && !!observed.ok && observed.source === value && observed.output === value;
  }
  let profile;
  session.post('HeapProfiler.stopSampling', (error, result) => {
    if (!error) profile = result.profile;
  });
  session.disconnect();
  delete globalThis.ASSAY_ROUTE_OBSERVATIONS;
  if (!profile) return { $: 'TestPerf.Measurement', ok: 0, bytes: 0 };
  const pending = [[profile.head, false]];
  let bytes = 0;
  let marked = false;
  const diagnostic = [];
  while (pending.length) {
    const [node, parentProfiler] = pending.pop();
    const profiler = parentProfiler || node.callFrame.url === 'node:inspector';
    if (!profiler) bytes += node.selfSize;
    if (node.callFrame.functionName === 'assay_route_sample') marked = true;
    if (node.selfSize) diagnostic.push({ name: node.callFrame.functionName, url: node.callFrame.url, bytes: node.selfSize, profiler });
    pending.push(...node.children.map(child => [child, profiler]));
  }
  if (process.env.ASSAY_ROUTE_PROFILE) {
    diagnostic.sort((a, b) => b.bytes - a.bytes);
    process.stderr.write(JSON.stringify({ same, marked, bytes, largest: diagnostic.slice(0, 12) }) + '\n');
  }
  return { $: 'TestPerf.Measurement', ok: same && marked ? 1 : 0, bytes: Math.min(0xffffffff, bytes) };
}
