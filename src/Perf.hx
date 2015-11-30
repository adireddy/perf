import js.html.Performance;
import js.html.DivElement;
import js.Browser;

@:expose class Perf {

	public static var FONT_FAMILY:String = "Helvetica,Arial";
	public static var FPS_BG_CLR:String = "#00FF00";
	public static var MEM_BG_CLR:String = "#FF00FF";
	public static var INFO_BG_CLR:String = "#00FFFF";
	public static var FPS_TXT_CLR:String = "#000000";
	public static var MEM_TXT_CLR:String = "#FFFFFF";
	public static var INFO_TXT_CLR:String = "#000000";

	public static var TOP_LEFT:String = "TL";
	public static var TOP_RIGHT:String = "TR";
	public static var BOTTOM_LEFT:String = "BL";
	public static var BOTTOM_RIGHT:String = "BR";

	public var fps:DivElement;
	public var memory:DivElement;
	public var info:DivElement;

	var _time:Float;
	var _startTime:Float;
	var _prevTime:Float;
	var _ticks:Int;
	var _fps:Float;
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

		_pos = pos;
		_time = 0;
		_ticks = 0;
		_fps = 0;
		_fpsMin = Math.POSITIVE_INFINITY;
		_fpsMax = 0;
		_startTime = _prevTime = _now();

		_createFpsDom();
		if (_memCheck) _createMemoryDom();
		Browser.window.requestAnimationFrame(cast _tick);

		addInfo("Canvas - 2");
	}

	inline function _now():Float {
		return (_perfObj != null && _perfObj.now != null) ? _perfObj.now() : Date.now().getTime();
	}

	function _tick() {
		var time = _now();
		_ticks++;

		if (time > _prevTime + 1000) {
			_fps = Math.round((_ticks * 1000) / (time - _prevTime));
			_fpsMin = Math.min(_fpsMin, _fps);
			_fpsMax = Math.max(_fpsMax, _fps);

			fps.innerHTML =  "FPS: " + _fps + " (" + _fpsMin + "-" + _fpsMax + ")";

			_prevTime = time;
			_ticks = 0;

			if (_memCheck) memory.innerHTML = "MEM: " + _getFormattedSize(_memoryObj.usedJSHeapSize, 2);
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
				div.style.bottom = 28 - top + "px";
			case "BR":
				div.style.right = "0px";
				div.style.bottom = 28 - top + "px";
		}

		div.style.width = "80px";
		div.style.fontFamily = FONT_FAMILY;
		div.style.padding = "2px";
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

	function _createMemoryDom() {
		memory = _createDiv("memory", 14);
		memory.style.backgroundColor = MEM_BG_CLR;
		memory.style.color = MEM_TXT_CLR;
		memory.style.zIndex = "996";
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
		info = _createDiv("info", (_memCheck) ? 28 : 14);
		info.style.backgroundColor = INFO_BG_CLR;
		info.style.color = INFO_TXT_CLR;
		info.style.zIndex = "997";
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