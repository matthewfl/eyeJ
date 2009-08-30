@import <eyeos/ui/base.j>
@import <json.j>

@implementation Textbox : uiBaseMost
{
 var Prams;
}

-(id) init
{
 [super init];
 Prams = {
  "text":"",
  "visible":1,
  "enabled":1,
  "password":0,
  "width":150,
  "noborder":0
 };
 return self;
}

-(void) moreShow
{
 [self addEvent:'onkeypress' args:'e' func:'var event = new xEvent(e);if(event.keyCode == 13){ sendMsg(\''+[INFO checknum]+'\',\''+[self getName]+'_eventEnter\',"'+[self makeSyncList]+'"); }'];
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
 return "Textbox";
}

-(void) text:(CPString)_text
{
 [self setPrams:"text" to:_text];
 if([self showing]) {
  [eyeX rawjs:"document.getElementById(\""+[self getName]+"\").value=\""+[eyeX jsSafe:_text]+"\""];
 }
}

-(CPString) text
{
 return [self eventInfo];
}

-(void) password:(BOOL)_b
{
 [self setPrams:"password" to:_b*1];
}

-(void) width:(CPNumber)widt
{
 [self setPrams:"width" to:widt];
}

-(void) border:(BOOL)_b
{
 [self setPrams:"noborder" to:(!_b)*1];
}



-(void) disable:(BOOL)b
{
 [self setPrams:"enabled" to:b*-1];
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").disabled='+b];
}

-(void) disable
{
 [self disable:YES];
}

-(void) enable
{
 [self disable:NO];
}

-(void) onEnter:(SEL)act of:(id)obj
{
 [EyeOSEvent on:[self getName]+'_eventEnter' act:act of:obj];
}

-(void)select
{
 [eyeX rawjs:'document.getElementById("'+[self getName]+'").select();'];
}

-(void) Align:(CPString)a
{
 [eyeX updateCss:[self getName] property:"text-align" value:a];
}

@end