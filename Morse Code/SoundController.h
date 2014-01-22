//
//  SoundController.h
//  Morse Code
//
//  Created by Rick Wu on 1/01/2014.
//  Copyright (c) 2014 Rick Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface SoundController : NSObject

- (void) playSound;
- (void) stopSound;
- (void) playSoundForDuration: (NSNumber *) time;

@end
