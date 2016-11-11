#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FlashLightController : NSObject

- (void) turnFlashOn: (BOOL) on;
- (void) flashLightOnForDuration:(NSNumber *)time;

@end
