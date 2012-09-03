#import "FrenchpressAppDelegate.h"
#import "FrenchpressViewController.h"
#import "SlideToCancelViewController.h"

@implementation FrenchpressAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[FrenchpressViewController alloc] init];
    
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    NSLog(@"DidFinishLaunchingWithOptions");
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"DidEnterBackground");
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.viewController.currentDate forKey:@"currentDate"];
    [defaults synchronize];
    NSLog(@"Data saved");
    
    // Clean labels that will be refreshed next time
    [[[self viewController] timerLabel ] setText:@""];
    
    // Clean all timers
    [[self viewController] stopTimers];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"WillEnterForeground");
    if ([self.viewController didEnded]) {
        NSLog(@"WillEnterForeground DidEnded");
        
        // Make a new start
        [self.viewController cleanForNewStart];
        
        // This is the main feature of our app
        // Make this editable in the future
        [self.viewController startCoffee];

    }
    // Get the stored data before the view loads
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *startT = [defaults objectForKey:@"startTime"];
    NSLog(@"Startime: %@", startT);
    [[self viewController] setStartTime:startT];
    
    // We could need this in the future
//    NSDate *currentD = [defaults objectForKey:@"currentDate"];
//    [[self viewController] setCurrentDate:currentD];
    
    
    // Start the timer again
    [[self viewController] startCountdown];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"DidBecomActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
