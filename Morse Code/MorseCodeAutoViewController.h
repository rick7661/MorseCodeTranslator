#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MorseCoder.h"
#import "FlashLightController.h"
#import "SoundController.h"
#import "OpenALSoundController.h"

@interface MorseCodeAutoViewController : UIViewController

@property(strong) IBOutlet UITextField *txtInput;
@property(strong) IBOutlet UITextView *txtvwCode;
@property(strong) IBOutlet UISwitch *switchRepeat;
@property(strong) IBOutlet UISlider *sldrFrq;
@property(strong) IBOutlet UIButton *btnTransmit;
@property(strong) IBOutlet UISegmentedControl *segctlMode;
@property(readonly) BOOL transmitting;

- (IBAction) textFieldReturn:(id)sender;
- (IBAction) clearText:(id)sender;
- (IBAction) segmentSwitch:(id)sender;
- (IBAction) btnTransmitDidTouchedUp:(id)sender;
- (IBAction) swtchRepeatValueChanged:(id)sender;
- (void) stopTransmission;

@end
