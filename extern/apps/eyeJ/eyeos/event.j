// event manager

@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>
@import <json.j>

eyeosEventList = {};
eyeosEventCounter = 0;
eyeosEventUIList = {};



@implementation Event : CPObject 
{
 CPString data;
 var j;
}

-(void) _setData:(CPString)s
{
 try {
  data = s;
  j = [json toObj:s];
  for(var n in j) {
   try{
    [eyeosEventUIList[n] eventSetInfo:j[n]];
   }catch(e){}
  }
 }catch(e){}
}

-(CPString) getData
{
 return data;
}

-(var) get:(CPString)key
{
 return j[key.toString()];
}

@end



@implementation EyeOSEvent : CPObject
{
}

+(void) on:(CPString)_name act:(SEL)_act of:(id)owner
{
 eyeosEventList[_name.toString()] = {
  'fun': nil,
  'id': owner,
  'SEL': _act
 };
 //[owner performSelector:_act withObject:[Event new]];
} 

+(CPString) makeEvent:(SEL)_act of:(id)owner
{
 eyeosEventCounter++;
 var Ename = "JEvent_"+ eyeosEventCounter;
 [self on:Ename act:_act of:owner];
 return Ename;
}

+(void) addSync:(CPString)_name obj:(id)of
{
 eyeosEventUIList[_name.toString()] = of;
}

+(void) BuiltIn:(CPString)name data:(var)data cmd:(SEL)_cmd, of:(id)owner
{
 // for built in function calls to the server
 data.callBack = [EyeOSEvent makeEvent:_cmd of:owner];
 _MessageServer("Event", name+":"+JSON.stringify(data));
}

@end

function _eyeosEventManager (name, data) {
 if(typeof eyeosEventList[name] != "undefined") {
  if(eyeosEventList[name].id == nil && eyeosEventList[name].fun != nil) {
   eyeosEventList[name].fun(data);
  }else{
   var e = [Event new];
   [e _setData:data];
   [eyeosEventList[name].id performSelector:eyeosEventList[name].SEL withObject:e];
   //objj_msgSend(eyeosEventList[name].id, eyeosEventList[name].SEL, e);
  }
 }
}

function BindJSEvent(name, fun) {
 eyeosEventList[name] = {
  'fun': fun,
  'SEL': nil,
  'id': nil
 };
}