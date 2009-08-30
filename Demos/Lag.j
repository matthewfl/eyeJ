/*
 add a lag to the system server calls, not to eyeJ calls
 how it would be when working with a slow server
*/

@import <eyeos/server.j>
@import <eyeos/eyeX.j>
@import <eyeos/event.j>
@import <eyeos/ui/Window.j>
@import <eyeos/ui/Label.j>
@import <eyeos/ui/Button.j>
@import <eyeos/ui/Textbox.j>

@implementation Control : CPObject
{
 Window wind;
 Textboc time;
 Button button;
 Label textLabel;
}

-(void)close:(Event)e
{
 [self setLag:0];
 //[eyeX rawjs:"eyeJ.SendMessage = LagSendMessage"];
 exit();
}

-(void)setLag:(CPNumber)t
{
 t = t*1000+1;
 [eyeX rawjs:"LagTime = "+t.toString()+";"];
 [eyeX flush];
}

-(void) load
{
 [eyeX flush:YES];
 [eyeX rawjs:"LagTime = 1;"];
 // we know that eyeJ will be loaded
 // the real message system is at eyeJ.SendMessage
 [eyeX rawjs:"if(typeof LagSendMessage == 'undefined') LagSendMessage = eyeJ.SendMessage;"]
 [eyeX rawjs:"eyeJ.SendMessage = function (a,b,c) { setTimeout(function () { LagSendMessage(a,b,c); }, LagTime); };"]
 [self draw];
 [EyeOSEvent on:"Close" act:@selector(close:) of:self];
 [eyeX flush];
 [eyeX flush:NO];
}

-(void)click:(Event)e
{
 var ti = [time text]*1;
 [self setLag:ti];
 [eyeX message:"Lag set to "+ti+" secs"];
}

-(void) draw
{
 wind = [Window new];
 [wind title:"Lag"];
 [wind height:150];
 [wind width:150];
 [wind center:1];

 textLabel = [Label new];
 [textLabel x:20 y:20];
 [textLabel father:wind];
 [textLabel text:"Server Lag"];

 time = [Textbox new];
 [time x:20 y:50];
 [time width:100];
 [time father:wind];
 [time text:"0"];

 button = [Button new];
 [button x:20 y:80];
 [button father:wind];
 [button text:"set Lag"];

 [button onClick:@selector(click:) of:self];
 [button addFriend:time];

 [wind show];
 [textLabel show];
 [time show];
 [button show];
}

@end

function main () {
 control = [Control new];
 [control load];
}
