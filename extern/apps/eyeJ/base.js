/*
                                                                     JJJJJJJJJJJ
                                                                     J:::::::::J
                                                                     J:::::::::J
                                                                     JJ:::::::JJ
    eeeeeeeeeeee  yyyyyyy           yyyyyyy eeeeeeeeeeee               J:::::J
  ee::::::::::::ee y:::::y         y:::::yee::::::::::::ee             J:::::J
 e::::::eeeee:::::eey:::::y       y:::::ye::::::eeeee:::::ee           J:::::J
e::::::e     e:::::e y:::::y     y:::::ye::::::e     e:::::e           J:::::J
e:::::::eeeee::::::e  y:::::y   y:::::y e:::::::eeeee::::::e           J:::::J
e:::::::::::::::::e    y:::::y y:::::y  e:::::::::::::::::eJJJJJJJ     J:::::J
e::::::eeeeeeeeeee      y:::::y:::::y   e::::::eeeeeeeeeee J:::::J     J:::::J
e:::::::e                y:::::::::y    e:::::::e          J::::::J   J::::::J
e::::::::e                y:::::::y     e::::::::e         J:::::::JJJ:::::::J
 e::::::::eeeeeeee         y:::::y       e::::::::eeeeeeee  JJ:::::::::::::JJ
  ee:::::::::::::e        y:::::y         ee:::::::::::::e    JJ:::::::::JJ
    eeeeeeeeeeeeee       y:::::y            eeeeeeeeeeeeee      JJJJJJJJJ
                        y:::::y
                       y:::::y              version: 0.1
                      y:::::y
                     y:::::y
                    yyyyyyy

Created by: Matthew Francis-Landau <matthew@matthewfl.com>
http://matthewfl.com/eyeJ/

This file is part of eyeJ.

    eyeJ is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation version 3 of the License.

    eyeJ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with eyeJ.  If not, see <http://www.gnu.org/licenses/>.

*/


if(typeof eyeJ == "undefined") {
	eyeJ = {
		apps: {},
		end: function (checknum) {
			if(typeof eyeJ.apps[checknum] == "undefined") return;
			// stop the thread
			eyeJ.apps[checknum].thread.end();
			// clean up any ui
			var UI = eyeJ.apps[checknum].eyeX_UI;
			for(var name in UI) {
				try{
					var d = document.getElementById(name);
					if(d) // for speed
						d.parentNode.removeChild(d);
				} catch(e) {}
			}
			// kill the data
			delete eyeJ.apps[checknum];
			
		},
		Path: "index.php?version="+EXTERN_CACHE_VERSION+"&extern=apps/eyeJ",
		Thread: function (path) {
			var self = this;
			this._worker = new Worker(path+"/worker.js");
			this.actions = {};
			this.end = function () { // kill the worker
				this._worker.terminate();
			};
			this.eval = function (code) {
				code = "  \n"+code;
				this._worker.postMessage(code);
			};
			this.unSafe = function (code) {
				code = "@ \n" + code;
				this._worker.postMessage(code);
			};
			this.loadActions = function () {
				var load = "";
				for(var n in this.actions) {
					load += ";_NEWFUNCTION(\""+n+"\");"
				}
				this._worker.postMessage("@\n"+load);
			};
			this._worker.onmessage = function (event) {
				var data = event.data,
					loc = data.indexOf(":"),
					name = data.substring(0, loc);
				data = JSON.parse(data.substring(loc+1));
				if(self.actions[name])
					self.actions[name](data);
			};
		},
		setUpThread: function (FilePath, FileName, checkNum) {
			var t = new eyeJ.Thread(eyeJ.Path, checkNum);
			t.actions = eyeJ.actions;
			t.unSafe('OBJJ_INCLUDE_PATHS = ["'+eyeJ.Path+'", "'+FilePath+'"];');
			t.unSafe('OBJJ_MAIN_FILE = "'+FileName+'";');
			var im = 'if(typeof JSON == "undefined") importScripts("'+eyeJ.Path+'/json.js");\n' 
						+ 'importScripts("'+eyeJ.Path+'/Objective-J.js");';
			t.unSafe(im);
			return t;
		},
		actions: {
			//alert: function (p) { alert(p[1]); },
			eyeJ_alert: function (p) { alert(p[1]); },
			_MessageServer: function (p) {
				eyeJ.SendMessage(p[0].checknum, p[1], p[2] || "");
			},
			_SELF_terminate_: function (p) {
				eyeJ.end(p[0].checknum);
			},
			'-error-': function (d) {
				if(console.error) {
					console.error("eyeJ error\n" + JSON.stringify(d));
				}
				//alert("error:\n"+JSON.stringify(d));
			},
			_EYEX_SEND_XML_: function(d) {
				var xml = d[1];
				var xmlDoc;
				try {
					xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
					xmlDoc.async="false";
					xmlDoc.loadXML(xml);
				} catch(e) {
					var parser=new DOMParser();
					parser.async="false";
					xmlDoc=parser.parseFromString(xml,"text/xml");
				} 
				localEngine(xmlDoc);
			},
			_EYEX_ADD_NAME_: function (d) {
				eyeJ.apps[d[0].checknum].eyeX_UI[d[1]] = true;
			}
		},
		sync: function () {
			var out = {};
			for(var a = 0; a < arguments.length; a++) {
				try {
					var i = arguments[a];
					if(typeof i == "string")
						out[i] = document.getElementById(i).value;
					else
						out[i[0]] = i[1];
				}catch (e) {}
			}
			out = JSON.stringify(out);
			return out;
		}
	};
	// load a new application
	function eyeJ_load () {
		if(typeof window.eyeJLoadPid != "undefined" && window.eyeJLoadPid != null) {
			if(typeof eyeJ.apps[window.eyeJLoadCheckNum] == "undefined") {
				eyeJ.apps[window.eyeJLoadCheckNum] = {
					'thread': eyeJ.setUpThread(window.eyeJLoadFilePath, window.eyeJLoadCheckNum),
					'checknum': window.eyeJLoadCheckNum,
					'pid': window.eyeJLoadPid,
					'path': window.eyeJLoadFilePath,
					'file': window.eyeJLoadFileName,
					'eyeX_UI': {},
					'event': function (name, data) {
						this.thread.unSafe("_eyeosEventManager(\""+name+"\","+JSON.stringify(data)+");");
					}
				};
				var t = eyeJ.apps[window.eyeJLoadCheckNum].thread;
				t.unSafe('_INFO_ = {pid: "'+window.eyeJLoadPid+'", checknum:"'+window.eyeJLoadCheckNum+'"};');
				t.loadActions();
			}
			try {
				delete window.eyeJLoadPid;
				delete window.eyeJLoadCheckNum;
				delete window.eyeJLoadFilePath;
				delete window.eyeJLoadFileName;
			} catch (e) {
				try {
					window.eyeJLoadPid = null;
					window.eyeJLoadCheckNum = null;
					window.eyeJLoadFilePath = null;
					window.eyeJLoadFileName = null
				} catch (E) {} // I give up ie
			}
		}
	}
	// intercept the signals
	eyeJ.SendMessage = window.sendMsg;
	window.sendMsg = function (checknum, msg, prams) {
		if(typeof eyeJ.apps[checknum] == "undefined") {
			return eyeJ.SendMessage(checknum, msg, prams);
		}
		// running in eyeJ
		/*if(msg.indexOf("Server") != -1 || msg == "Event") {
			return eyeJ.SendMessage(checknum, msg, prams);
		}*/
		// send the message to the code sandbox
		eyeJ.apps[checknum].event(msg, prams);
	};
	if(typeof JSON == "undefined") {
		dhtmlLoadScript(eyeJ.Path+"/json.js");
	}
	
	try {
		// test a web worker out
		var w = new Worker(eyeJ.path+"/worker.js");
		if(!w) throw "no worker";
		w.postMessage(" \n");
		w.terminate();
	} catch (_error) { // no thread (Worker) support so load an iframe system
		eyeJ.Thread = function (path, checknum) {
			var self = this;
			this.actions = {};
			this.checknum = checknum;
			this._toRun = [];
			// http://dean.edwards.name/weblog/2006/11/sandbox/
			// create an <iframe>
			this._iframe = document.createElement("iframe");
			this._iframe.style.display = "none";
			document.body.appendChild(this._iframe);
			
			// write a script into the <iframe> and create the sandbox
			frames[frames.length - 1].document.write(
				"<html><head>"+
				"<script>"+
				"var MSIE/*@cc_on =1@*/;"+ // sniff
				"parent.eyeJ_iframe_sandbox_"+checknum+"_env=MSIE?this:{eval:function(s){return eval(s)}}"+
				"<\/script>"+
				"</head><body></body></html>"
			);
			frames[frames.length - 1].document.close(); // stop tell browser it is done loading
			window['eyeJ_iframe_sandbox_'+checknum+'_call'] = function (name, data) {
				self._action(name,data);
			};
			this._action = function (name, data) {
				if(this.actions[name])
					this.actions[name](JSON.parse(data));
				else if(name == '-iframe-loaded-')
					this._sendEvals();
			};
			this.eval = function (code) {
				if(this._toRun === false)
					window["eyeJ_iframe_sandbox_"+checknum+"_env"].eval(code);
				else {
					this._toRun.push(code);
				}
			};
			this._sendEvals = function () {
				while(this._toRun.length > 0) {
					window["eyeJ_iframe_sandbox_"+checknum+"_env"].eval(this._toRun.shift())
				}
				this._toRun = false;
			};
			// unSafe and eval are the same code in this system which is not good
			this.unSafe = this.eval;
			window["eyeJ_iframe_sandbox_"+checknum+"_env"].eval("__INFO__Checknum__ = \""+ checknum +"\"");
			window["eyeJ_iframe_sandbox_"+checknum+"_env"].eval(
				'var e = document.createElement("script");'+
				'e.src = "'+path+'/iframe.js";'+
				'e.type="text/javascript";'+
				'document.getElementsByTagName("head")[0].appendChild(e);'+
				'delete e;'
			);
			this.loadActions = function () {
				var load = "";
				for(var n in this.actions) {
					load += ";_NEWFUNCTION(\""+n+"\");"
				}
				this.eval(load);
			};
			this.end = function () {
				this._iframe.parentNode.removeChild(this._iframe); // will this kill the script or is there something else to do
				this._iframe = null;
				window["eyeJ_iframe_sandbox_"+checknum+"_env"] = null;
				window['eyeJ_iframe_sandbox_'+checknum+'_call'] = null;
			};
		}
		
	}
	/*
	var kkeys = [];
	window.addEventListener("keydown", function(e){
		kkeys.push( e.keyCode );
		if ( kkeys.toString().indexOf( "38,38,40,40,37,39,37,39,66,65" ) >= 0 )
		// one day this will do something and it will be cool ;)
	}, true); 
	*/
}

eyeJ_load();