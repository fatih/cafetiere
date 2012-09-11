#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>
#import "FrenchpressViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AnimUIImageView.h"
#import "InAppSettingsKit/Controllers/IASKAppSettingsViewController.h"
#import "InAppSettingsKit/Models/IASKSpecifier.h"
#import "InAppSettingsKit/Models/IASKSettingsReader.h"

@interface FrenchpressViewController ()

@end

@implementation FrenchpressViewController

// Enum for each Coffee Step
CoffeState coffeeState;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.animationArrayBegin = [[NSMutableArray alloc] init];
        self.animationArrayStir = [[NSMutableArray alloc] init];
        self.animationArraySteep = [[NSMutableArray alloc] init];
        self.animationArrayFinish = [[NSMutableArray alloc] init];
        
        [self setSteepTime:241];
        [self setWaterTime:16];
        [self setBloomTime:6];
        [self setFinishTime:5];
        
        // TEST
//        [self setWaterTime:2];
//        [self setBloomTime:5];
//        [self setSteepTime:100];
//        [self setFinishTime:2];
        [self setCountdownSeconds:[self steepTime] + [self bloomTime] + [self waterTime]];
        
        // Set conversion to seconds and minutes
        [self setUnitFlags:NSSecondCalendarUnit | NSMinuteCalendarUnit];
        
        // Set the application defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"YES"
                                                                forKey:@"startAtLaunch"];
        [defaults registerDefaults:appDefaults];
        [defaults synchronize];
        
        [self loadAnimationImages];
    }
    return self;
}

// Needed because otherwise we can't initialize shadows to our
// custom AnimUIImageView class.
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.frenchPress = [[AnimUIImageView alloc] init];
}

-(IBAction)showSettingsPush:(id)sender
{
    self.appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
    self.appSettingsViewController.delegate = self;
    self.appSettingsViewController.showDoneButton = NO;
    self.appSettingsViewController.showCreditsFooter = NO;
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingDidChange:) name:kIASKAppSettingChanged object:nil];
    
    BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"addWaterStep"];
    NSLog(@"Add Water Step?: %u", enabled);
    self.appSettingsViewController.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"waterTime", nil];
    
    BOOL enabled_stir = [[NSUserDefaults standardUserDefaults] boolForKey:@"addStirStep"];
    NSLog(@"Add Stir Step?: %u", enabled_stir);
    self.appSettingsViewController.hiddenKeys = enabled_stir ? nil : [NSSet setWithObjects:@"stirTime", nil];
    
    [self.navigationController pushViewController:self.appSettingsViewController animated:YES];
    
}

- (void)settingDidChange:(NSNotification*)notification {
	if ([notification.object isEqual:@"addWaterStep"]) {
        NSLog(@"Add Water Step 2");
		BOOL enabled = (BOOL)[[notification.userInfo objectForKey:@"addWaterStep"] intValue];
		[self.appSettingsViewController setHiddenKeys:enabled ? nil : [NSSet setWithObjects:@"waterTime", nil] animated:YES];
	} else if ([notification.object isEqual:@"addStirStep"]) {
        NSLog(@"Add Stir Step 2");
		BOOL enabled_stir = (BOOL)[[notification.userInfo objectForKey:@"addStirStep"] intValue];
		[self.appSettingsViewController setHiddenKeys:enabled_stir ? nil : [NSSet setWithObjects:@"stirTime", nil] animated:YES];
        
    }
}


- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissModalViewControllerAnimated:YES];
	
	// your code here to reconfigure the app for changed settings
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"ViewDidLoad");
    
    if (!slideToCancel) {
		// Create the slider
		slideToCancel = [[SlideToCancelViewController alloc] init];
		slideToCancel.delegate = self;
		
		// Position the slider off the bottom of the view, so we can slide it up
		CGRect sliderFrame = slideToCancel.view.frame;
		sliderFrame.origin.y = self.view.frame.size.height;
		slideToCancel.view.frame = sliderFrame;
		
		[self.view addSubview:slideToCancel.view];
        [self enableSlider];
	}
    [self setInfoBackgroundImage:[UIImage imageNamed:@"timerBackground"]];
    
    //add background
    UIImage *backGround = [UIImage imageNamed:@"backgroundPSD"];
    UIImage *trackImage = [UIImage imageWithCGImage:[backGround CGImage]
                                     scale:2.0 orientation:UIImageOrientationUp];
    UIImageView *background = [[UIImageView alloc] initWithImage:trackImage];
    [self.view addSubview:background];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    [self.view sendSubviewToBack:background];
    
    // Timer/Info label background
    [self.infoBackground setImage:self.infoBackgroundImage];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:@"startAtLaunch"];
    
    if (enabled) {
        [self startCoffee];
    }
    
}

-(void)enableSlider {
	// Start the slider animation
	slideToCancel.enabled = YES;
	
	// Slowly move up the slider from the bottom of the screen
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0f];
    
	CGPoint sliderCenter = slideToCancel.view.center;
	sliderCenter.y -= slideToCancel.view.bounds.size.height;
	slideToCancel.view.center = sliderCenter;
	[UIView commitAnimations];
}

-(void)cancelled {
    // SlideToCancelDelegate method is called when the slider is slid all the way
    // to the right
	slideToCancel.enabled = YES;
    
    [self startCoffee];
}

-(void)cleanForNewStart
{
    [self stopTimers];
    
    [self setDidEnded:0];
    [self setDidCoffeeStarted:0];
    [self setDidCountdownStarted:0];
    [self setBackgroundStart:NO];
    
    [self.frenchPress setHasAnim:1];
    [self.frenchPress stopAnim];
    
    [self setWaterState:0];
    [self setBloomState:0];
    [self setSteepState:0];
    [self setFinishState:0];
    [self.infoLabel setText:@"Starting"];
    [self.timerLabel setText:@"Cafetière"];
}

-(void)stopTimers
{
    if (self.paintingTimer != nil) {
        [self.paintingTimer invalidate];
    }
    
    if (self.coffeeTimer != nil) {
        [self.coffeeTimer invalidate];
    }
}

-(void)startCoffee
{
    [self cleanForNewStart];
    
    NSLog(@"Cafetiere has Started");
    self.didCoffeeStarted = 1;
    
    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.duration = 1.5f;
    crossFade.fromValue = (__bridge id)([UIImage imageNamed:@"fempty_0"].CGImage);
    crossFade.toValue = (__bridge id)([UIImage imageNamed:@"animBegin25"].CGImage);
    
    [self.frenchPress.layer addAnimation:crossFade forKey:@"animateContents"];
    [self.frenchPress setImage:[UIImage imageNamed:@"animBegin25"]];
    
    [self playSoundWithName:@"coffeeStarted" type:@"wav"];
    self.coffeeTimer = [NSTimer scheduledTimerWithTimeInterval:2.5f
                                                     target:self
                                                      selector:@selector (startCountdown:)
                                                   userInfo:nil
                                                    repeats:NO];
}

-(void)startCountdown:(NSTimeInterval)timeGap
{
    NSLog(@"Countdown has started");
    
    // Don't override startime if we come from background
    if (self.backgroundStart == NO) {
        self.didCountdownStarted = 1;
        self.startTime = [NSDate date];
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:0];
        NSLog(@"State Start Date: %@", self.stateStartDate);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.startTime forKey:@"startTime"];
        [defaults synchronize];
    }
    
    self.startDate = [[NSDate alloc] initWithTimeInterval:self.countdownSeconds sinceDate:self.startTime];
    self.waterDate = [[NSDate alloc] initWithTimeInterval:self.waterTime sinceDate:self.startTime];
    self.bloomDate = [[NSDate alloc] initWithTimeInterval:(self.waterTime + self.bloomTime)
                                                sinceDate:self.startTime];
    
    // Get the system calendar
    self.sysCalendar = [NSCalendar currentCalendar];
    
    self.paintingTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                     target:self
                                                   selector:@selector (countdownUpdateMethod:)
                                                   userInfo:nil
                                                    repeats:YES];
}

-(void)countdownUpdateMethod:(NSTimer*)theTimer {
    
    NSDateComponents *conversionInfo = [self.sysCalendar components:self.unitFlags
                                                           fromDate:[NSDate date]
                                                             toDate:self.startDate
                                                            options:0];

    NSDateComponents *waterInfo = [self.sysCalendar components:self.unitFlags
                                                      fromDate:[NSDate date]
                                                        toDate:self.waterDate
                                                       options:0];
    
    NSDateComponents *bloomInfo = [self.sysCalendar components:self.unitFlags
                                                      fromDate:[NSDate date]
                                                        toDate:self.bloomDate
                                                       options:0];
    
    
    // Before we continue find our state
    [self getCurrentCoffeeState];
    
    switch (coffeeState) {
        case BeginState:
            break;
        case WaterState:
            {
                [self.timerLabel setText:[NSString stringWithFormat:@"%d", [waterInfo second]]];
                if (!self.waterState) {
                    NSLog(@"WaterState");
                    [self setWaterState:1];
                    [self.infoLabel setText:@"Add preboiled water"];
                    
                    [[self frenchPress] animImages:[self animationArrayBegin]];
                    [[self frenchPress] setAnimDuration:[self waterTime]];
                    [[self frenchPress] animRepeatCount: 1];
                    [[self frenchPress] startAnim];
                }
            }
            break;
        case StirState:
            {
                [self.timerLabel setText:[NSString stringWithFormat:@"%d", [bloomInfo second]]];
                
                if (!self.bloomState) {
                    NSLog(@"StirState");
                    [self setBloomState:1];
                    [self.infoLabel setText:@"Stir the coffee"];
                    
                    [self.frenchPress stopAnim]; // Stop previus begin animation
                    [[self frenchPress] animImages:[self animationArrayStir]];
                    [[self frenchPress] setAnimDuration:[self bloomTime]]; //TODO should /2
                    [[self frenchPress] animRepeatCount: 1]; // TODO should 2
                    [[self frenchPress] startAnim];
                }
            }
            break;
        case SteepState:
            {
                if (!self.steepState) {
                    NSLog(@"SteepState");
                    [self setSteepState:1];
                    [self.infoLabel setText:@"Steeping Time"];
                    
                    [self.frenchPress stopAnim]; // Stop previus begin animation
                    [[self frenchPress] animImages:[self animationArraySteep]];
                    [[self frenchPress] setAnimDuration:[self steepTime]];
                    [[self frenchPress] animRepeatCount: 1];
                    [[self frenchPress] startAnim];
                }
                
                if ([conversionInfo second] <= 9) {
                    [self.timerLabel setText:[NSString stringWithFormat:@"%d:0%d", [conversionInfo minute], [conversionInfo second]]];
                }  else {
                    [self.timerLabel setText:[NSString stringWithFormat:@"%d:%d", [conversionInfo minute], [conversionInfo second]]];
                }
            }
            break;
        case FinishState:
            {
                if (!self.finishState) {
                    NSLog(@"FinishState");
                    [self setFinishState:1];
                    [self.infoLabel setText:@"Push plunger down"];
                    [self.timerLabel setText:@"Finished"];
                    [self playSoundWithName:@"coffeeFinished" type:@"wav"];
                    
                    [self.frenchPress stopAnim]; // Stop previus begin animation
                    [[self frenchPress] animImages:[self animationArrayFinish]];
                    [[self frenchPress] setAnimDuration:[self finishTime]];
                    [[self frenchPress] animRepeatCount: 1];
                    [[self frenchPress] startAnim];
                }
            }
            break;
        case EnjoyState:
            {
                NSLog(@"EnjoyState");
                self.didEnded = YES;
                [theTimer invalidate]; // Ok end this timer function, never come back
                
                [self.frenchPress stopAnim]; // Stop previus begin animation
                [self.infoLabel setText:@"Hold on the lid and pour"];
                [self.timerLabel setText:@"Enjoy"];
                [self.frenchPress setImage:[UIImage imageNamed:@"animFinish25"]];
                [self setFrench5:[UIImage imageNamed:@"fpour_5"]];
                
                CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
                crossFade.duration = 1.0;
                crossFade.fromValue = (__bridge id)([UIImage imageNamed:@"animFinish25"].CGImage);
                crossFade.toValue = (__bridge id)(self.french5.CGImage);
                [self.frenchPress.layer addAnimation:crossFade forKey:@"animateContents"];
                [self.frenchPress setImage:self.french5];
            }
            break;
        default:
            break;
            
    }
}

-(void)getCurrentCoffeeState
{
    self.elapsedTime = [[NSDate date] timeIntervalSinceDate:self.startTime];
    // NSLog(@"Elapsed Time:%f", self.elapsedTime);
    
    if (self.elapsedTime <= [self waterTime]) {
        coffeeState = WaterState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:0];
        
    } else if (self.elapsedTime >= [self waterTime] &&
               self.elapsedTime < [self waterTime] + [self bloomTime]) {
        coffeeState = StirState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:[self waterTime]];
        
    } else if (self.elapsedTime >= [self waterTime] + [self bloomTime] &&
               self.elapsedTime < [self countdownSeconds]) {
        coffeeState = SteepState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:[self waterTime] + [self bloomTime]];
        
    } else if (self.elapsedTime >= [self countdownSeconds] &&
               self.elapsedTime < [self countdownSeconds] + [self finishTime]) {
        coffeeState = FinishState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:[self countdownSeconds]];
        
    }  else if (self.elapsedTime >= [self countdownSeconds] + [self finishTime]) {
        self.didEnded = YES;
        coffeeState = EnjoyState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:[self countdownSeconds] + [self finishTime]];
    }
    
    
    
}

-(void)loadAnimationImages
{
    
    for (NSUInteger i = 25; i > 0 ; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animBegin%02u", i]];
        if (image) {
            [self.animationArrayBegin addObject:image];
        }
    }
    
    for (NSUInteger i = 7; i < 14; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animStir%02u", i]];
        if (image) {
            [self.animationArrayStir addObject:image];
        }
    }
    
    for (NSUInteger i = 14; i > 0; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animStir%02u", i]];
        if (image) {
            [self.animationArrayStir addObject:image];
        }
    }
    
    for (NSUInteger i = 0; i <= 7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animStir%02u", i]];
        if (image) {
            [self.animationArrayStir addObject:image];
        }
    }
    
    for (NSUInteger i = 0; i <= 20; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animSteep%02u", i]];
        if (image) {
            [self.animationArraySteep addObject:image];
        }
    }
    
    for (NSUInteger i = 0; i <= 25; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animFinish%02u", i]];
        if (image) {
            [self.animationArrayFinish addObject:image];
        }
    }
}

-(void)playSoundWithName:(NSString *)fileName type:(NSString *)fileExtension
{
    
	CFStringRef cfFileName = (__bridge CFStringRef) fileName;
	CFStringRef cfFileExtension = (__bridge CFStringRef) fileExtension;
    
	CFBundleRef mainBundle;
	mainBundle = CFBundleGetMainBundle ();
    
	CFURLRef soundURLRef  = CFBundleCopyResourceURL (mainBundle, cfFileName, cfFileExtension, NULL);
    
	SystemSoundID soundID;
    
	AudioServicesCreateSystemSoundID (soundURLRef, &soundID);
	AudioServicesPlaySystemSound(soundID);
    
	CFRelease(soundURLRef);
}


@end