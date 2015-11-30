# perf.js
Simple JavaScript library to monitor frame rate (FPS), frame time (MS) and memory (MEM).

Uses `performance.now()` with the fallback to use `Date.now()` on older browsers.

**perf.js** is a self contained library, so by just instantiating it will start monitoring stats.

`new Perf();`

####Basic Stats:

<img alt="basic" src="https://raw.githubusercontent.com/adireddy/perf/master/assets/basic.png" width="84" height="28"/>

####With Memory (Chrome only):

<img alt="memory" src="https://raw.githubusercontent.com/adireddy/perf/master/assets/memory.png" width="84" height="42"/>

####With Custom Info (Optional):

Optional custom info can be added if needed, For exmple the following shows what kind of renderer and pixel ration pixi.js is using. 

<img alt="info" src="https://raw.githubusercontent.com/adireddy/perf/master/assets/info.png" width="84" height="56"/>
