@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@implementation json : CPObject
{
}

+(var) parse:(CPString)s
{
 return JSON.parse(s.toString());
}

+(CPString) stringify:(var)data
{
 return JSON.stringify(data);
}

+(CPString) toString:(var)data
{
 return [self stringify:data];
}

+(var) toObj:(CPString)s
{
 return [self parse:s];
}

@end