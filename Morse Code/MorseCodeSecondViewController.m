//
//  MorseCodeSecondViewController.m
//  Morse Code
//
//  Created by Rick Wu on 25/12/2013.
//  Copyright (c) 2013 Rick Wu. All rights reserved.
//

#import "MorseCodeSecondViewController.h"

@interface MorseCodeSecondViewController ()

// private properties declaration
@property(strong) FlashLightController *flashCtrl;
@property(strong) OpenALSoundController *soundCtrl;
@property(strong) MorseCoder *morse;

// private methods declaration
- (void) translateText;
- (void) initTransmitVars;
- (void) transmit;

@end


@implementation MorseCodeSecondViewController
{
    // private vars
    
    BOOL flashOn, soundOn;
    BOOL transmitting; //used to track if the app is transmitting morse code
    BOOL txtInputFirstTap;
    
    // vars for transmit
    float freq, dit, dah, tapIntrvl, charIntrvl, wordIntrvl, repeatIntrvl, waitTimeBeforeTap;
    NSTimer *repeatTimer;
}

// Synthesize public properties
@synthesize txtInput, txtvwCode, switchRepeat, sldrFrq, segctlMode, btnTransmit;

// Synthesize private properties
@synthesize flashCtrl, soundCtrl, morse;

- (IBAction) clearText:(id)sender
{
    if(txtInputFirstTap)
    {
        [txtInput setText:@""];
        txtInputFirstTap = NO;
    }
}

- (IBAction) textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    [self translateText];
}

- (IBAction) sliderChanged:(id)sender
{
    freq = sldrFrq.value;
    [self initTransmitVars]; // reset transmission vars based on freq
    
    // restart repeating transmittion, if it has started
    if([repeatTimer isValid])
    {
        [repeatTimer invalidate];
        repeatTimer = [NSTimer scheduledTimerWithTimeInterval:repeatIntrvl target:self selector:@selector(transmit) userInfo:nil repeats:YES];
    }

    //NSLog(@"Slider value: %f", freq);
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

- (IBAction) btnTransmitDidTouchedUp:(id)sender
{
    if (transmitting) [self stopTransmit];
    else [self startTransmitWithRepeat:[switchRepeat isOn]];
}

- (IBAction) swtchRepeatValueChanged:(id)sender
{
    if(transmitting) [self stopTransmit];
}

- (void) startTransmitWithRepeat:(BOOL)repeat
{
    [self startFirstTransmission];
    
    // if in repeat mode, setup NSTimer for repeating transmission
    if (repeat) repeatTimer = [NSTimer scheduledTimerWithTimeInterval:repeatIntrvl target:self selector:@selector(transmit) userInfo:nil repeats:YES];
    // else stop transmit after finishing the first transmission
    else [self performSelector:@selector(stopTransmit) withObject:nil afterDelay:repeatIntrvl];
}

- (void) startFirstTransmission
{
    [btnTransmit setTitle:@"Stop" forState:UIControlStateNormal];
    transmitting = YES;
    
    // Since [initTransmitVars] is called in [transmit] anyway
    // doing it here is only for initialising correct repeatIntrvl
    [self initTransmitVars];
    
    // start first transmit
    [self transmit];
}

- (void) stopTransmit
{
    [btnTransmit setTitle:@"Transmit" forState:UIControlStateNormal];
    transmitting = NO;
    [repeatTimer invalidate];
    [NSObject cancelPreviousPerformRequestsWithTarget:flashCtrl];
    [NSObject cancelPreviousPerformRequestsWithTarget:soundCtrl];
    [flashCtrl turnFlashOn:NO];
    [soundCtrl stopSound];
}

- (void) initTransmitVars
{
    freq = (sldrFrq.value + 1) * 0.06f;
    dit = 1 * freq;
    dah = 3 * freq;
    tapIntrvl = 1 * freq;
    charIntrvl = 3 * freq;
    wordIntrvl = 7 * freq;
    
    // calculate repeat wait time
    NSString *code = txtvwCode.text;
    repeatIntrvl = 0;
    for(int i = 0; i < code.length; i++)
    {
        char tap = [code characterAtIndex:i];
        
        if (tap == '.')
        {
            repeatIntrvl += (dit + tapIntrvl);
        }
        else if (tap == '-')
        {
            repeatIntrvl += (dah + tapIntrvl);
        }
        else if (tap == ' ')
        {
            repeatIntrvl += charIntrvl;
        }
        else
        {
            repeatIntrvl += charIntrvl;
        }
    }
    repeatIntrvl += wordIntrvl;
    
    waitTimeBeforeTap = 0;
}

// Translate the text in txtInput to morse code and display in txtvwCode
- (void) translateText
{
    [txtvwCode setText:[morse translate:[txtInput text]]];
    txtvwCode.font = [UIFont fontWithName:@"Courier New" size:14];
    [btnTransmit setEnabled:YES];
}

- (void) transmit
{
    // The duration of a dash is three times the duration of a dot.
    // Each dot or dash is followed by a short silence, equal to the dot duration.
    // The letters of a word are separated by a space equal to three dots (one dash),
    // and the words are separated by a space equal to seven dots.
    
    [self initTransmitVars];
    
    NSString *code = txtvwCode.text;
    
    for (int i = 0; i < code.length; i++)
    {
        char tap = [code characterAtIndex:i];
        
        if (tap == '.')
        {
            NSNumber *arg = [NSNumber numberWithFloat:dit];
            
            if(soundOn) [soundCtrl performSelector:@selector(playSoundForDuration:) withObject:arg afterDelay:waitTimeBeforeTap];
            
            if(flashOn) [flashCtrl performSelector:@selector(flashLightOnForDuration:) withObject:arg afterDelay:waitTimeBeforeTap];
            
            waitTimeBeforeTap += (dit + tapIntrvl);
        }
        else if (tap == '-')
        {
            NSNumber *arg = [NSNumber numberWithFloat:dah];
            
            if(soundOn) [soundCtrl performSelector:@selector(playSoundForDuration:) withObject:arg afterDelay:waitTimeBeforeTap];
            
            if(flashOn) [flashCtrl performSelector:@selector(flashLightOnForDuration:) withObject:arg afterDelay:waitTimeBeforeTap];
            
            
            waitTimeBeforeTap += (dah + tapIntrvl);
        }
        else if (tap == ' ')
        {
            waitTimeBeforeTap += charIntrvl;
        }
        else
        {
            waitTimeBeforeTap += charIntrvl;
        }
    }
}

// Hide keyboard when touched outside txtInput
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([txtInput isFirstResponder] && [touch view] != txtInput)
    {
        [txtInput resignFirstResponder];
        [self translateText];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // To make the border look very close to a UITextField
    [txtvwCode.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [txtvwCode.layer setBorderWidth:1.0];
    
    // The rounded corner part, where you specify your view's corner radius for UITextField:
    txtvwCode.layer.cornerRadius = 5;
    txtvwCode.clipsToBounds = YES;
    
    // Instantiate sound and flash light controller
    self.soundCtrl = [[OpenALSoundController alloc] init];
    self.flashCtrl = [[FlashLightController alloc] init];
    
    // Instantiate MorseCoder
    self.morse = [[MorseCoder alloc] init];
    
    // Display a little 'x' button in txtInput
    txtInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // Initialise environmental vars
    flashOn = YES;
    soundOn = YES;
    transmitting = NO;
    txtInputFirstTap = YES;
    [self initTransmitVars]; // initialise vars for transmit
    
    // Disable transmit button
    [btnTransmit setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    // initialise sound control resurce after view appeared
    // (i.e. Becomes visible)
    [soundCtrl initResource];
    [flashCtrl turnFlashOn:NO];
}

- (void) viewDidDisappear:(BOOL)animated
{
    // release sound control resurce after view disappeared
    // (i.e. Becomes invisible)
    [soundCtrl releaseResource];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (transmitting) [self stopTransmit];
}

- (void)applicationEnterBackground:(UIApplication *)application
{
    if (transmitting) [self stopTransmit];
}

@end
