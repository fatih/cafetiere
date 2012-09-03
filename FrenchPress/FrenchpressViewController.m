#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>
#import "FrenchpressViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FrenchpressViewController ()

@end

@implementation FrenchpressViewController

@synthesize timerLabel, infoLabel, paintingTimer, coffeeTimer;
@synthesize startTime,  currentDate ;
@synthesize startDate, waterDate, bloomDate;
@synthesize sysCalendar;
@synthesize unitFlags;

@synthesize countdownSeconds, elapsedTime;

// Frenchpress view and images
@synthesize frenchPress;
@synthesize french1, french2, french3, french4, french5;

// Info and timer label background view and image
@synthesize infoBackground;
@synthesize infoBackgroundImage;

// Boolean variables for coffee countdown
@synthesize didEnded;

// Each step has a different time
@synthesize waterTime, bloomTime, steepTime, finishTime;

// Boolean variables for each state
@synthesize waterState, bloomState, steepState, finishState;

// Image array that contains the images for animation
@synthesize animationArrayBegin, animationArrayStir,
            animationArraySteep, animationArrayFinish;

@synthesize backgroundStart;


- (void)awakeFromNib {
}

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
//        [self setWaterTime:1];
//        [self setBloomTime:1];
//        [self setSteepTime:2];
//        [self setFinishTime:2];
        [self setCountdownSeconds:[self steepTime] + [self bloomTime] + [self waterTime]];
        
        // Set conversion to seconds and minutes
        [self setUnitFlags:NSSecondCalendarUnit | NSMinuteCalendarUnit];
    }
    return self;
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
    [self setFrench1:[UIImage imageNamed:@"fbegin_1"]];
    [self setFrench2:[UIImage imageNamed:@"fstir_2"]];
    [self setFrench3:[UIImage imageNamed:@"fsteep_3"]];
    [self setFrench4:[UIImage imageNamed:@"ffinish_4"]];
    [self setFrench5:[UIImage imageNamed:@"fpour_5"]];
    
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
    [self.infoBackground setImage:infoBackgroundImage];
    
    // Set drop shadow to the main frenchpress images
    self.frenchPress.layer.shadowColor = [UIColor blackColor].CGColor;
    self.frenchPress.layer.shadowOffset = CGSizeMake(1, -2);
    self.frenchPress.layer.shadowOpacity = 0.4;
    self.frenchPress.layer.shadowRadius = 2;
    self.frenchPress.clipsToBounds = NO;
    
    [self loadAnimationImages];
    [self cleanForNewStart];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startCoffee];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    
    [self cleanForNewStart];
    [self startCoffee];
}

-(void)cleanForNewStart
{
    [self stopTimers];
    [self setDidEnded:0];
    [self.frenchPress stopAnimating];
    
    [self setWaterState:0];
    [self setBloomState:0];
    [self setSteepState:0];
    [self setFinishState:0];
    [self.infoLabel setText:@"Starting"];
    [self.timerLabel setText:@"Cafetière"];
    [self setBackgroundStart:NO];
}

-(void)startCoffee
{
    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.duration = 1.5f;
    crossFade.fromValue = (__bridge id)([self.frenchPress image].CGImage);
    crossFade.toValue = (__bridge id)([UIImage imageNamed:@"fempty_0"].CGImage);
    [self.frenchPress.layer addAnimation:crossFade forKey:@"animateContents"];
    [self.frenchPress setImage:[UIImage imageNamed:@"fempty_0"]];
    
    
    [self playSoundWithName:@"coffeeStarted" type:@"wav"];
    self.coffeeTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                     target:self
                                                   selector:@selector (startCountdown)
                                                   userInfo:nil
                                                    repeats:NO];
            
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

-(void)startCountdown
{
    
    // Don't override startime if we come from background
    if (self.backgroundStart == NO) {
        self.startTime = [NSDate date];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.startTime forKey:@"startTime"];
        [defaults synchronize];
        NSLog(@"Data saved");
    }
    
    self.startDate = [[NSDate alloc] initWithTimeInterval:countdownSeconds sinceDate:startTime];
    self.waterDate = [[NSDate alloc] initWithTimeInterval:waterTime sinceDate:startTime];
    self.bloomDate = [[NSDate alloc] initWithTimeInterval:(waterTime + bloomTime) sinceDate:startTime];
    
    // Get the system calendar
    self.sysCalendar = [NSCalendar currentCalendar];
    
    self.paintingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                     target:self
                                                   selector:@selector (countdownUpdateMethod:)
                                                   userInfo:nil
                                                    repeats:YES];
}

-(void)countdownUpdateMethod:(NSTimer*)theTimer {
    self.currentDate = [NSDate date];
    self.elapsedTime = [self.currentDate timeIntervalSinceDate:self.startTime];
    
    NSDateComponents *conversionInfo = [self.sysCalendar components:self.unitFlags
                                                           fromDate:self.currentDate
                                                             toDate:self.startDate
                                                            options:0];

    NSDateComponents *waterInfo = [self.sysCalendar components:self.unitFlags
                                                      fromDate:self.currentDate
                                                        toDate:self.waterDate
                                                       options:0];
    
    NSDateComponents *bloomInfo = [self.sysCalendar components:self.unitFlags
                                                      fromDate:self.currentDate
                                                        toDate:self.bloomDate
                                                       options:0];
    
    // Display FrenchPress states and information steps
    if (self.elapsedTime <= [self waterTime]) {
        [self.timerLabel setText:[NSString stringWithFormat:@"%d", [waterInfo second]]];
        
        // Simple hack to prevent calling the same functions, assignments
        // Don't use BOOL for fooState variables...
        if (!self.waterState) {
            [self.infoLabel setText:@"Add preboiled water"];
            [self.frenchPress setImage:self.french1];
            [self.frenchPress setAnimationImages:self.animationArrayBegin];
            [self.frenchPress setAnimationDuration:[self waterTime]];
            [self.frenchPress setAnimationRepeatCount: 1];
            [self.frenchPress startAnimating];
            self.waterState = 1;
        }
        
    } else if (self.elapsedTime >= [self waterTime] &&
               self.elapsedTime <= [self waterTime] + [self bloomTime]) {
        // Bloom time
        [self.timerLabel setText:[NSString stringWithFormat:@"%d", [bloomInfo second]]];
        
        if (!self.bloomState) {
            
            
            [self.frenchPress stopAnimating]; // Stop previus begin animation
            [self.frenchPress setImage:self.french2];
            [self.infoLabel setText:@"Stir the coffee"];
            [self.frenchPress setAnimationImages:self.animationArrayStir];
            [self.frenchPress setAnimationDuration:[self bloomTime] / 2];
            [self.frenchPress setAnimationRepeatCount: 2];
            [self.frenchPress startAnimating];
            self.bloomState = 1;
        }
        
    } else if (self.elapsedTime >= [self waterTime] + [self bloomTime] &&
               self.elapsedTime <= [self countdownSeconds]) {
        
        if (!self.steepState) {
            [self.frenchPress stopAnimating];
            [self.frenchPress setImage:self.french3];
            [self.infoLabel setText:@"Steeping Time"];
            [self.frenchPress setAnimationImages:self.animationArraySteep];
            [self.frenchPress setAnimationDuration:[self steepTime]];
            [self.frenchPress setAnimationRepeatCount: 1];
            [self.frenchPress startAnimating];
            self.steepState = 1;
        }
        
        if ([conversionInfo second] <= 9) {
            [self.timerLabel setText:[NSString stringWithFormat:@"%d:0%d", [conversionInfo minute], [conversionInfo second]]];
        }  else {
            [self.timerLabel setText:[NSString stringWithFormat:@"%d:%d", [conversionInfo minute], [conversionInfo second]]];
        }
            
    } else if (self.elapsedTime >= [self countdownSeconds] &&
               self.elapsedTime <= [self countdownSeconds] + [self finishTime] + 1)
    {
        // Plung time
        if (!self.finishState) {
            [self.frenchPress setImage:self.french4];
            [self.infoLabel setText:@"Push plunger down"];
            [self.timerLabel setText:@"Finished"];
            [self playSoundWithName:@"coffeeFinished" type:@"wav"];
            
            [self.frenchPress setAnimationImages:self.animationArrayFinish];
            [self.frenchPress setAnimationDuration:[self finishTime]];
            [self.frenchPress setAnimationRepeatCount: 1];
            [self.frenchPress startAnimating];
            self.finishState = 1;
        }
        
    }  else if (self.elapsedTime >= [self countdownSeconds] + [self finishTime]) {
        
        self.didEnded = YES;
        [theTimer invalidate]; // Ok end this timer function, never come back
        [self.frenchPress stopAnimating];
        [self.infoLabel setText:@"Hold on the lid and pour"];
        [self.timerLabel setText:@"Enjoy"];
        [self.frenchPress setImage:[UIImage imageNamed:@"animFinish25"]];
        
        CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
        crossFade.duration = 1.0;
        crossFade.fromValue = (__bridge id)([UIImage imageNamed:@"animFinish25"].CGImage);
        crossFade.toValue = (__bridge id)(self.french5.CGImage);
        [self.frenchPress.layer addAnimation:crossFade forKey:@"animateContents"];
        [self.frenchPress setImage:self.french5];
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