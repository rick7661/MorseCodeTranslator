#import "MorseCoder.h"

@implementation MorseCoder

@synthesize codebook;

- (id) init
{
    self = [super init];
    if (self)
    {
        self.codebook = [NSDictionary dictionaryWithObjectsAndKeys:
                         @".-", @"a",
                         @"-...", @"b",
                         @"-.-.", @"c",
                         @"-..", @"d",
                         @".", @"e",
                         @"..-.", @"f",
                         @"--.", @"g",
                         @"....", @"h",
                         @"..", @"i",
                         @".---", @"j",
                         @"-.-", @"k",
                         @".-..", @"l",
                         @"--", @"m",
                         @"-.", @"n",
                         @"---", @"o",
                         @".--.", @"p",
                         @"--.-", @"q",
                         @".-.", @"r",
                         @"...", @"s",
                         @"-", @"t",
                         @"..-", @"u",
                         @"...-", @"v",
                         @".--", @"w",
                         @"-..-", @"x",
                         @"-.--", @"y",
                         @"--..", @"z",
                         @"-----", @"0",
                         @".----", @"1",
                         @"..---", @"2",
                         @"...--", @"3",
                         @"....-", @"4",
                         @".....", @"5",
                         @"-....", @"6",
                         @"--...", @"7",
                         @"---..", @"8",
                         @"----.", @"9",
                         @".-..-.", @"\"",
                         @"...-..-", @"$",
                         @".----.", @"'",
                         @"-.--.", @"(",
                         @"-.--.-", @")",
                         @"-.--.", @"[",
                         @"-.--.-", @"]",
                         @"-.--.", @"{",
                         @"-.--.-", @"}",
                         @".-.-.", @"+",
                         @"--..--", @",",
                         @"-....-", @"-",
                         @".-.-.-", @".",
                         @"-..-.", @"/",
                         @"---...", @":",
                         @"-.-.-.", @";",
                         @"-...-", @"=",
                         @"..--..", @"?",
                         @".--.-.", @"@",
                         @"._...", @"&",
                         @"..--.-", @"_",
                         @".-.-..", @"\n",
                         @"---.", @"!",
                         @" ", @" " /* A space character is just a spce */,
                         nil];
    }
    return self;
}

// Translate ASCII text t morse code, once character at a time into corresponding Morse Code codeword
- (NSString*) translate: (NSString*) asciiStr
{
    asciiStr = [asciiStr lowercaseString];
    NSMutableString *codeStr = [[NSMutableString alloc] init];
    
    int i = 0;
    while (i < asciiStr.length)
    {
        NSString *singleCharStr = [asciiStr substringWithRange:NSMakeRange(i++, 1)]; // extract one character
        
        NSString *code = [self.codebook objectForKey: singleCharStr]; // translate one character into Morse Code
        if(!code) code = @"?";
        
        [codeStr appendString:code]; // append the Morse Code codeword
        [codeStr appendString:@" "]; // append a space after a codeword
    }
    return codeStr;
}

@end
