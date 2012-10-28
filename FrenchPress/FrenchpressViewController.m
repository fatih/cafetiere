#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "FrenchpressViewController.h"
#import "AnimUIImageView.h"
#import "Constants.h"
#import "UIDevice+Resolutions.h"
#import "PickerValueParser.h"
#import "IIViewDeckController.h"
#import "LeftViewController.h"

@interface FrenchpressViewController ()

@end

@implementation FrenchpressViewController

// Typedefs ...
FrenchPressCoffeeState coffeeState;
AeroPressCoffeeState aeroPressState;
BrewMethod brewMethod;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.frenchPressBegin = [[NSMutableArray alloc] init];
        self.frenchPressStir = [[NSMutableArray alloc] init];
        self.frenchPressSteep = [[NSMutableArray alloc] init];
        self.frenchPressFinish = [[NSMutableArray alloc] init];
        
        self.aeroPressBegin = [[NSMutableArray alloc] init];
        self.aeroPressStir = [[NSMutableArray alloc] init];
        self.aeroPressSteep = [[NSMutableArray alloc] init];
        self.aeroPressFinish = [[NSMutableArray alloc] init];
        
        // Set the application defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *appDefaults = @{@"startAtLaunch" : @"YES",
                                        @"frenchWaterTime" : kFrenchWaterTime,
                                        @"frenchStirTime" : kFrenchStirTime,
                                        @"frenchSteepTime" : kFrenchSteepTime,
                                        @"frenchFinishTime" : kFrenchFinishTime,
                                        @"aeroWaterTime" : kAeroWaterTime,
                                        @"aeroStirTime" : kAeroStirTime,
                                        @"aeroSteepTime" : kAeroSteepTime,
                                        @"aeroFinishTime" : kAeroFinishTime};
    
        [defaults registerDefaults:appDefaults];
        [defaults synchronize];
        
        // Set conversion to seconds and minutes
        [self setUnitFlags:NSSecondCalendarUnit | NSMinuteCalendarUnit];
        
        [self loadFrenchPressAnimationImages];
        [self loadAeroPressAnimationImages];
        
        NSLog(@"FrenchpressViewController init method");
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Custom hack to re-enable left controller. Because we are disabling it
    // in the Settings Push controller (via setting it to nil). Therefore assing a
    // left controller
    UIViewController* newController = [[LeftViewController alloc] init];
    self.viewDeckController.leftController = newController;
}


-(void)selectBrewMethod:(NSString *) method
{
    if ([method isEqualToString:@"French Press"]) {
        brewMethod = FrenchPress;
    } else if ([method isEqualToString:@"AeroPress"]) {
        brewMethod = AeroPress;
    };
}

-(BrewMethod)getBrewMethod
{
    return brewMethod;
}

-(void)setupBrewMethod
{
    switch (brewMethod) {
        case FrenchPress:
            {
                self.title = @"French Press"; // NavigationBar title
//                self.infoLabel.text = nil;
//                self.timerLabel.text = @"Slide to start";
                self.infoLabel.text = @"Slide to start";
                self.timerLabel.text = nil;
                
//                self.coffeeImageView.image = [UIImage imageNamed:@"animBegin25"];
                self.coffeeImageView.image = [UIImage imageNamed:@"animSteep20"];
                CATransition *animation = [CATransition animation];
                [animation setDuration:1.0];
                [animation setType:kCATransitionPush];
                [animation setSubtype:kCATransitionFromBottom];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [[self.coffeeImageView layer] addAnimation:animation forKey:@"SlideOutandInImagekCup"];
                
                // Get default values from settings
                NSTimeInterval cFrenchWaterTime = [[[NSUserDefaults standardUserDefaults] stringForKey:@"frenchWaterTime"] floatValue];
                NSTimeInterval cFrenchStirTime = [[[NSUserDefaults standardUserDefaults] stringForKey:@"frenchStirTime"] floatValue];
                NSTimeInterval cFrenchSteepTime = [[[NSUserDefaults standardUserDefaults] stringForKey:@"frenchSteepTime"] floatValue];
                NSTimeInterval cFrenchFinishTime = [[[NSUserDefaults standardUserDefaults] stringForKey:@"frenchFinishTime"] floatValue];
                [self setFrenchWaterTime:cFrenchWaterTime];
                [self setFrenchBloomTime:cFrenchStirTime];
                [self setFrenchSteepTime:cFrenchSteepTime];
                [self setFrenchFinishTime:cFrenchFinishTime];
                [self setFrenchTotalTime:[self frenchSteepTime] + [self frenchBloomTime] + [self frenchWaterTime]];
                
            }
            break;
        case AeroPress:
            {
                self.title = @"AeroPress"; // NavigationBar title
//                self.timerLabel.text = @"Slide to start";
//                self.infoLabel.text = nil;
                self.infoLabel.text = @"Slide to start";
                self.timerLabel.text = nil;
                
//                self.coffeeImageView.image = [UIImage imageNamed:@"aeroPressCup.png"];
                self.coffeeImageView.image = [UIImage imageNamed:@"aeroPress.png"];
                CATransition *animation = [CATransition animation];
                [animation setDuration:1.0];
                [animation setType:kCATransitionPush];
                [animation setSubtype:kCATransitionFromBottom];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [[self.coffeeImageView layer] addAnimation:animation forKey:@"SlideOutandInImagekCup"];
 
                
                NSTimeInterval cAeroWaterTime = [[[NSUserDefaults standardUserDefaults] stringForKey:@"aeroWaterTime"] floatValue];
                NSTimeInterval cAeroStirTime = [[[NSUserDefaults standardUserDefaults] stringForKey:@"aeroStirTime"] floatValue];
                NSTimeInterval cAeroSteepTime = [[[NSUserDefaults standardUserDefaults] stringForKey:@"aeroSteepTime"] floatValue];
                NSTimeInterval cAeroFinishTime = [[[NSUserDefaults standardUserDefaults] stringForKey:@"aeroFinishTime"] floatValue];
                [self setAeroWaterTime:cAeroWaterTime];
                [self setAeroBloomTime:cAeroStirTime];
                [self setAeroSteepTime:cAeroSteepTime];
                [self setAeroFinishTime:cAeroFinishTime];
                [self setAeroTotalTime:[self aeroSteepTime] + [self aeroBloomTime] + [self aeroWaterTime]];
            }
            break;
        default:
            break;
    }
}

-(void)viewDidLoad
{
//    NSLog(@"ViewDidLoad");
    [super viewDidLoad];
    
    
    UIButton *settingsView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [settingsView addTarget:self action:@selector(showSettingsPush) forControlEvents:UIControlEventTouchUpInside];
    [settingsView setBackgroundImage:[UIImage imageNamed:@"settingsGear_yeni.png"] forState:UIControlStateNormal];
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:settingsView];
    [self.navigationItem setRightBarButtonItem:settingsButton];
    
    UIButton *coffeeView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [coffeeView addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    [coffeeView setBackgroundImage:[UIImage imageNamed:@"coffee48.png"] forState:UIControlStateNormal];
    UIBarButtonItem *coffeeButton = [[UIBarButtonItem alloc] initWithCustomView:coffeeView];
    [self.navigationItem setLeftBarButtonItem:coffeeButton];
    
    if (!slideToCancel) {
		// Create the slider
		slideToCancel = [[SlideToCancelViewController alloc] init];
		slideToCancel.delegate = self;
		
		// Position the slider off the bottom of the view, so we can slide it up
		CGRect sliderFrame = slideToCancel.view.frame;
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        UIApplication *application = [UIApplication sharedApplication];
        if (application.statusBarHidden == NO)
        {
            size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
            size.height -= self.navigationController.navigationBar.frame.size.height;
        }
		sliderFrame.origin.y = size.height;
		slideToCancel.view.frame = sliderFrame;
		
		[self.view addSubview:slideToCancel.view];
        [self enableSlider];
	}
    
    [self setInfoBackgroundImage:[UIImage imageNamed:@"timerBackground"]];
    
    //add background
    if ([UIDevice currentResolution] == UIDevice_iPhoneHiRes || [UIDevice currentResolution] == UIDevice_iPadStandardRes) {
        NSLog(@"Iphone 3-4");
        self.defaultBackgroundImage = [UIImage imageNamed:@"Default@2x.png"];
    } else if ([UIDevice currentResolution] == UIDevice_iPhoneTallerHiRes) {
        NSLog(@"Iphone 5");
        self.defaultBackgroundImage = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    
    UIImage *trackImage = [UIImage imageWithCGImage:[self.defaultBackgroundImage CGImage]
                                     scale:2.0 orientation:UIImageOrientationUp];
    
    UIImageView *background = [[UIImageView alloc] initWithImage:trackImage];
    [self.view addSubview:background];
    self.view.contentMode = UIViewContentModeScaleAspectFit;
    [self.view sendSubviewToBack:background];
    
    // Timer/Info label background
    [self.infoBackground setImage:self.infoBackgroundImage];
    
    // Initial is set to 'French Press'
    [self setupBrewMethod];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:kStartAtLaunch];
    
    // Init picker
    if (enabled) {
        [self startCoffee];
    }
    
}

// Needed because otherwise we can't initialize shadows to our
// custom AnimUIImageView class.
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.coffeeImageView = [[AnimUIImageView alloc] init];
}

-(NSString *)secondsToMinAndSecString: (NSTimeInterval)timeIntervalSeconds
{
    // Converts 240 sec to 4:00
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeIntervalSeconds sinceDate:date1];
    NSDateComponents *conversionInfo = [sysCalendar components:self.unitFlags fromDate:date1  toDate:date2  options:0];
    
    return  [NSString stringWithFormat:@"%d:%d", [conversionInfo minute], [conversionInfo second]];
}

-(QPickerElement *)timePickerElementWithTitle: (NSString *) title DefaultKeyValue:(NSString *) value
{
    NSString *defaultValueString = [[NSUserDefaults standardUserDefaults] objectForKey:value];
    NSLog(@"Time for %@: %@", value, defaultValueString);
    NSString *defaultValueInMin = [self secondsToMinAndSecString:[defaultValueString floatValue]];
 
    PickerValueParser *timeParser = [[PickerValueParser alloc] init];
    QPickerElement *timerPicker =
    [[QPickerElement alloc] initWithTitle:title
                                    items:timeParser.timeValues
                                    value:defaultValueInMin];
    
    timerPicker.valueParser = timeParser;
    timerPicker.onValueChanged = ^{
        NSTimeInterval min = [timerPicker.selectedIndexes[0] floatValue];
        NSTimeInterval sec = [timerPicker.selectedIndexes[1] floatValue];
        NSString *timeInSeconds = [NSString stringWithFormat:@"%f", (60 * min) + sec];
        
        NSLog(@"Selected indexes: %@", [timerPicker.selectedIndexes componentsJoinedByString:@":"]);
        NSLog(@"Time in seconds: %@", timeInSeconds);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:timeInSeconds forKey:value];
        [defaults synchronize];
    };
    
    return timerPicker;
}

-(void)showSettingsPush
{
    // Otherwise sliding to right opens the ViewDeck
    self.viewDeckController.leftController = nil;
    
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Settings";
    root.grouped = YES;
    
    // Start Section
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:kStartAtLaunch];
    
    // QSection *startSection = [[QSection alloc] initWithTitle:@"Start at launch"];
    QSection *startSection = [[QSection alloc] init];
    QBooleanElement *startAtLaunch = [[QBooleanElement alloc] initWithTitle:@"Start timer at launch" BoolValue:enabled];
	startAtLaunch.key = @"startAtLaunchKey";
    startAtLaunch.onSelected = ^{
        if (startAtLaunch.boolValue) {
            NSLog(@"Boolean Enabled");
            [defaults setObject:@"YES" forKey:kStartAtLaunch];
        } else {
            NSLog(@"Boolean Disabled");
            [defaults setObject:@"NO" forKey:kStartAtLaunch];
        }
        [defaults synchronize];
    };
    [startSection addElement:startAtLaunch];
    [root addSection:startSection];
    
    
    // Timer Section
    switch (brewMethod) {
        case FrenchPress:
            {
                QSection *timeSection = [[QSection alloc] initWithTitle:@"Timer Settings (French Press)"];
                [timeSection addElement:[self timePickerElementWithTitle:@"Adding water" DefaultKeyValue:@"frenchWaterTime"]];
                [timeSection addElement:[self timePickerElementWithTitle:@"Stir coffee" DefaultKeyValue:@"frenchStirTime"]];
                [timeSection addElement:[self timePickerElementWithTitle:@"Steeping" DefaultKeyValue:@"frenchSteepTime"]];
                [root addSection:timeSection];
            }
            break;
        case AeroPress:
            {
                QSection *aeroTimeSection = [[QSection alloc] initWithTitle:@"Timer Settings (AeroPress)"];
                [aeroTimeSection addElement:[self timePickerElementWithTitle:@"Adding water" DefaultKeyValue:@"aeroWaterTime"]];
                [aeroTimeSection addElement:[self timePickerElementWithTitle:@"Stir coffee" DefaultKeyValue:@"aeroStirTime"]];
                [aeroTimeSection addElement:[self timePickerElementWithTitle:@"Steeping" DefaultKeyValue:@"aeroSteepTime"]];
                [aeroTimeSection addElement:[self timePickerElementWithTitle:@"Pressing down" DefaultKeyValue:@"aeroFinishTime"]];
                [root addSection:aeroTimeSection];
            }
            break;
        default:
            break;
    }
    
    // About Section
    QSection *aboutSection = [[QSection alloc] initWithTitle:@"About"];
    QLabelElement *labelVersion = [[QLabelElement alloc] initWithTitle:@"Version"
                                                                 Value:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    QLabelElement *labelSupport = [[QLabelElement alloc] initWithTitle:@"Support" Value:@"support@arsln.org"];
    [aboutSection addElement:labelVersion];
    [aboutSection addElement:labelSupport];
    [root addSection:aboutSection];
    
    [self setModalModeOn:YES];
    UIViewController *navigation = [QuickDialogController controllerForRoot:root];
    [self.navigationController pushViewController:navigation animated:YES];
}

-(void)enableSlider {
	// Start the slider animation
	slideToCancel.enabled = YES;
	
	// Slowly move up the slider from the bottom of the screen
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.5f];
    
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
    
    [self.coffeeImageView setHasAnim:1];
    [self.coffeeImageView stopAnim];
    [self.coffeeImageView setImage:nil];
    
    [self setWaterState:0];
    [self setBloomState:0];
    [self setSteepState:0];
    [self setFinishState:0];
    
    // self.timerLabel, self.infolabel and self.frenchpress is set in the method below
    [self setupBrewMethod];
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
    // Clean old variables and set up new variables for the choosen brew method
    [self cleanForNewStart];
    
    NSLog(@"Cafetiere has Started");
    self.didCoffeeStarted = 1;
    
    switch (brewMethod) {
        case FrenchPress:
            {
                self.infoLabel.text = @"Starting";
                self.coffeeImageView.image = [UIImage imageNamed:@"animBegin25"];
                CATransition *animation = [CATransition animation];
                [animation setDuration:1.0];
                [animation setType:kCATransitionPush];
                [animation setSubtype:kCATransitionFromBottom];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [[self.coffeeImageView layer] addAnimation:animation forKey:@"SlideOutandInImagek"];
            }
            break;
        case AeroPress:
            {
                self.infoLabel.text = @"Starting";
                self.coffeeImageView.image = [UIImage imageNamed:@"aeroPressBegin18.png"];
                CATransition *animation = [CATransition animation];
                [animation setDuration:1.0];
                [animation setType:kCATransitionPush];
                [animation setSubtype:kCATransitionFromBottom];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [[self.coffeeImageView layer] addAnimation:animation forKey:@"SlideOutandInImagek"];
            }
        default:
            break;
    }
    
    [self playSoundWithName:@"coffeeStarted" type:@"wav"];
    self.coffeeTimer = [NSTimer scheduledTimerWithTimeInterval:kStartTime
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
    
    
    // Get the system calendar
    self.sysCalendar = [NSCalendar currentCalendar];
    
    switch (brewMethod) {
        case FrenchPress:
            {
                self.startDate = [[NSDate alloc] initWithTimeInterval:self.frenchTotalTime sinceDate:self.startTime];
                self.waterDate = [[NSDate alloc] initWithTimeInterval:self.frenchWaterTime sinceDate:self.startTime];
                self.bloomDate = [[NSDate alloc] initWithTimeInterval:(self.frenchWaterTime + self.frenchBloomTime)
                                                            sinceDate:self.startTime];
                
                self.paintingTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                     target:self
                                                   selector:@selector (beginFrenchPress:)
                                                   userInfo:nil
                                                    repeats:YES];
            }
            break;
        case AeroPress:
            {
                self.startDate = [[NSDate alloc] initWithTimeInterval:self.aeroTotalTime sinceDate:self.startTime];
                self.waterDate = [[NSDate alloc] initWithTimeInterval:self.aeroWaterTime sinceDate:self.startTime];
                self.bloomDate = [[NSDate alloc] initWithTimeInterval:(self.aeroWaterTime + self.aeroBloomTime)
                                                            sinceDate:self.startTime];
                
                self.paintingTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f
                                                     target:self
                                                   selector:@selector (beginAeroPress:)
                                                   userInfo:nil
                                                    repeats:YES];
                
            }
            break;
        default:
            break;
    }
}

-(void)beginAeroPress:(NSTimer*)theTimer {
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
        case FrenchBeginState:
            break;
        case FrenchWaterState:
            {
                [self.timerLabel setText:[NSString stringWithFormat:@"%d", [waterInfo second]]];
                if (!self.waterState) {
                    NSLog(@"WaterState");
                    [self setWaterState:1];
                    [self.infoLabel setText:@"Add preboiled water"];
                    
                    [[self coffeeImageView] animImages:[self aeroPressBegin]];
                    [[self coffeeImageView] setAnimDuration:[self aeroWaterTime]];
                    [[self coffeeImageView] animRepeatCount: 1];
                    [[self coffeeImageView] startAnim];
                }
            }
            break;
        case FrenchStirState:
            {
                [self.timerLabel setText:[NSString stringWithFormat:@"%d", [bloomInfo second]]];
                
                if (!self.bloomState) {
                    NSLog(@"StirState");
                    [self setBloomState:1];
                    [self.infoLabel setText:@"Stir the coffee"];
                    
                    [self.coffeeImageView stopAnim]; // Stop previus begin animation
                    [[self coffeeImageView] animImages:[self aeroPressStir]];
                    [[self coffeeImageView] setAnimDuration:[self aeroBloomTime] / 1]; //TODO should /2
                    [[self coffeeImageView] animRepeatCount: 1]; // TODO should 2
                    [[self coffeeImageView] startAnim];
                }
            }
            break;
        case FrenchSteepState:
            {
                if (!self.steepState) {
                    NSLog(@"SteepState");
                    [self setSteepState:1];
                    [self.infoLabel setText:@"Steeping Time"];
                    
                    [self.coffeeImageView stopAnim]; // Stop previus begin animation
                    [[self coffeeImageView] animImages:[self aeroPressSteep]];
                    [[self coffeeImageView] setAnimDuration:[self aeroSteepTime]];
                    [[self coffeeImageView] animRepeatCount: 1];
                    [[self coffeeImageView] startAnim];
                }
                
                if ([conversionInfo second] <= 9) {
                    [self.timerLabel setText:[NSString stringWithFormat:@"%d:0%d", [conversionInfo minute], [conversionInfo second]]];
                }  else {
                    [self.timerLabel setText:[NSString stringWithFormat:@"%d:%d", [conversionInfo minute], [conversionInfo second]]];
                }
            }
            break;
        case FrenchFinishState:
            {
                if (!self.finishState) {
                    NSLog(@"FinishState");
                    [self setFinishState:1];
                    [self.infoLabel setText:@"Gently press down"];
                    [self.timerLabel setText:@"Ready"];
                    [self playSoundWithName:@"coffeeFinished" type:@"wav"];
                    
                    [self.coffeeImageView stopAnim]; // Stop previus begin animation
                    [[self coffeeImageView] animImages:[self aeroPressFinish]];
                    [[self coffeeImageView] setAnimDuration:[self aeroFinishTime]];
                    [[self coffeeImageView] animRepeatCount: 1];
                    [[self coffeeImageView] startAnim];
                }
            }
            break;
        case FrenchEnjoyState:
            {
                NSLog(@"EnjoyState");
                self.didEnded = YES;
                [theTimer invalidate]; // Ok end this timer function, never come back
                [self.coffeeImageView stopAnim]; // Stop previus begin animation
                [self.infoLabel setText:@""];
                [self.timerLabel setText:@"Enjoy"];
                
                [self.coffeeImageView stopAnim]; // Stop previus begin animation
                [self.infoLabel setText:@""];
                [self.timerLabel setText:@"Enjoy"];
                
                self.coffeeImageView.image = [UIImage imageNamed:@"aeroPressReady.png"];
                CATransition *animation = [CATransition animation];
                [animation setDuration:1];
                [animation setType:kCATransitionPush];
                [animation setSubtype:kCATransitionFromBottom];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [[self.coffeeImageView layer] addAnimation:animation forKey:@"SlideOutandInImagek"];
                
                
            }
            break;
        default:
            break;
    }
    
}

-(void)beginFrenchPress:(NSTimer*)theTimer {
    
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
        case FrenchBeginState:
            break;
        case FrenchWaterState:
            {
                [self.timerLabel setText:[NSString stringWithFormat:@"%d", [waterInfo second]]];
                if (!self.waterState) {
                    NSLog(@"WaterState");
                    [self setWaterState:1];
                    [self.infoLabel setText:@"Add preboiled water"];
                    [[self coffeeImageView] animImages:[self frenchPressBegin]];
                    [[self coffeeImageView] setAnimDuration:[self frenchWaterTime ]];
                    [[self coffeeImageView] animRepeatCount: 1];
                    [[self coffeeImageView] startAnim];
                }
            }
            break;
        case FrenchStirState:
            {
                [self.timerLabel setText:[NSString stringWithFormat:@"%d", [bloomInfo second]]];
                

                
                if (!self.bloomState) {
                    NSLog(@"StirState");
                    
//                self.coffeeImageView.image = [UIImage imageNamed:@"animStir07.png"];
//                CATransition *animation = [CATransition animation];
//                [animation setDuration:1.0];
//                [animation setType:kCATransitionPush];
//                [animation setSubtype:kCATransitionFromBottom];
//                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//                [[self.coffeeImageView layer] addAnimation:animation forKey:@"SlideOutandInImagek"];
                    
                    [self setBloomState:1];
                    [self.infoLabel setText:@"Stir the coffee"];
                    
                    [self.coffeeImageView stopAnim]; // Stop previus begin animation
                    [[self coffeeImageView] animImages:[self frenchPressStir]];
                    [[self coffeeImageView] setAnimDuration:[self frenchBloomTime] / 1]; //TODO should /2
                    [[self coffeeImageView] animRepeatCount: 1]; // TODO should 2
                    [[self coffeeImageView] startAnim];
                }
            }
            break;
        case FrenchSteepState:
            {
                if (!self.steepState) {
                    NSLog(@"SteepState");
                    [self setSteepState:1];
                    [self.infoLabel setText:@"Steeping Time"];
                    
                    [self.coffeeImageView stopAnim]; // Stop previus begin animation
                    [[self coffeeImageView] animImages:[self frenchPressSteep]];
                    [[self coffeeImageView] setAnimDuration:[self frenchSteepTime]];
                    [[self coffeeImageView] animRepeatCount: 1];
                    [[self coffeeImageView] startAnim];
                }
                
                if ([conversionInfo second] <= 9) {
                    [self.timerLabel setText:[NSString stringWithFormat:@"%d:0%d", [conversionInfo minute], [conversionInfo second]]];
                }  else {
                    [self.timerLabel setText:[NSString stringWithFormat:@"%d:%d", [conversionInfo minute], [conversionInfo second]]];
                }
            }
            break;
        case FrenchFinishState:
            {
                if (!self.finishState) {
                    NSLog(@"FinishState");
                    [self setFinishState:1];
                    [self.infoLabel setText:@"Push plunger down"];
                    [self.timerLabel setText:@"Ready"];
                    [self playSoundWithName:@"coffeeFinished" type:@"wav"];
                    
                    [self.coffeeImageView stopAnim]; // Stop previus begin animation
                    [[self coffeeImageView] animImages:[self frenchPressFinish]];
                    [[self coffeeImageView] setAnimDuration:[self frenchFinishTime ]];
                    [[self coffeeImageView] animRepeatCount: 1];
                    [[self coffeeImageView] startAnim];
                }
            }
            break;
        case FrenchEnjoyState:
            {
                NSLog(@"EnjoyState");
                self.didEnded = YES;
                [theTimer invalidate]; // Ok end this timer function, never come back
                
                [self.coffeeImageView stopAnim]; // Stop previus begin animation
                [self.infoLabel setText:@""];
                [self.timerLabel setText:@"Enjoy"];
                
                self.coffeeImageView.image = [UIImage imageNamed:@"fpour_5"];
                CATransition *animation = [CATransition animation];
                [animation setDuration:1];
                [animation setType:kCATransitionPush];
                [animation setSubtype:kCATransitionFromBottom];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
                [[self.coffeeImageView layer] addAnimation:animation forKey:@"SlideOutandInImagek"];
                
                
            }
            break;
        default:
            break;
    }
}

-(void)getCurrentCoffeeState
{
    NSTimeInterval waterTime;
    NSTimeInterval bloomTime;
    NSTimeInterval totalTime;
    NSTimeInterval finishTime;
    
    switch (brewMethod) {
        case FrenchPress:
            {
                waterTime = self.frenchWaterTime;
                bloomTime = self.frenchBloomTime;
                totalTime = self.frenchTotalTime;
                finishTime = self.frenchFinishTime;
            }
            break;
        case AeroPress:
            {
                waterTime = self.aeroWaterTime;
                bloomTime = self.aeroBloomTime;
                totalTime = self.aeroTotalTime;
                finishTime = self.aeroFinishTime;
            }
            break;
        default:
            break;
    }
    
    
    self.elapsedTime = [[NSDate date] timeIntervalSinceDate:self.startTime];
    // NSLog(@"Elapsed Time:%f", self.elapsedTime);
    
    if (self.elapsedTime <= waterTime) {
        coffeeState = FrenchWaterState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:0];
        
    } else if (self.elapsedTime >= waterTime &&
               self.elapsedTime < waterTime + bloomTime) {
        coffeeState = FrenchStirState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:waterTime];
        
    } else if (self.elapsedTime >= waterTime + bloomTime &&
               self.elapsedTime < totalTime) {
        coffeeState = FrenchSteepState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:waterTime + bloomTime];
        
    } else if (self.elapsedTime >= totalTime &&
               self.elapsedTime < totalTime + finishTime) {
        coffeeState = FrenchFinishState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:totalTime];
        
    }  else if (self.elapsedTime >= totalTime + finishTime) {
        self.didEnded = YES;
        coffeeState = FrenchEnjoyState;
        self.stateStartDate = [self.startTime dateByAddingTimeInterval:totalTime + finishTime];
    }
}

-(void)loadAeroPressAnimationImages
{
    for (NSUInteger i = 18; i > 0 ; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressBegin%02u", i]];
        if (image) {
            [self.aeroPressBegin addObject:image];
        }
    }
    
    // First stir anim
    for (NSUInteger i = 0; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressStir%02u", i]];
        if (image) {
            [self.aeroPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 8; i > 0; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressStir%02u", i]];
        if (image) {
            [self.aeroPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 9; i <= 15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressStir%02u", i]];
        if (image) {
            [self.aeroPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 15; i > 9; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressStir%02u", i]];
        if (image) {
            [self.aeroPressStir addObject:image];
        }
    }
    //first end
    
    // Second stir anim
    for (NSUInteger i = 0; i < 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressStir%02u", i]];
        if (image) {
            [self.aeroPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 8; i > 0; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressStir%02u", i]];
        if (image) {
            [self.aeroPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 9; i <= 15; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressStir%02u", i]];
        if (image) {
            [self.aeroPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 15; i > 9; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressStir%02u", i]];
        if (image) {
            [self.aeroPressStir addObject:image];
        }
    }
    // second end
    
    for (NSUInteger i = 0; i <= 19; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressSteep%02u", i]];
        if (image) {
            [self.aeroPressSteep addObject:image];
        }
    }
    
    for (NSUInteger i = 0; i <= 25; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"aeroPressFinish%02u", i]];
        if (image) {
            [self.aeroPressFinish addObject:image];
        }
    }
}

-(void)loadFrenchPressAnimationImages
{
    for (NSUInteger i = 25; i > 0 ; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animBegin%02u", i]];
        if (image) {
            [self.frenchPressBegin addObject:image];
        }
    }
    
    // First stir anim
    for (NSUInteger i = 7; i < 14; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animStir%02u", i]];
        if (image) {
            [self.frenchPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 14; i > 0; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animStir%02u", i]];
        if (image) {
            [self.frenchPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 0; i <= 7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animStir%02u", i]];
        if (image) {
            [self.frenchPressStir addObject:image];
        }
    }
    
    // Second stir anim, simple hack to show it as twice as fast
    for (NSUInteger i = 7; i < 14; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animStir%02u", i]];
        if (image) {
            [self.frenchPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 14; i > 0; i--) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animStir%02u", i]];
        if (image) {
            [self.frenchPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 0; i <= 7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animStir%02u", i]];
        if (image) {
            [self.frenchPressStir addObject:image];
        }
    }
    
    for (NSUInteger i = 0; i <= 20; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animSteep%02u", i]];
        if (image) {
            [self.frenchPressSteep addObject:image];
        }
    }
    
    for (NSUInteger i = 0; i <= 25; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animFinish%02u", i]];
        if (image) {
            [self.frenchPressFinish addObject:image];
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