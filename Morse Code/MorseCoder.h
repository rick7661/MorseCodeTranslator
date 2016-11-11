#import <Foundation/Foundation.h>

@interface MorseCoder : NSObject

@property (strong) NSDictionary *codebook;

- (NSString *) translate: (NSString *) asciiStr;

@end
