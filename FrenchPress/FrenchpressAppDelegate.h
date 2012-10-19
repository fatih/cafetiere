#import <UIKit/UIKit.h>

@class FrenchpressViewController;

@interface FrenchpressAppDelegate : UIResponder
    <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FrenchpressViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) UIViewController *leftController;

@end
