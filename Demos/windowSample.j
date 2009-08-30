@import <eyeos/server.j>
@import <eyeos/ui/Window.j>
@import <eyeos/ui/Button.j>
@import <eyeos/ui/Label.j>
@import <eyeos/ui/Textbox.j>
@import <eyeos/event.j>


@implementation Control : CPObject
{
 Window Wind;
 Button But;
 Label Lab;
 Textbox Text;
}

-(void) click:(Event)e
{
 var t = [e getData];//[Text text];
 alert('got');
 alert(t);
}

-(void) run
{
 Wind = [Window new];
 [Wind center:1];
 [Wind height:100];
 [Wind width:300];
 [Wind title:"hello world"];

 But = [Button new];
 [But x:20 y:20];
 [But text:"hi"];
 [But father:Wind];
 [But onClick:@selector(click:) of:self];

 Lab = [Label new];
 [Lab x:120 y:20];
 [Lab text:"cool"];
 [Lab father:Wind];

 Text = [Textbox new];
 [Text x:140 y:20];
 [Text father:Wind];
 
 [But addFriend:Text];

 [Wind show];
 [But show];
 [Lab show];
 [Text show];
}


@end



function main() {
 try{
 BindJSEvent("Close", exit);
 [eyeX flush:YES];
 base = [Control new];
 [base run];
 }catch(e) { alert(JSON.stringify(e)); }
 //exit();
}

//function main () { exit(); }
