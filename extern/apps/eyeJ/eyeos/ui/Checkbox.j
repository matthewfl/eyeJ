@import <eyeos/ui/base.j>
@import <eyeos/eyeX.j>

@implementation Checkbox : uiBaseMost
{
 var Prams;
}

-(id) init
{
 [super init];
 Prams = {
  'enabled': 1,
  'visible': 1,
  'text': "check box",
  'tokens': 0,
  'checked': 0
 };
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

-(CPString) eyeXWidgetName
{
 return "Checkbox";
}

-(void) disable:(BOOL)b
{
 [self setPrams:'enabled' to:b*-1];
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

-(void) check:(BOOL)b
{
 [self setPrams:'checked' to:b];
 if([self showing])
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").checked='+b]
}

-(void) check
{
 [self check:YES];
}

-(void) uncheck
{
 [self check:NO];
}

-(BOOL) checked
{
 return [self eventInfo] == 'true';
}


-(void) text:(CPString)t
{
 [self setPrams:'text' to:t];
 if([self showing]) {
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").nextSibling.nodeValue="'+[eyeX jsSafe:t]+'";'];
  [eyeX rawjs:'document.getElementById("'+[self getName]+'").value="'+[eyeX jsSafe:t]+'";'];
 }
}

@end