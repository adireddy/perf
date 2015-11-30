# perf.js
Simple JavaScript library to monitor frame rate (FPS), frame time (MS) and memory (MEM).

Uses `performance.now()` with the fallback to use `Date.now()` on older browsers.

**perf.js** is a self contained library, so by just instantiating it will start monitoring stats.

`new Perf();`