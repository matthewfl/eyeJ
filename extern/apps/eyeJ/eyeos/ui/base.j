@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>
@import <Foundation/CPNumber.j>
@import <Foundation/CPNull.j>
@import <json.j>
@import <eyeos/define.j>
@import <eyeos/eyeX.j>
@import <eyeos/event.j>

// the base object for all of the UI
@implementation uiBase : CPObject
{
 BOOL IsShowing;
 CPString Father;
 CPNumber X;
 CPNumber Y;
 CPNumber EyeXName;
 CPNumber Horiz;
 CPNumber Vert;
 CPNumber Center;
 CPString EventInfo;
 var Sync;
}

-(id) init
{
 [super init];
 IsShowing = NO;
 X = 20;
 Y = 20;
 Horiz = 0;
 Vert = 0;
 EyeXName = [eyeX createName];
 Father = "eyeApps";
 Sync = [];
 [EyeOSEvent addSync:[self getName] obj:self];
 [self addFriend:self];
 return self;
}

-(void) moreShow
{
}

-(void) show
{
 IsShowing = YES;
 var prams = [self showGetPrams]; // call inherited function
 // should line up with a eyeX name
 var widgetName = [self eyeXWidgetName];
 //self.isa.name; // The Name of the current object
 [eyeX createWidget:widgetName name:EyeXName father:Father params:prams x:X y:Y horiz:Horiz vert:Vert center:Center];
 [self moreShow];
}

-(BOOL) showing
{
 return IsShowing;
}

// for getting the name of the current object
-(CPString) getName
{
 return EyeXName;
}

-(CPString) getInName
{
 return [self getName];
}

// should be a CPString/string or a uiBase
-(void) father:(CPNull)_father
{
 if(typeof _father == "string")
  Father = _father;
 else // object
  Father = [_father getInName];
}

-(void) x:(CPNumber)_x
{
 X = _x;
}

-(void) y:(CPNumber)_y
{
 Y = _y;
}

-(void) horiz:(CPNumber)_horiz
{
 Horiz = _horiz;
}

-(void) vert:(CPNumber)_vert
{
 Vert = _vert;
}

-(void) center:(CPNumber)_center
{
 Center = _center;
}

// adding friends to widget
-(CPString) makeSyncList
{
 if(Sync.length == 0) return "''";
 var ret = "";
 for(var a = 0; a < Sync.length; a++) {
  ret += (ret == "" ? "" : ",") + Sync[a];
 }
 ret = "eyeJ.sync("+ret+")";
 return ret;
}

-(CPString) getFriendName
{
 return '"'+[self getName]+'"';
}

-(void) addFriend:(id)fri
{
 var n = [fri getFriendName];
 n = n.toString();
 Sync.push(n); 
}

-(void) addFriendName:(CPString)fri
{
 var n = fri.toString();
 Sync.push('"'+n+'"');
}

-(void) css:(CPString)pro value:(CPString)val
{
 [eyeX updateCss:[self getName] property:pro value:val];
}

// event data callback

-(void) eventSetInfo:(CPString)_info
{
 EventInfo = _info;
}

-(CPString) eventInfo
{
 return EventInfo;
}

-(void) addEvent:(CPString)_event args:(CPString)_args func:(CPString)_fun
{
 [eyeX addEvent:[self getName] event:_event func:_fun args:_args];
}

// short cut
-(void) x:(CPNumber)_x y:(CPNumber)_y
{
 [self x:_x];
 [self y:_y];
}

@end

// a ui base for most of the object, has code the is the most used
@implementation uiBaseMost : uiBase
{
}

-(id) init
{
 [super init];
 [eyeX deleteName:[self getName]+"_Container"];
 return self;
}

-(void) x:(CPNumber)_x
{
 [super x:_x];
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.left="'+_x+'px"'];
}

-(void) y:(CPNumber)_y
{
 [super y:_y];
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.top="'+_y+'px"'];
}

-(void) remove
{
 [eyeX removeWidget:[self getName]+"_Container"];
}

-(void)focus
{
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").focus();'];
}

-(void) hide:(BOOL)b
{
 try {
  [self setPram:"visible" to:b*-1];
 } catch (e) {}
 var t = b ? "none" : "block";
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.display="'+t+'"']
}

-(void) hide
{
 [self hide:YES];
}

-(void) unhide
{
 [self hide:NO];
}

-(void) focus
{
 if([self showing]) {
  [eyeX rawjs:"document.getElementById(\""+[self getName]+"\").focus();"];
 }
}


@end
