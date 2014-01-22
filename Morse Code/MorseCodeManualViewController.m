//
//  MorseCodeFirstViewController.m
//  Morse Code
//
//  Created by Rick Wu on 25/12/2013.
//  Copyright (c) 2013 Rick Wu. All rights reserved.
//

#import "MorseCodeManualViewController.h"

@interface MorseCodeManualViewController ()
@property(strong) FlashLightController *flashCtrl;
@property(strong) OpenALSoundController *soundCtrl;
@end

@implementation MorseCodeManualViewController
{
    BOOL flashOn;
    BOOL soundOn;
}

@synthesize btnTap, segctlMode;
@synthesize flashCtrl, soundCtrl;

- (IBAction)btnTapDidTouchDown:(id)sender
{
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
            flashOn = soundOn = YES;
            break;
        case 2:
            flashOn = NO;
            soundOn = YES;
            break;
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
    
    // Add gesture recognizer to detect a right-swipe and go to previous tab
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAutoTab:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
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

- (void)gotoAutoTab:(id)sender
{
    [self.tabBarController setSelectedIndex:[self.tabBarController selectedIndex] - 1];
}

@end
