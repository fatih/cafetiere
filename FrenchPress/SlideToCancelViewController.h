//
//  SlideToCancelViewController.h
//  SlideToCancel
//

#import <UIKit/UIKit.h>

@protocol SlideToCancelDelegate;

@interface SlideToCancelViewController : UIViewController {
	UIImageView *sliderBackground;
	UISlider *slider;
	UILabel *label;
	__weak id <SlideToCancelDelegate> delegate;
	BOOL touchIsDown;
	CGFloat gradientLocations[3];
	int animationTimerCount;
}

@property __weak id <SlideToCancelDelegate> delegate;

// This property is set to NO (disabled) on creation.
// The caller must set it to YES to animate the slider.
// It should be set to NO (disabled) when the view is not visible, in order
// to turn off the timer and conserve CPU resources.
@property (nonatomic) BOOL enabled;

// Access the UILabel, e.g. to change text or color
@property (nonatomic, readonly) UILabel *label;

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *trackImage;

@end

@protocol SlideToCancelDelegate

@required
- (void) cancelled;

@end
