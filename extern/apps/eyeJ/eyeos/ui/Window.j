@import <eyeos/ui/base.j>
@import <json.j>

@implementation Window : uiBase
{
 var Prams;
}

-(id) init
{
 [super init];
 Prams = {
  //"sync":"''",
  "height":150,
  "width":150,
  "minHeight":70,
  "minWidth":100,
  "title":"EyeJ",
  "type":1,
  "showtitle":1,
  "listed":1,
  "min":1,
  "min_pos":3,
  "max":1,
  "max_pos":2,
  "close":1,
  "close_pos":1,
  "resize":1,
  "nodrag":0,
  "sendCloseMsg":1,
  "sendResizeMsg":0,
  "background":"",
  "sigResize":[self getName]+"_Resize",
  "removeWin":1,
  "savePosition":0,
  "saveFunc":"",
  "xChecknum":_INFO_.checknum, // need to be this apps'
  "sigClose":"Close",
  "dragBgColor":0,
  "dragBgAlpha":"80",
  "showDragContent":false,
  "wMain":"eyeWindowMain",
  "wTitle":"eyeWindowTitle",
  "wTitleRight":"eyeWindowTitle_border_right",
  "wTitleLeft":"eyeWindowTitle_border_left",
  "wTitleCenter":"eyeWindowTitle_center",
  "wTitleText":"eyeWindowTitle_text",
  "wBottomCenter":"eyeWindowBottom_center",
  "wBottomRight":"eyeWindowBottom_right",
  "wBottomLeft":"eyeWindowBottom_left",
  "wLeft":"eyeWindowLeft",
  "wRight":"eyeWindowRight",
  "wContent":"eyeWindowContent",
  "noZindex":"",
  "allDrag":""
 };
 return self;
}

-(CPString) showGetPrams
{
 Prams.sync = [self makeSyncList];
 return [json toString:Prams]; 
}

-(void) setPrams:(CPString)key to:(var)d
{
 if(typeof d == "string") d = d.toString();
 Prams[key] = d;
}

-(CPString) getInName
{
 return [self getName]+"_Content";
}

-(CPString) eyeXWidgetName
{
 return "Window";
}

-(void) moreShow
{
 [self focus];
}

-(void) title:(CPString)_t
{
 [self setPrams:"title" to:_t];
 if([self showing]) {
  [eyeX rawjs:'document.getElementById("' + [self getName] + '_WindowTitle_text").innerHTML = "'+[eyeX jsSafe:_t]+'"; xGetElementById("' +[self getName]+ '_WindowOnBar").childNodes[0].innerHTML = "'+[eyeX jsSafe:_t]+'";'];
 }
}

-(void) height:(CPNumber)high
{
 [self setPrams:"height" to:high];
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").style.height="'+high+'px"'];
}

-(void) width:(CPNumber)widt
{
 [self setPrams:"width" to:widt];
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").style.width="'+widt+'px"'];
}

-(void) clear
{
 [eyeX rawjs:"document.getElementById(\""+[self getInName]+"\").innerHTML=\"\""];
}

-(void) focus
{
 [eyeX rawjs:"xZIndex(\""+[self getName]+"\",zindex);zindex++;"];
}

-(void) close
{
 [eyeX rawjs:"document.getElementById(\""+[self getName]+"\").parentNode.removeChild(document.getElementById(\""+[self getName]+"\"))"];
 // I think that I need more here
}

-(void) hide
{
 [eyeX rawjs:"document.getElementById(\""+[self getName]+"\").style.display=\"none\""];
}

-(void) unhide
{
 [eyeX rawjs:"document.getElementById(\""+[self getName]+"\").style.display=\"block\""]
}

-(void) x:(CPNumber)_x
{
 [super x:_x];
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").style.left="'+_x+'px"'];
}

-(void) y:(CPNumber)_y
{
 [super y:_y];
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").style.top="'+_x+'px"'];
}

-(void) RawContent:(CPString)raw
{
 [eyeX rawjs:"document.getElementById(\""+[self getName]+"\").innerHTML=\""+[eyeX jsSafe:raw]+"\""];
}

-(void) NoDrag:(BOOL)b
{
 [self setPrams:"nodrag" to:b*1];
 if([self showing])
  [eyeX rawjs:'xGetElementById("'+[self getName]+'").notDrag = '+b*1];
}

-(void) FullScreen
{
 // TODO: make this function
 throw "Window Full Screen function not done";
}

-(void) MaxButton:(BOOL)b
{
 [self setPrams:"max" to:b*1];
 var t = b ? "block" : "none";
 if([self showing])
  [eyeX rawjs:'xGetElementById("'+[self getName]+'_WindowMaxButton").style.display = "'+t+'";'];
}

-(void) MinimizeButton:(BOOL)b
{
 [self setPrams:"min" to:b*1];
 var t = b ? "block" : "none";
 if([self showing])
  [eyeX rawjs:'xGetElementById("'+[self getName]+'_WindowMinimizeButton").style.display = "'+t+'";'];
}

-(void) CloseButton:(BOOL)b
{
 [self setPrams:"close" to:b*1];
 var t = b ? "block" : "none";
 if([self showing])
  [eyeX rawjs:'xGetElementById("'+[self getName]+'_WindowCloseButton").style.display = "'+t+'";'];
}

-(void) ResizeButton:(BOOL)b
{
 [self setPrams:"resize" to:b*1];
 var t = b ? "block" : "none";
 if([self showing])
  [eyeX rawjs:'xGetElementById("'+[self getName]+'_WindowResizeButton").style.display = "'+t+'";'];
}

@end