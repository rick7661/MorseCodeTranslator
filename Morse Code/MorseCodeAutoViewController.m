#import "MorseCodeAutoViewController.h"

@interface MorseCodeAutoViewController () // Extension
{
    // Declare private ivars here
}

// Declare private properties
@property(strong) FlashLightController *flashCtrl;
@property(strong) OpenALSoundController *soundCtrl;
@property(strong) MorseCoder *morse;
@property(strong) NSTimer *repeatTimer; // Used to schedule transimission sequences (E.g. dih-dah sequences)
@property(readwrite) BOOL transmitting; // re-declare a readonly property (as declared in header file) to readwrite so the class itself can edit the property while any outsider can only read
@property(readwrite) BOOL flashOn, soundOn, txtInputFirstTap;
@property(readwrite) float freq, dit, dah, tapIntrvl, charIntrvl, wordIntrvl, repeatIntrvl, waitTimeBeforeTap, delayBeforeRestartTransmission;


// Declare private methods
- (void) startTransmission;
- (void) startFirstTransmission;
- (void) translateText;
- (void) initTransmitVars;
- (void) transmit;
- (void) restartTransmission;
- (void) cancelTransmissionResourceRequests;
@end

@implementation MorseCodeAutoViewController
{
    // Declare private ivars here
}

// Synthesize public properties
@synthesize txtInput, txtvwCode, switchRepeat, sldrFrq, segctlMode, btnTransmit;

// Synthesize private properties
@synthesize flashCtrl, soundCtrl, morse, repeatTimer;
@synthesize transmitting, flashOn, soundOn, txtInputFirstTap;
@synthesize freq, dit, dah, tapIntrvl, charIntrvl, wordIntrvl, repeatIntrvl, waitTimeBeforeTap, delayBeforeRestartTransmission;


// This method clears the instruction text from txtInput only when the user tapped on it the 1st time
// From the 2nd tap and so on the original text entered by user will not be cleared fo user can edit its own input
- (IBAction) clearText:(id)sender
{
    if(txtInputFirstTap)
    {
        [txtInput setText:@""];
        txtInputFirstTap = NO;
    }
}

// This method reacts on user tapping "done" on keypad
// It dismisses the kaypad and translate the test from txtInput to Morse Code and display the Morse Code in txtvwCode
- (IBAction) textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    [self translateText];
}

// Reacts when user change the beep-frequency bar
- (IBAction) sliderChanged:(id)sender
{
    if ([switchRepeat isOn] && transmitting) [self restartTransmission];
    else [self stopTransmission];
}

// Reacts when user switches to light/beep/both mode
- (IBAction)segmentSwitch:(id)sender
{
    NSInteger selectedSegment = segctlMode.selectedSegmentIndex;
    
    switch (selectedSegment)
    {
        case 0: // only flash
            flashOn = YES;
            soundOn = NO;
            break;
        case 1: // both flash and sound
            flashOn = soundOn = YES;
            break;
        case 2: // only sound
            flashOn = NO;
            soundOn = YES;
            break;
        default:
            break;
    }
}

// Reacts when user change the switchRepeat toggle button and stops any ongoing transmission
- (IBAction) swtchRepeatValueChanged:(id)sender
{
    if (transmitting) [self stopTransmission];
}


/*****
 * Methods related to transmitting Morse Code
 *****/

// Reacts when user touching btnTransmit
- (IBAction) btnTransmitDidTouchedUp:(id)sender
{
    if (transmitting) [self stopTransmission]; // If its already transmitting, stop the transmission (btnTransmit should display text as "stop" before user touched it)
    else [self startTransmission]; // If not transmitting, start the transmission and pass boolean value from switchRepeat to indicate whether it will be a repeating transmission
}

// Start a transmission which is either repeating or non-repeating depends on the switchRepeat
- (void) startTransmission
{
    [self startFirstTransmission]; // Starts the transmission once (no matter repeating or not)
    
    // if in repeat mode, setup NSTimer for repeating transmission
    if ([switchRepeat isOn]) repeatTimer = [NSTimer  scheduledTimerWithTimeInterval:repeatIntrvl
                                        target:self
                                        selector:@selector(transmit)
                                        userInfo:nil
                                        repeats:YES];
    // else stop transmit after finishing the first transmission
    else [self performSelector:@selector(stopTransmission) withObject:nil afterDelay:repeatIntrvl];
}

// This method initiates the first transmission
- (void) startFirstTransmission
{
    [btnTransmit setTitle:@"Stop" forState:UIControlStateNormal];
    transmitting = YES;
    
    // start first transmission
    [self transmit];
}

- (void) stopTransmission
{
    [btnTransmit setTitle:@"Transmit" forState:UIControlStateNormal];
    transmitting = NO;
    [self cancelTransmissionResourceRequests];
}

- (void) cancelTransmissionResourceRequests
{
    [repeatTimer invalidate];
    [NSObject cancelPreviousPerformRequestsWithTarget:flashCtrl];
    [NSObject cancelPreviousPerformRequestsWithTarget:soundCtrl];
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // There may be more stopTransmit requests pending due to repeated tapping on the transmit button. They will stop subsequest transmits, so need to cancel the rest stopTransmit requests
    [flashCtrl turnFlashOn:NO];
    [soundCtrl stopSound];
}

- (void) restartTransmission
{
    [self cancelTransmissionResourceRequests];
    // The above code are the same as in stopTransmission method except the first two lines in stopTransmission method are omitted because we do not need to change btnTransmit's text and the boolean var
    delayBeforeRestartTransmission = 0.3;
    [self performSelector:@selector(startTransmission) withObject:nil afterDelay:delayBeforeRestartTransmission];
}

- (void) transmit
{
    // The duration of a dash is three times the duration of a dot.
    // Each dot or dash is followed by a short silence, equal to the dot duration.
    // The letters of a word are separated by a space equal to three dots (one dash),
    // and the words are separated by a space equal to seven dots.
    
    // Initialise transmission variables
    [self initTransmitVars];
    
    // Obtain code from user input
    NSString *code = txtvwCode.text;
    
    // For each Morse Code character
    char prevTap = '\0';
    char tap;
    for (int i = 0; i < code.length; i++)
    {
        tap = [code characterAtIndex:i];
        
        if (tap == '.')
        {
            NSNumber *arg = [NSNumber numberWithFloat:dit];
            
            if(soundOn) [soundCtrl performSelector:@selector(playSoundForDuration:) withObject:arg afterDelay:waitTimeBeforeTap];
            if(flashOn) [flashCtrl performSelector:@selector(flashLightOnForDuration:) withObject:arg afterDelay:waitTimeBeforeTap];
            
            // The waiting time before next tap has to be accumulated because the entire transmit sequence is generated before starting to tansmit
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
            // Two consecutive spaces together are an interval between two text words,
            // whereas one space is an interval between two ASCII characters
            // p.s. Since one tapInterval is already appended to each dit/dah, to append either wordInerval or charInterval after a dih/dah, one tapInterval has to be subtracted
            if (prevTap != '\0' && prevTap == ' ') waitTimeBeforeTap += (wordIntrvl - tapIntrvl);
            else waitTimeBeforeTap += (charIntrvl - tapIntrvl);
        }
        else
        {
            // Any unexpected code character (anything except {.- }) is interpreted as morse code space
            // p.s. Since one tapInterval is already appended to each dit/dah, to append either wordInerval or charInterval after a dih/dah, one tapInterval has to be subtracted
            waitTimeBeforeTap += (charIntrvl - tapIntrvl);
        }
        
        prevTap = tap;
    }
}

// Initialises variables used to control flash and beep transmissions
- (void) initTransmitVars
{
    freq = (sldrFrq.value + 1) * 0.06f; // Set frequency value
    dit = 1 * freq; // dit sound equals 1 frequency
    dah = 3 * freq; // dah sound equals 3 frequency
    tapIntrvl = 1 * freq; // Each dot or dash is followed by a short silence, equal to the dot duration
    charIntrvl = 3 * freq; // The letters of a word are separated by a space equal to three dots (one dash)
    wordIntrvl = 7 * freq; // The words are separated by a space equal to seven dots
    
    // Calculate repeat wait time
    NSString *code = txtvwCode.text; // Obtain the Morse Code text from txtvwCode
    repeatIntrvl = 0;
    char tap;
    char prevTap = '\0';
    for(int i = 0; i < code.length; i++)
    {
        tap = [code characterAtIndex:i];
        
        if (tap == '.') repeatIntrvl += (dit + tapIntrvl);
        else if (tap == '-') repeatIntrvl += (dah + tapIntrvl);
        else if (tap == ' ')
        {
            if (prevTap != '\0' && prevTap == ' ') repeatIntrvl += (wordIntrvl - tapIntrvl);
            else repeatIntrvl += (charIntrvl - tapIntrvl);
        }
        else repeatIntrvl += (charIntrvl - tapIntrvl);
        
        prevTap = tap; // At the end of each round the current tap becomes the previous tap
    }
    repeatIntrvl += (wordIntrvl * 2);
    
    waitTimeBeforeTap = 0; // This var needs to be reset
}

// Translate the text in txtInput to morse code and display in txtvwCode
- (void) translateText
{
    // Delete chars that are not allowed
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-/:;()$&@\".,?!'[]{}+=_ "] invertedSet];
    txtInput.text = [[txtInput.text componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    // Translate the text into morse code
    [txtvwCode setText:[morse translate:[txtInput text]]];
    
    // Set font and centre alignment
    txtvwCode.font = [UIFont fontWithName:@"Courier New" size:14];
    txtvwCode.textAlignment = NSTextAlignmentCenter;
    
    // Enable brnTransmit
    [btnTransmit setEnabled:YES];
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
    
    // Add gesture recognizer to detect a left swipe and go to next tab
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gotoManualTab:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
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
    if (transmitting) [self stopTransmission];
}

//
- (void)gotoManualTab:(id)sender
{
    [self.tabBarController setSelectedIndex:[self.tabBarController selectedIndex] + 1];
}

@end
