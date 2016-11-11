#import "SoundController.h"

@implementation SoundController
{
    //SystemSoundID soundID;
    NSString *soundPath;
    NSURL *soundUrl;
    AVAudioPlayer *player;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        soundPath = [[NSBundle mainBundle] pathForResource:@"beep2" ofType:@"caf"];
        soundUrl = [NSURL fileURLWithPath:soundPath];
        //AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundID);
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        //player.rate = 2.0;
    }
    return self;
}

- (void) playSound;
{
    //AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundID);
    //AudioServicesPlaySystemSound(soundID);
    [player play];
}

- (void) playSoundForDuration:(NSNumber *)time
{
    [self playSound];
    float val = [time floatValue];
    [self performSelector:@selector(stopSound) withObject:nil afterDelay:val];
}

- (void) stopSound
{
    //AudioServicesDisposeSystemSoundID(soundID);
    [player stop];
}

@end
