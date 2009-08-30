function proc (command, args) {
	_MessageServer("Event", "proc-"+command+":"+JSON.stringify(args || {}));
}

function exit() {
 proc('end');
 _SELF_terminate_();
 if(window.eyeJ_worker)
  while(1); // hang
}