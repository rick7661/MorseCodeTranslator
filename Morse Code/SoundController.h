#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface SoundController : NSObject

- (void) playSound;
- (void) stopSound;
- (void) playSoundForDuration: (NSNumber *) time;

@end
