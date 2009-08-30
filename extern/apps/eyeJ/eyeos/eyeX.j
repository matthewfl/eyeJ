@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>
@import <Foundation/CPNumber.j>
@import <eyeos/define.j>


var _EYEX_ = {
 'NameIndex':0,
 'pending': [],
 'flushOn': NO,
 'timer': nil,
 'xmlEncode': function (s) {
 try {
  return s.toString().replace(/\&/g,'&'+'amp;').replace(/</g,'&'+'lt;')
         .replace(/>/g,'&'+'gt;').replace(/\'/g,'&'+'apos;').replace(/\"/g,'&'+'quot;') || "";//'
  }catch(e) {
   return "";
  }
 },
 'toXml': function (obj) {
  if(typeof obj == "object") {
   var t = "";
   for(var n in obj) {
    t += "<" + n + ">";
    t += _EYEX_.toXml(obj[n]);
    t += "<\/" + n + ">";
   }
   return t;
  }else
   return _EYEX_.xmlEncode(obj);
 },
 'flush': function () {
  _EYEX_.timer = nil;
  if(_EYEX_.pending.length == 0) return;
  var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<eyeMessage>";
  while(_EYEX_.pending.length > 0) {
   var d = _EYEX_.pending.shift();
   var t = "<action>";
   t += _EYEX_.toXml(d);
   t+= "</action>";
   xml += t + "\n";
  }
  xml+= "<\/eyeMessage>";
  _EYEX_SEND_XML_(xml);
 },
 'Action': function (j) {
  if(typeof j.checknum == "undefined") j.checknum = _INFO_.checknum;
  _EYEX_.pending.push(j);
  if(_EYEX_.flushOn == NO)
   _EYEX_.flush();
  else {
   if(_EYEX_.timer != nil)
    clearTimeout(_EYEX_.timer);
   _EYEX_.timer = setTimeout(function () { _EYEX_.flush(); }, 40);
  }
 }
};



@implementation eyeX : CPObject 
{
}

// most function that could be directly called by the developer
// functions here can have an advance mode and a simple


+(void) flush
{
 _EYEX_.flush();
}

+(void) flush:(BOOL)_on
{
 _EYEX_.flushOn = _on;
}

+(var) jsSafe:(CPString)s
{ // what else do I need
 // return [json toString:s.toString()]; ?
 return s.toString().replace(/"/g, "\\\"").replace(/'/g, "\\\'").replace(/\n/g, "\\n").replace(/\r/g, "\\r");//'
}


+(void) rawjs:(CPString)js
{
 _EYEX_.Action({
  'task': "rawjs",
  'js': js
 });
}

+(void) loadScript:(CPString)url
{
 _EYEX_.Action({
  'task': "loadScript",
  'url': url
 });
}

+(void) LoadCSS:(CPString)url ID:(CPString)i
{
 _EYEX_.Action({
  "task": "loadCSS",
  "url": url,
  "id": i
 });
}

+(void) message:(CPString)str type:(CPNumber)num 
{
 _EYEX_.Action({
  'task': "messageBox",
  'content': str,
  'type': num
 });
}

+(void) message:(CPString)str
{
 [self message:str type:1];
}

+(void) sendRawMessage:(CPString)msg to:(CPString)_to prams:(CPString)p
{
 _EYEX_.Action({
  "task": "rawSendMessage",
  "checknum": _to,
  "msg": msg,
  "par": p
 });
}

+(void) sendRawMessage:(CPString)msg prams:(CPString)p
{
 [self sendRawMessage:msg to:_INFO_.checknum prams:p];
}

+(void) sendRawMessage:(CPString)msg
{
 [self sendRawMessage:msg prams:""];
}


+(void) setWallpaper:(CPString)url repeat:(CPNumber)rep center:(CPNumber)cen
{
 _EYEX_.Action({
  'task': "setWallpaper",
  'url': url,
  'repeat':rep,
  'center':cen
 });
}

+(void) setWallpaper:(CPString)url
{
 [self setWallpaper:url repeat:0 center:1]; 
}

+(void) check // here to check if eyeX is loaded, if calling it fails then eyeX is not loaded
{
}

// functions most likly called by UI


+(CPString) createName
{ 
// not in stander eyeX
// create a new name for a widget
 _EYEX_.NameIndex++;
 var n = _INFO_.pid + "_" + _EYEX_.NameIndex;
 _EYEX_ADD_NAME_(n.toString());
 return n;
}

+(void) deleteName:(CPString)n
{
 // add a name to be destroyed at the end of the program
 // do not worry about removing the names if the objects are removed
 _EYEX_ADD_NAME_(n.toString());
}

+(void) createWidget:(CPString)widgetname name:(CPString)_name father:(CPString)_father params:(CPString)_params x:(CPNumber)_x y:(CPNumber)_y horiz:(CPNumber)_horiz vert:(CPNumber)_vert center:(CPNumber)_center
{
 _EYEX_.Action({
  'task': "createWidget",
  'widgetname': widgetname,
  'name': _name,
  'father': _father,
  'params': _params,
  'cent': _center || "0",
  'position': {
   'x': _x,
   'y': _y,
   'horiz': _horiz,
   'vert': _vert
  }
 });
}

+(void) concatValue:(CPString)con widget:(CPString)widget
{
 _EYEX_.Action({
  'task': "concatDiv",
  'content': con,
  'widget': widget
 });
}

+(void) setDiv:(CPString)widget content:(CPString)content
{
 _EYEX_.Action({
  'task': "setDiv",
  'name': widget,
  'content': content
 });
}

+(void) setValue:(CPString)widget content:(CPString)content
{
 _EYEX_.Action({
  'task': "setValue",
  'widget': widget,
  'content': content
 });
}

+(void) removeCSS:(CPString)_name
{
 _EYEX_.Action({
  'task': "removeCSS",
  "id": _name
 });
}

+(void) removeWidget:(CPString)_name
{
 _EYEX_.Action({
  'task': "removeWidget",
  'name': _name
 });
}

+(void) createDiv:(CPString)_name class:(CPString)_class father:(CPString)_father
{
 _EYEX_.Action({
  'task': "createDiv",
  'name': _name,
  'class': _class,
  'father': _father
 });
}

+(void) updateCss:(CPString)_name property:(CPString)_pro value:(CPString)val
{
 _EYEX_.Action({
  'task': "updateCss",
  'name': _name,
  'property': _pro,
  'value': val
 });
}

+(void) makeDrag:(CPString)_name father:(CPString)_father noIndex:(CPNumber)Ind
{
 _EYEX_.Action({
  'task': "makeDrag",
  'name': _name,
  'father': _father,
  'noIndex': Ind // Z-index
 });
}

+(void) makeDrag:(CPString)_name father:(CPString)_father
{
 _EYEX_.Action({
  'task': "makeDrag",
  'name': _name,
  'father': _father
 });
}

+(void) addEvent:(CPString)_name event:(CPString)_event func:(CPString)fun args:(CPString)_args
{
 _EYEX_.Action({
  'task':"addEvent",
  'name': _name,
  'event': _event,
  'func': fun,
  'args': _args
 });
}

+(void) addEvent:(CPString)_name event:(CPString)_event func:(CPString)fun
{
 [self addEvent:_name event:_event func:fun args:""];
}

+(void) createLayer:(CPString)_name class:(CPString)_class father:(CPString)_father
{
 _EYEX_.Action({
  'task': "createLayer",
  'name': _name,
  'class': _class,
  'father': _father
 });
}

+(void) removeLayer:(CPString)_name
{
 _EYEX_.Action({
  'task': "removeLayer",
  'name': _name
 });
}

+(void) showLayer:(CPString)_name
{
 _EYEX_.Action({
  'task': "showLayer",
  'name': _name
 });
}

+(void) hideLayer:(CPString)_name
{
 _EYEX_.Action({
  'task': "hideLayer",
  'name': _name
 });
}

+(void) fadeOutLayer:(CPString)_name time:(CPNumber)_time start:(CPNumber)_start end:(CPNumber)_end
{
 _EYEX_.Action({
  'task': "fadeOutLayer",
  'name': _name,
  'time': _time,
  'startAlpha': _start,
  'endAlpha': _end
 });
}

+(void) fadeInLayer:(CPString)_name time:(CPNumber)_time start:(CPNumber)_start end:(CPNumber)_end
{
 _EYEX_.Action({
  'task': "fadeInLayer",
  'name': _name,
  'time': _time,
  'startAlpha': _start,
  'endAlpha': _end
 });
}

@end

