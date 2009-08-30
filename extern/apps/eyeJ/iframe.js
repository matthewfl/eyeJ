// This file is part of eyeJ.
var eyeJ_iframe = true,
eyeJ_worker = false,
global = window;
try {
_INFO_ = {
	"checknum": __INFO__Checknum__
};
delete __INFO__Checknum__;
}catch (e) {}


function importScripts (url) {
	var e = document.createElement("script");
	e.src = url;
	e.type="text/javascript";
	document.getElementsByTagName("head")[0].appendChild(e);
}

function _MESSAGE (name, command) {
	command = [_INFO_].concat(command || []);
	try {
		command = JSON.stringify(command)
	} catch (E) {
		command = "[{checknum: \""+_INFO_.checknum+"\"}]";
	}
	parent['eyeJ_iframe_sandbox_'+_INFO_.checknum+'_call'](name, command);
}

function _NEWFUNCTION (name) {
	window[name] = function () {
		var a = [];
		for(var c = 0; c < arguments.length; c++)
			a.push(arguments[c]);
		_MESSAGE(name, a);
	};
}




_MESSAGE('-iframe-loaded-');