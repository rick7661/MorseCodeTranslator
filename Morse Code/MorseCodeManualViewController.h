#import <UIKit/UIKit.h>
#import "CircleLineButton.h"
#import "FlashLightController.h"
#import "SoundController.h"
#import "OpenALSoundController.h"

@interface MorseCodeManualViewController : UIViewController

@property(strong) IBOutlet CircleLineButton *btnTap;
@property(strong) IBOutlet UISegmentedControl *segctlMode;

- (IBAction)btnTapDidTouchDown:(id)sender;
- (IBAction)btnTapDidTouchUp:(id)sender;
- (IBAction)segmentSwitch:(id)sender;

@end
