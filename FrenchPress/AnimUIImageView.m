#import "AnimUIImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimUIImageView ()


@end

@implementation AnimUIImageView

@synthesize hasAnim;
@synthesize animationDuration;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[self layer] setShadowColor:[UIColor blackColor].CGColor];
        [[self layer] setShadowOffset:CGSizeMake(1, -2)];
        [[self layer] setShadowOpacity:0.4];
        [[self layer] setShadowRadius:2];
        [self setClipsToBounds:NO];
        
        self.animationImages = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)animImages:(NSArray *) images
{
    [self setAnimationImages:[NSArray arrayWithArray:images]];
}

-(void)animRepeatCount:(NSInteger) count
{
    [self setAnimCount:count];
}

-(void)startAnim
{
    self.timeCount = self.animDuration / self.animationImages.count;
    [self setAnimImage:[[self animationImages] objectAtIndex:[self animIndex]]];
    [self setImage: [self animImage]];
    
//    NSLog(@"Images will be set every %f second", self.timeCount);
//    NSLog(@"Starting animation with total images: %u", self.animationImages.count);
//    NSLog(@"Beginning with animIndex: %u",self.animIndex);
    
    self.animTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeCount
                                                     target:self
                                                    selector:@selector(runAnim:)
                                                   userInfo:nil
                                                    repeats:YES];
}

-(void)runAnim: (NSTimer*)theTimer
{
    self.animIndex++;
    
//    NSLog(@"animIndex: %u",self.animIndex);
    [self setAnimImage:[[self animationImages] objectAtIndex:[self animIndex]]];
    [self setImage: [self animImage]];
    
    if (([self.animationImages count] - 1) == self.animIndex) {
//        NSLog(@"animIndex: END");
        [self.animTimer invalidate];
        self.animIndex = 0;
    }
    
}

-(void)stopAnim
{
//    NSLog(@"Stopping Animation");
    if ([self animTimer] != nil) {
        [self.animTimer invalidate];
    }
    
    self.animIndex = 0;
    self.animationImages = nil;
    self.animDuration = 0;
    self.animCount = 0;
    self.timeCount = 0;
}

-(void)pauseAnim
{
//    NSLog(@"Pausing Animation");
    if ([self animTimer] != nil) {
        [self.animTimer invalidate];
        [self setHasAnim:NO];
    }
}

-(void)resumeAnim:(NSTimeInterval)elapsedTime;
{
//    NSLog(@"Resuming Animation");
    
    if ([self hasAnim] == NO) {
        
        self.animIndex = elapsedTime / self.timeCount;
        
        [self startAnim];
    }
}


@end
