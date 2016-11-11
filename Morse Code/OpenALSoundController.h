#import <Foundation/Foundation.h>
#import <OpenAl/al.h>
#import <OpenAl/alc.h>
#import <AudioToolbox/AudioToolbox.h>

@interface OpenALSoundController : NSObject

/*
 * To improve speed, error checking is not implemented.
 * If not used properly the program can crash or behave abnormally.
 * To use this class, make sure initResource is called before playSound, stopSound and playSoundForDuration:
 * Also make sure to call releaseResource before another instnce of OpenALSoundController (if any) starts playing sound
 */

- (void) initResource; // Must call initResource before playSound and stopSound
- (void) releaseResource; // Must call this if another instnce of OpenALSoundController wants to play sound
- (void) playSound;
- (void) stopSound;
- (void) playSoundForDuration: (NSNumber *) time;

@end
