@import <eyeos/ui/base.j>
@import <eyeos/event.j>
@import <json.j>

@implementation Button : uiBaseMost
{
 var Prams;
}

-(id) init
{
 [super init];
 Prams = {
  "highlight":0,
  "enabled":1,
  "visible":1,
  "caption":"Click Me",
  //"sync":"''",
  "disablemsg":0,
  "signal":[self getName]+"_click",
  "forceMsg":0,
  "width":75,
  "height":25,
  "img":null,
  "imgX":null,
  "imgY":null,
  "imgWidth":null,
  "imgHeight":null
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

-(CPString) eyeXWidgetName
{
 return "Button";
}

-(void) width:(CPNumber)wid
{
 [self setPrams:"width" to:wid];
 if([self showing]) {
  [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.width="'+wid+'px";'];
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").style.width="'+wid+'px";'];
 }
}

-(void) height:(CPNumber)high
{
 [self setPrams:"height" to:high];
 if([self showing]) {
  [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.height="'+high+'px";'];
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").style.height="'+high+'px";'];
 }
}

-(void) caption:(CPString)str
{
 [self setPrams:"caption" to:str];
}

-(void) text:(CPString)str
{
 [self caption:str];
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").innerHTML= "'+[eyeX jsSafe:str]+'" ;'];
}

-(void) enabled:(BOOL)en
{
 [self setPrams:"enabled" to:en*1];
}

-(void) visible:(BOOL)vis
{
 [self setPrams:"visible" to:vis*1];
}

-(void) onClick:(SEL)_act of:(id)owner
{
 [EyeOSEvent on:Prams.signal act:_act of:owner];
}

-(void) disable:(BOOL)b
{
 [eyeX rawjs:'document.getElementById("'+[self getName]+'").disabled='+b];
}

-(void) enabled
{
 [self disable:NO];
}

-(void) disable
{
 [self disable:YES];
}

-(void) highlight
{
 [eyeX rawjs:'document.getElementById("'+[self getName]+'").style.fontWeight="bolder";'];
}

@end
