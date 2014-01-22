//
//  CircleLineButton.h
//  Morse Code
//
//  Created by Rick Wu on 28/12/2013.
//  Copyright (c) 2013 Rick Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> //for UIColor, can remove if this UIColor not needed

@interface CircleLineButton : UIButton

- (void) drawCircleButton: (UIColor*)color;

@end
