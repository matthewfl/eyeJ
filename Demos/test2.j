@import <Foundation/CPObject.j>
@import <eyeos/server.j>
@import <eyeos/event.j>
@import <eyeos/eyeX.j>


@implementation Base : CPObject 
{
}

-(void) On:(Event)e
{
 //var s = [e getData];
 [eyeX message:"receved"];
 [eyeX message:[e getData]];
}

-(void) run
{
 [EyeOSEvent on:"what" act:@selector(On:) of:self];
}

@end


function main () {
 //var alert = function () {};
 try{
 //BindJSEvent('what', function () {alert('hi');});
 alert('loaded');
 var b = [Base new];
 [b run];
 alert('message');
 [eyeX message:"hello world"];
 alert('sendMessage');
 [eyeX sendRawMessage:"what" prams:"hello"];
 alert('exit');
 }catch(e){ alert(JSON.stringify(e)); }
}
