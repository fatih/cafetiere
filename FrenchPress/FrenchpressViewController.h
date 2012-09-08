#import <UIKit/UIKit.h>
#import "SlideToCancelViewController.h"
#import "AnimUIImageView.h"
#import "SettingsViewController.h"

@interface FrenchpressViewController : UIViewController
    <SlideToCancelDelegate, IASKSettingsDelegate>
{
    SlideToCancelViewController *slideToCancel;
    IASKAppSettingsViewController *appSettingsViewController;
}

@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;
- (IBAction)showSettingsPush:(id)sender;

@property (nonatomic, strong) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) IBOutlet AnimUIImageView *frenchPress;
@property (nonatomic, strong) UIImage *french1, *french2, *french3, *french4, *french5;

@property (nonatomic, strong) IBOutlet UIImageView *infoBackground;
@property (nonatomic, strong) UIImage *infoBackgroundImage;


@property (nonatomic, strong) NSMutableString *timerString;

@property (nonatomic, strong) NSTimer *paintingTimer, *coffeeTimer;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *startDate, *waterDate, *bloomDate;
@property (nonatomic, strong) NSDate *stateStartDate, *currentDate;

@property (nonatomic, strong) NSCalendar *sysCalendar;

@property (nonatomic) NSTimeInterval countdownSeconds, elapsedTime;
@property (nonatomic) NSTimeInterval waterTime, bloomTime, steepTime, finishTime;
@property (nonatomic) NSTimeInterval startGap;

@property (nonatomic) int waterState, bloomState, steepState, finishState;
@property (nonatomic) int didEnded, didCountdownStarted, didCoffeeStarted;
@property (nonatomic) unsigned int unitFlags;

@property (nonatomic, strong) NSMutableArray *animationArrayStir,
                                             *animationArrayBegin,
                                             *animationArraySteep,
                                             *animationArrayFinish;
typedef enum {
    BeginState,
    WaterState,
    StirState,
    SteepState,
    FinishState,
    EnjoyState
} CoffeState;


@property (nonatomic) BOOL backgroundStart;

-(void)startCoffee;
-(void)cleanForNewStart;
-(void)stopTimers;
-(void)startCountdown:(NSTimeInterval)timeGap;
-(void)getCurrentCoffeeState;

@end
