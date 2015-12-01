import js.html.Performance;
import js.html.DivElement;
import js.Browser;

@:expose class Perf {

	public static var MEASUREMENT_INTERVAL:Int = 1000;

	public static var FONT_FAMILY:String = "Helvetica,Arial";

	public static var FPS_BG_CLR:String = "#00FF00";
	public static var FPS_WARN_BG_CLR:String = "#FF8000";
	public static var FPS_PROB_BG_CLR:String = "#FF0000";

	public static var MS_BG_CLR:String = "#FFFF00";
	public static var MEM_BG_CLR:String = "#086A87";
	public static var INFO_BG_CLR:String = "#00FFFF";
	public static var FPS_TXT_CLR:String = "#000000";
	public static var MS_TXT_CLR:String = "#000000";
	public static var MEM_TXT_CLR:String = "#FFFFFF";
	public static var INFO_TXT_CLR:String = "#000000";

	public static var TOP_LEFT:String = "TL";
	public static var TOP_RIGHT:String = "TR";
	public static var BOTTOM_LEFT:String = "BL";
	public static var BOTTOM_RIGHT:String = "BR";

	public var fps:DivElement;
	public var ms:DivElement;
	public var memory:DivElement;
	public var info:DivElement;

	public var currentFps:Float;
	public var currentMs:Float;
	public var currentMem:String;

	var _time:Float;
	var _startTime:Float;
	var _prevTime:Float;
	var _ticks:Int;
	var _fpsMin:Float;
	var _fpsMax:Float;
	var _memCheck:Bool;
	var _pos:String;

	var _perfObj:Performance;
	var _memoryObj:Memory;

	public function new(?pos = "TR") {
		_perfObj = Browser.window.performance;
		_memoryObj = untyped __js__("window.performance").memory;
		_memCheck = (_perfObj != null && _memoryObj != null && _memoryObj.totalJSHeapSize > 0);

		currentFps = 0;
		currentMs = 0;
		currentMem = "0";

		_pos = pos;
		_time = 0;
		_ticks = 0;
		_fpsMin = Math.POSITIVE_INFINITY;
		_fpsMax = 0;
		_startTime = _now();
		_prevTime = -MEASUREMENT_INTERVAL;

		_createFpsDom();
		_createMsDom();
		if (_memCheck) _createMemoryDom();
		Browser.window.requestAnimationFrame(cast _tick);
	}

	inline function _now():Float {
		return (_perfObj != null && _perfObj.now != null) ? _perfObj.now() : Date.now().getTime();
	}

	function _tick() {
		var time = _now();
		_ticks++;

		if (time > _prevTime + MEASUREMENT_INTERVAL) {
			currentMs = Math.round(time - _startTime);
			ms.innerHTML = "MS: " + currentMs;

			currentFps = Math.round((_ticks * 1000) / (time - _prevTime));
			_fpsMin = Math.min(_fpsMin, currentFps);
			_fpsMax = Math.max(_fpsMax, currentFps);

			fps.innerHTML =  "FPS: " + currentFps + " (" + _fpsMin + "-" + _fpsMax + ")";

			if (currentFps >= 30) fps.style.backgroundColor = FPS_BG_CLR;
			else if (currentFps >= 15) fps.style.backgroundColor = FPS_WARN_BG_CLR;
			else fps.style.backgroundColor = FPS_PROB_BG_CLR;

			_prevTime = time;
			_ticks = 0;

			if (_memCheck) {
				currentMem = _getFormattedSize(_memoryObj.usedJSHeapSize, 2);
				memory.innerHTML = "MEM: " + currentMem;
			}
		}
		_startTime =  time;

		Browser.window.requestAnimationFrame(cast _tick);
	}

	function _createDiv(id:String, ?top:Float = 0):DivElement {
		var div:DivElement = Browser.document.createDivElement();
		div.id = id;
		div.className = id;
		div.style.position = "absolute";

		switch (_pos) {
			case "TL":
				div.style.left = "0px";
				div.style.top = top + "px";
			case "TR":
				div.style.right = "0px";
				div.style.top = top + "px";
			case "BL":
				div.style.left = "0px";
				div.style.bottom = 30 - top + "px";
			case "BR":
				div.style.right = "0px";
				div.style.bottom = 30 - top + "px";
		}

		div.style.width = "80px";
		div.style.height = "14px";
		div.style.lineHeight = "14px";
		div.style.padding = "2px";
		div.style.fontFamily = FONT_FAMILY;
		div.style.fontSize = "9px";
		div.style.fontWeight = "bold";
		div.style.textAlign = "center";
		Browser.document.body.appendChild(div);
		return div;
	}

	function _createFpsDom() {
		fps = _createDiv("fps");
		fps.style.backgroundColor = FPS_BG_CLR;
		fps.style.zIndex = "995";
		fps.style.color = FPS_TXT_CLR;
		fps.innerHTML = "FPS: 0";
	}

	function _createMsDom() {
		ms = _createDiv("ms", 16);
		ms.style.backgroundColor = MS_BG_CLR;
		ms.style.zIndex = "996";
		ms.style.color = MS_TXT_CLR;
		ms.innerHTML = "MS: 0";
	}

	function _createMemoryDom() {
		memory = _createDiv("memory", 32);
		memory.style.backgroundColor = MEM_BG_CLR;
		memory.style.color = MEM_TXT_CLR;
		memory.style.zIndex = "997";
		memory.innerHTML = "MEM: 0";
	}

	function _getFormattedSize(bytes:Float, ?frac:Int = 0):String {
		var sizes = ["Bytes", "KB", "MB", "GB", "TB"];
		if (bytes == 0) return "0";
		var precision = Math.pow(10, frac);
		var i = Math.floor(Math.log(bytes) / Math.log(1024));
		return Math.round(bytes * precision / Math.pow(1024, i)) / precision + " " + sizes[i];
	}

	public function addInfo(val:String) {
		info = _createDiv("info", (_memCheck) ? 48 : 32);
		info.style.backgroundColor = INFO_BG_CLR;
		info.style.color = INFO_TXT_CLR;
		info.style.zIndex = "998";
		info.innerHTML = val;
	}

	public function clearInfo() {
		if (info != null) {
			Browser.document.body.removeChild(info);
			info = null;
		}
	}
}

typedef Memory = {
	var usedJSHeapSize:Float;
	var totalJSHeapSize:Float;
	var jsHeapSizeLimit:Float;
}