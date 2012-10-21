#import <UIKit/UIKit.h>
#import "SlideToCancelViewController.h"
#import "AnimUIImageView.h"
#import "PickerViewController.h"

@interface FrenchpressViewController : UIViewController
    <SlideToCancelDelegate>
{
    SlideToCancelViewController *slideToCancel;
}

@property (nonatomic, retain) UINavigationController *navSettingsViewController;

@property (nonatomic, retain) PickerViewController *timerPicker;

@property (nonatomic, strong) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;

// Frenchpress UIImageview and images for each state
@property (nonatomic, strong) IBOutlet AnimUIImageView *frenchPress;
@property (nonatomic, strong) UIImage *french1, *french2, *french3, *french4, *french5;

// Info and timer label background view and image
@property (nonatomic, strong) IBOutlet UIImageView *infoBackground;
@property (nonatomic, strong) UIImage *infoBackgroundImage;
@property (nonatomic, strong) UIImage *defaultBackgroundImage;


@property (nonatomic, strong) NSMutableString *timerString;

@property (nonatomic, strong) NSTimer *paintingTimer, *coffeeTimer;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *startDate, *waterDate, *bloomDate;
@property (nonatomic, strong) NSDate *stateStartDate, *currentDate;

@property (nonatomic, strong) NSCalendar *sysCalendar;

@property (nonatomic) NSTimeInterval countdownSeconds, elapsedTime;

// Each step has a different time
@property (nonatomic) NSTimeInterval waterTime, bloomTime, steepTime, finishTime;

@property (nonatomic) NSTimeInterval startGap;

@property (nonatomic) int waterState, bloomState, steepState, finishState;
@property (nonatomic) int didEnded, didCountdownStarted, didCoffeeStarted;

// NSDateComponents  need this
@property (nonatomic) unsigned int unitFlags;

// Image array that contains the images for animation
@property (nonatomic, strong) NSMutableArray *animationArrayStir,
                                             *animationArrayBegin,
                                             *animationArraySteep,
                                             *animationArrayFinish;

// Simple boolean if we ever entered background
@property (nonatomic) BOOL backgroundStart;
@property (nonatomic) BOOL modalModeOn;


typedef enum {
    BeginState,
    WaterState,
    StirState,
    SteepState,
    FinishState,
    EnjoyState
} FrenchPressCoffeeState;

typedef enum {
    AeroBeginState,
    AeroWaterState,
    AeroStirState,
    AeroSteepState,
    AeroFinishState,
    AeroEnjoyState
} AeroPressCoffeeState;

typedef enum {
    FrenchPress,
    AeroPress
} BrewMethod;


-(void)startCoffee;
-(void)cleanForNewStart;
-(void)stopTimers;
-(void)startCountdown:(NSTimeInterval)timeGap;
-(void)getCurrentCoffeeState;
-(void)selectBrewMethod:(NSString *)method;

@end
