@import <Foundation/CPObject.j>
@import <eyeos/server.j>
@impoer <eyeos/event.j>

@implementation man : CPObject 
{
 CPString _s;
 EyeOsEvent e;
}

-(void) set:(CPString) s
{
 _s = s;
}

-(void) alert
{
 alert(_s); 
}

-(CPString) get
{
 return _s;
}

-(void) do
{
 [e call];
}
/*
-(void) setup
{
 e = [EyeOsEvent new];
 [e setAction:@selector(alert:)];
}
*/
@end

function main () {
 alert('main');
 var m = [man new];
 [m set:"hello world"];
 [m alert];
 //var s = [m get];
 //alert(s);
 exit();
}
