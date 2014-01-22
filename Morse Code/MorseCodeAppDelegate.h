//
//  MorseCodeAppDelegate.h
//  Morse Code
//
//  Created by Rick Wu on 25/12/2013.
//  Copyright (c) 2013 Rick Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MorseCodeAutoViewController.h"

#ifndef AUTO_VW_CTRLR_TABIDX
    #define AUTO_VW_CTRLR_TABIDX 0
#endif

#ifndef MANUAL_VW_CTRLR_TABIDX
    #define MANUAL_VW_CTRLR_TABIDX 1
#endif

@interface MorseCodeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
