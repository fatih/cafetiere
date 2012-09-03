#import <UIKit/UIKit.h>
#import "SlideToCancelViewController.h"

@interface FrenchpressViewController : UIViewController
    <SlideToCancelDelegate>
{
    SlideToCancelViewController *slideToCancel;
}

@property (nonatomic, strong) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) IBOutlet UIImageView *frenchPress;
@property (nonatomic, strong) UIImage *french1, *french2, *french3, *french4, *french5;

@property (nonatomic, strong) UIImage *infoBackgroundImage;
@property (nonatomic, strong) IBOutlet UIImageView *infoBackground;

@property (nonatomic, strong) NSMutableString *timerString;

@property (nonatomic, strong) NSTimer *paintingTimer, *coffeeTimer;
@property (nonatomic, strong) NSDate *currentDate, *startTime;
@property (nonatomic, strong) NSDate *startDate, *waterDate, *bloomDate;

@property (nonatomic, strong) NSCalendar *sysCalendar;

@property (nonatomic) NSTimeInterval countdownSeconds, elapsedTime;
@property (nonatomic) NSTimeInterval waterTime, bloomTime, steepTime, finishTime;

@property (nonatomic) int waterState, bloomState, steepState, finishState;
@property (nonatomic) int didEnded;
@property (nonatomic) unsigned int unitFlags;

@property (nonatomic, strong) NSMutableArray *animationArrayStir,
                                             *animationArrayBegin,
                                             *animationArraySteep,
                                             *animationArrayFinish;

-(void)startCoffee;
-(void)cleanForNewStart;

@end
