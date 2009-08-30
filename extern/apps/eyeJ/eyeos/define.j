@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>
@import <Foundation/CPNumber.j>

eyeJVersion = {
 str: "pre0.1alpha",
 major: 0,
 minor: 0,
 patch: 1,
 //   MMmmppp
 num: 0000001,
}

@implementation INFO : CPObject
{
}

+(CPString) checknum
{
 return _INFO_.checknum;
}

+(CPString) pid
{
 return _INFO_.pid;
}

@end

// the checksum for an application
@implementation EyeOSChecknum : CPString 
{
}

@end