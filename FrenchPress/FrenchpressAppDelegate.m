#import "FrenchpressAppDelegate.h"
#import "FrenchpressViewController.h"
#import "SlideToCancelViewController.h"
#import  <QuartzCore/QuartzCore.h>
//#import "AnimUIImageView.h"

@implementation FrenchpressAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[FrenchpressViewController alloc] init];
    
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

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
    // Countdown reached the end, start it from the beginning
    if (self.viewController.didEnded || (!self.viewController.didCountdownStarted)) {
        NSLog(@"Beginning from the scratch");
        
        // Make a new start
        [self.viewController cleanForNewStart];
        
        // This is the main feature of our app
        // Make this editable in the future
        [self.viewController startCoffee];
        
        return;
    }

    // If the countdown dint started, the skip and start timer
    // immediately
    if (self.viewController.didCountdownStarted) {
        // The timers StartTime should always be the same
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDate *startT = [defaults objectForKey:@"startTime"];
        [[self viewController] setStartTime:startT];
        
        // Tell that we come from background
        // Needed to not overide old NSUserDefaults values
        [[self viewController] setBackgroundStart:YES];
        
        // Resume any animation that was paused before
        [[self viewController] getCurrentCoffeeState];
        NSTimeInterval elapsedGap = [[NSDate date] timeIntervalSinceDate:self.viewController.stateStartDate];
        [self.viewController.frenchPress resumeAnim:elapsedGap];
        [[self viewController] startCountdown:0];
        
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
