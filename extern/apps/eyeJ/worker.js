// This file is part of eyeJ.
var _INFO_ = {},
eyeJ_iframe = false,
eyeJ_worker = true,
window = this,
global = {
	postMessage: null,
	onMessage: null,
	XMLHttpRequest: null,
	importScripts: null,
	_MESSAGE: null,
	_NEWFUNCTION: null,
	self: global,
	window: global,
	global: global,
	
};
function _MESSAGE (name, command) {
	command = [_INFO_].concat(command || []);
	postMessage(name+':'+JSON.stringify(command));
}
function _NEWFUNCTION (name) {
	window[name] = global[name] = function () {
		var a = [];
		for(var c = 0; c < arguments.length; c++)
			a.push(arguments[c]);
		_MESSAGE(name, a);
	};
}
onmessage = function (event) {
	try {
		if(event.data[0] == "@")
			eval(event.data.substring(1));
		else
			eval("with(global) { "+event.data+" }");
	}catch(e) {
		_MESSAGE('-error-', e);
	}
};
onerror = function (e) {
	_MESSAGE('-error-', [e]);
};