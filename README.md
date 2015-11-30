# perf.js
Simple JavaScript library to monitor frame rate (FPS), frame time (MS) and memory (MEM).

Uses `performance.now()` with the fallback to use `Date.now()` on older browsers.

**perf.js** is a self contained library, so by just instantiating it will start monitoring stats.

`new Perf();`

####Basic Stats:

![basic](https://raw.githubusercontent.com/adireddy/perf/master/assets/basic.png)

####With Memory (Chrome only):

![basic](https://raw.githubusercontent.com/adireddy/perf/master/assets/memory.png)

####With Custom Info (Optional):

Optional custom info can be added if needed, For exmple the following shows what kind of renderer and pixel ration pixi.js is using. 

![basic](https://raw.githubusercontent.com/adireddy/perf/master/assets/info.png)
