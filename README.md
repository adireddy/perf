# perf.js
Simple JavaScript library to monitor frame rate (**FPS**), frame time (**MS**) and memory (**MEM**).

Uses `performance.now()` with `Date.now()` fallback on older browsers.

**perf.js** is a self contained library, so monitoring of stats will start by just instantiating it.

`var stats = new Perf();`

#### Installation:

`npm install perf.js`

For haxe users:

`haxelib install perf.js`

#### Basic Stats:

<img alt="basic" src="https://raw.githubusercontent.com/adireddy/perf/master/assets/basic.png" width="84" height="28"/>

#### With Memory (Chrome only):

<img alt="memory" src="https://raw.githubusercontent.com/adireddy/perf/master/assets/memory.png" width="84" height="42"/>

#### With Custom Info (Optional):

Optional custom info can be added if needed, For example the following shows what kind of renderer and pixel ratio pixi.js is using. 

<img alt="info" src="https://raw.githubusercontent.com/adireddy/perf/master/assets/info.png" width="84" height="56"/>

To use, simply call `addInfo(info)` on perf instance.

`stats.addInfo("custom info");`

#### Customisation:

You can customize the following:

```
Perf.MEASUREMENT_INTERVAL = 1000;
Perf.FONT_FAMILY = "Helvetica,Arial";
Perf.FPS_BG_CLR = "#00FF00";
Perf.FPS_WARN_BG_CLR = "#FF8000";
Perf.FPS_PROB_BG_CLR = "#FF0000";
Perf.MS_BG_CLR = "#FFFF00";
Perf.MEM_BG_CLR = "#086A87";
Perf.INFO_BG_CLR = "#00FFFF";
Perf.FPS_TXT_CLR = "#000000";
Perf.MS_TXT_CLR = "#000000";
Perf.MEM_TXT_CLR = "#FFFFFF";
Perf.INFO_TXT_CLR = "#000000";
```

The values assigned above are the default values.

#### Positioning:

By default stats appear on the top right corner. The position can be changed by passing the position to the constructor when instantiating `Perf`.

**Top Right** - default

`var stats = new Perf();`

**Top Left**

`var stats = new Perf(Perf.TOP_LEFT);`

**Bottom Right**

`var stats = new Perf(Perf.BOTTOM_RIGHT);`

**Bottom Left**

`var stats = new Perf(Perf.BOTTOM_LEFT);`

#### Licensing Information

<a rel="license" href="http://opensource.org/licenses/MIT">
<img alt="MIT license" height="40" src="http://upload.wikimedia.org/wikipedia/commons/c/c3/License_icon-mit.svg" /></a>

This content is released under the [MIT](http://opensource.org/licenses/MIT) License.