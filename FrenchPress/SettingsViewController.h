#import "InAppSettingsKit/Controllers/IASKAppSettingsViewController.h"

@interface SettingsViewController : UIViewController <IASKSettingsDelegate, UITextViewDelegate>
{
    IASKAppSettingsViewController *appSettingsViewController;
}

@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;

- (IBAction)showTimerSettings:(id)sender;

@end
