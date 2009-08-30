@import <eyeos/ui/Window.j>
@import <eyeos/ui/Label.j>
@import <eyeos/ui/Textbox.j>
@import <eyeos/ui/Button.j>
@import <eyeos/event.j>
@import <eyeos/server.j>


@implementation Control : CPObject
{
 Window wind;
 Button click;
 Label outPut;
 Textbox inPut;
}

-(void)on:(Event)e
{
 [outPut text:[inPut text]];
 [inPut text:""];
 [inPut focus];
}

-(void)load
{
 [eyeX flush:YES];
 [self draw];
}


-(void)draw
{
 wind = [Window new];
 [wind center:1];
 [wind height:150];
 [wind width:200];
 [wind title:"eyeJ - Hello world"];
 
 outPut = [Label new];
 [outPut father:wind];
 [outPut x:20 y:20];
 [outPut text:"Hello World!"];
 
 inPut = [Textbox new];
 [inPut father:wind];
 [inPut width:150];
 [inPut x:20 y:50];

 click = [Button new];
 [click father:wind];
 [click x:20 y:80];
 [click width:120];
 [click text:"Change Label Text"]; 

 [click onClick:@selector(on:) of:self]; 
 [click addFriend:inPut]; 

 [wind show];
 [outPut show];
 [inPut show];
 [click show];

 [inPut focus];
}

@end


function main () {
 try { 
 BindJSEvent("Close", exit);
 control = [Control new];
 [control load];
 }catch(e) { 
  var t = [json toString:e];
  alert(t);
  exit();
 }
}
