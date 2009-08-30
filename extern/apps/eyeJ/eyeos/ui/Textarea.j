@import <eyeos/ui/base.j>
@import <eyeos/eyeX.j>


@implementation Textarea : uiBase
{
 var Prams;
}

-(id) init
{
 [super init];
 Prams = {
  'enabled': 1,
  'visible': 1,
  'width': '',
  'height': '',
  'rich': 0,
  'code': 0,
  'lang': "",
  'rows': -1,
  'cols': -1,
  'cssClass': ''
 };
 [eyeX deleteName:[self getName]+'_Container'];
 return self;
}

-(CPString) showGetPrams
{
 // no sync
 return [json toString:Prams]; 
}

-(void) setPrams:(CPString)key to:(var)d
{
 if(typeof d == "string") d = d.toString();
 Prams[key] = d;
}

-(void) disable:(BOOL)b
{
 [self setPrams:'enabled' to:b*-1];
 if([self showing])
  if(Prams.code == 0) {
   [eyeX rawjs:'document.getElementById("'+[self getName]+'").disabled='+b];
  }else{
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_cp_iframe").disabled='+b];
  }
}

-(void) disable
{
 [self disable:YES];
}

-(void) enable
{
 [self disable:NO];
}

-(void) hide:(BOOL)b
{
 [self setPrams:'visible' to:b*-1];
 var t = b ? "none" : "block";
 if([self showing])
  if(Prams.code == 0) {
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.display="'+t+'"'];
  }else{
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_cp_iframe").style.display="'+t+'"'];
  }
}

-(void) hide
{
 [self hide:YES];
}

-(void) unhide
{
 [self hide:NO];
}

-(void) code:(CPString)lang
{
 [self setPrams:'code' to:1];
 [self setPrams:'lang' to:lang];
 [eyeX deleteName:[self getName]+'_cp_iframe'];
}

-(void) text:(CPString)txt
{
 if(Prams.code == 0) {
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").value="'+[eyeX jsSafe:txt]+'"'];
  if(Prams.rich == 1)
   [eyeX rawjs:"txtAreas['"+[self getName]+"_objTxt'].load()"];
 } else {
  [eyeX rawjs:'cp_'+[self getName]+'.setCode("")'];
  [eyeX rawjs:'document.getElementById("'+[self getName]+'_cp").value="'+[eyeX jsSafe:txt]+'"'];
  [eyeX rawjs:'cp_'+[self getName]+'.setCode(document.getElementById("'+[self getName]+'_cp").value)'];
 }
}

-(CPString) text
{
 return [self eventInfo];
}

-(CPString) getFriendName
{
 var s;
 if(Prams.rich == 1) {
  s = "txtAreas['"+[self getName]+"_objTxt'].getContent()";
 }else if(Prams.code == 1) {
  s = "cp_"+[self getName]+".getCode()";
 } else {
  return [self getName];
 }
 return "[\""+[self getName]+"\", "+s+"]";
}

-(void) focus
{
 [eyeX rawjs:'document.getElementById("'+[self getName]+'").focus();'];
}

-(void) width:(CPNumber)w
{
 [self setPrams:'width' to:w];
 if([self showing])
  if(Prams.code == 1) {
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_cp_iframe").style.width="'+w+'px";'];
  }else if(Prams.rich == 1) {
   [eyeX rawjs:'disableEdShadow("'+[self getName]+'_ifr");'];
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_tbl").style.width="'+w+'px";'];
   [eyeX rawjs:'enableShadow("'+[self getName]+'_ifr");'];
  }else{
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.width="'+w+'px";'];
   [eyeX rawjs:'document.getElementById("'+[self getName]+'").style.width="'+w+'px";'];
  }
}

-(void) height:(CPNumber)w
{
 [self setPrams:'height' to:w];
 if([self showing])
  if(Prams.code == 1) {
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_cp_iframe").style.height="'+w+'px";'];
  }else if(Prams.rich == 1) {
   [eyeX rawjs:'disableEdShadow("'+[self getName]+'_ifr");'];
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_tbl").style.height="'+w+'px";'];
   [eyeX rawjs:'enableShadow("'+[self getName]+'_ifr");'];
  }else{
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.height="'+w+'px";'];
   [eyeX rawjs:'document.getElementById("'+[self getName]+'").style.width="'+w+'px";'];
  }
}

-(void) x:(CPNumber)_x
{
 [super x:_x];
 if([self showing])
  if(Prams.code == 1)
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_cp_iframe").style.left="'+_x+'px";'];
  else
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.left="'+_x+'px";'];
}

-(void) y:(CPNumber)_y
{
 [super y:_y];
 if([self showing])
  if(Prams.code == 1)
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_cp_iframe").style.top="'+_y+'px";'];
  else
   [eyeX rawjs:'document.getElementById("'+[self getName]+'_Container").style.top="'+_y+'px";'];
}

-(void) remove
{
 if(Prams.code == 1)
  [eyeX removeWidget:[self getName]+'_cp_iframe'];
 else
  [eyeX removeWidget:[self getName]+'_Container'];
}

@end