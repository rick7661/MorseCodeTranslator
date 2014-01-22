//
//  FlashLightController.m
//  Morse Code
//
//  Created by Rick Wu on 29/12/2013.
//  Copyright (c) 2013 Rick Wu. All rights reserved.
//

#import "FlashLightController.h"

@implementation FlashLightController
{
    AVCaptureDevice *device;
}


- (id) init
{
    self = [super init];
    if (self)
    {
        // check if flashlight available
        
        //Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
        //if (captureDeviceClass) //check if it is not nil
        if ([AVCaptureDevice class])
        {
            device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
    }
    return self;
}

- (void) turnFlashOn: (BOOL) on
{
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        if (on)
        {
            [device setTorchMode:AVCaptureTorchModeOn];
            //[device setFlashMode:AVCaptureFlashModeOn];
            //torchIsOn = YES; //define as a variable/property if you need to know status
        }
        else
        {
            [device setTorchMode:AVCaptureTorchModeOff];
            //[device setFlashMode:AVCaptureFlashModeOff];
            //torchIsOn = NO;
        }
        [device unlockForConfiguration];
    }
}

- (void) flashLightOnForDuration:(NSNumber *)time
{
    [self flashOn];
    float val = [time floatValue];
    [self performSelector:@selector(flashOff) withObject:nil afterDelay:val];
}

- (void) flashOn
{
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device setFlashMode:AVCaptureFlashModeOn];
        [device unlockForConfiguration];
    }
}

- (void) flashOff
{
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device setFlashMode:AVCaptureFlashModeOff];
        [device unlockForConfiguration];
    }
}

@end
