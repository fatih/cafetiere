#import "FrenchpressAppDelegate.h"
#import "FrenchpressViewController.h"
#import "SlideToCancelViewController.h"
#import  <QuartzCore/QuartzCore.h>
//#import "InAppSettingsKit/Controllers/IASKAppSettingsViewController.h"

@implementation FrenchpressAppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[FrenchpressViewController alloc] init];
    
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    self.navigationController.delegate = self;
//    [[self window] setRootViewController:self.navigationController];
    
    [[self window] setRootViewController:self.viewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

// ENABLE with navigationController only
// http://www.idev101.com/code/User_Interface/UINavigationController/viewWillAppear.html
//- (void)navigationController:(UINavigationController *)navigationController
//      willShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated
//{
//    if ( viewController == self.viewController ) {
//        [self.navigationController setNavigationBarHidden:YES animated:animated];
//    } else if ( [self.navigationController isNavigationBarHidden] ) {
//        [self.navigationController setNavigationBarHidden:NO animated:animated];
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"DidEnterBackground");
    // Countdown didn't started yet, nothing to save here
    if (!self.viewController.didCountdownStarted) {
        [[self viewController] cleanForNewStart];
        return;
    }
    
    [self.viewController.frenchPress pauseAnim];
    
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"currentDate"];
    [defaults synchronize];
    
    // Clean labels that will be refreshed next time
//    [[[self viewController] timerLabel] setText:@""];
    
    // Clean all timers
    [[self viewController] stopTimers];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // NEW START restart...
    // Before we continue get the current state. Otherwise the if clauses below
    // will not be considered (which is a reason for a crash of the app)
    [[self viewController] getCurrentCoffeeState];
    
    // Restart the app if ended or if it doesn't started automatically.
    // If the countdown has started already, then we skip this part and the
    // resumeAnim part below takes the control.
    if (self.viewController.didEnded || (!self.viewController.didCountdownStarted)) {
        NSLog(@"Beginning from the scratch");
       
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL enabled = [defaults boolForKey:@"startAtLaunch"];
        
        [self.viewController.infoLabel setText:@"Slide to start"];
        [self.viewController.timerLabel setText:@"Cafetière"];
        [self.viewController.frenchPress setImage:nil];
        
        if (enabled) {
            [self.viewController startCoffee];
        }
        
        return;
    }

    // COUNTDOWN resuming...
    // startTime is set once, at the begin of the app. After that
    // we do our works with reference to this variable.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *startT = [defaults objectForKey:@"startTime"];
    [[self viewController] setStartTime:startT];
    
    // Tell that we come from background
    // Needed to not overide old NSUserDefaults values in ViewController
    [[self viewController] setBackgroundStart:YES];
    
    // Resume any animation that was paused before
    NSTimeInterval elapsedGap = [[NSDate date] timeIntervalSinceDate:self.viewController.stateStartDate];
    [self.viewController.frenchPress resumeAnim:elapsedGap];
    [[self viewController] startCountdown:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
