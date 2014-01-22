//
//  FlashLightController.h
//  Morse Code
//
//  Created by Rick Wu on 29/12/2013.
//  Copyright (c) 2013 Rick Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FlashLightController : NSObject

- (void) turnFlashOn: (BOOL) on;
- (void) flashLightOnForDuration:(NSNumber *)time;

@end
