//
//  MorseCodeFirstViewController.m
//  Morse Code
//
//  Created by Rick Wu on 25/12/2013.
//  Copyright (c) 2013 Rick Wu. All rights reserved.
//

#import "MorseCodeFirstViewController.h"

@interface MorseCodeFirstViewController ()
@property(strong) FlashLightController *flashCtrl;
//@property(strong) SoundController *soundCtrl;
@property(strong) OpenALSoundController *soundCtrl;
@end

@implementation MorseCodeFirstViewController
{
    BOOL flashOn;
    BOOL soundOn;
}

@synthesize btnTap, segctlMode;
@synthesize flashCtrl, soundCtrl;

- (IBAction)btnTapDidTouchDown:(id)sender
{
    NSLog(@"touch down");
    if(flashOn) [flashCtrl turnFlashOn: YES];
    if(soundOn) [soundCtrl playSound];
}

- (IBAction)btnTapDidTouchUp:(id)sender
{
    if(flashOn) [flashCtrl turnFlashOn: NO];
    if(soundOn) [soundCtrl stopSound];
}

- (IBAction)segmentSwitch:(id)sender
{
    NSInteger selectedSegment = segctlMode.selectedSegmentIndex;
    
    switch (selectedSegment)
    {
        case 0:
            flashOn = YES;
            soundOn = NO;
            break;
        case 1:
            flashOn = YES;
            soundOn = YES;
            break;
        case 2:
            flashOn = NO;
            soundOn = YES;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    flashOn = YES;
    soundOn = YES;
    
    // Instantiate FlashLightController
    flashCtrl = [[FlashLightController alloc] init];
    
    // Instantiate SoundController
    //soundCtrl = [[SoundController alloc] init];
    soundCtrl = [[OpenALSoundController alloc] init];
    
    // Draw a circle around the button
    [self.btnTap drawCircleButton:[UIColor blueColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [soundCtrl initResource];
    [flashCtrl turnFlashOn:NO];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [soundCtrl releaseResource];
}

@end
