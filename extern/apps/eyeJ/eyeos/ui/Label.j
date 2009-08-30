@import <eyeos/ui/base.j>
@import <json.j>

@implementation Label : uiBaseMost
{
 var Prams;
}

-(id) init
{
 [super init];
 Prams = {
  "visible":1,
  "text":"A Label",
  //"sync":"''",
  "disablemsg":1,
  "signal":"textOpen"
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
 return "Label";
}

-(void) text:(CPString)_text
{
 [self setPrams:"text" to:_text];
 if([self showing]) {
  [eyeX rawjs:"document.getElementById(\""+[self getName]+"\").innerHTML=\"\""];
  [eyeX rawjs:"document.getElementById(\""+[self getName]+"\").appendChild(document.createTextNode( \""+[eyeX jsSafe:_text]+"\" ));"];
 }
}

@end
