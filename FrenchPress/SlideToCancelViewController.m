//
//  SlideToCancelViewController.m
//  SlideToCancel
//
// The slider track and thumb images were made from a screen shot of the iPhone's home
// screen. Apple may object to use of these images in an app. I have not yet had an app 
// approved (or rejected either) using these images. Use at your own risk.
//
// Please note that THIS CODE ONLY DISPLAYS TEXT IN ROMAN ALPHABETS. For use with
// non-Roman (i.e. Asian) alphabets, the code in method
// - (void)drawLayer:(CALayer *)theLayer inContext:(CGContextRef)theContext
// must be re-written to use glyphs. See Apple's "Quartz 2D Programming Guide" 
// chapter "Drawing Text" for more info.

#import <QuartzCore/QuartzCore.h>
#import "SlideToCancelViewController.h"

@interface SlideToCancelViewController()

@end

@implementation SlideToCancelViewController

@synthesize delegate;
@synthesize thumbImage;
@synthesize trackImage;

// Implement the "enabled" property
- (BOOL) enabled {
	return slider.enabled;
}

- (void) setEnabled:(BOOL)enabled{
	slider.enabled = enabled;
	label.enabled = enabled;
	if (enabled) {
		slider.value = 0.0;
		label.alpha = 1.0;
		touchIsDown = NO;
	}
}

- (UILabel *)label {
	// Access the view, which will force loadView to be called 
	// if it hasn't already been, which will create the label
	(void)[self view];
	
	return label;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIImage *originalImageTrack = [UIImage imageNamed:@"slideWall"];
    self.trackImage = [UIImage imageWithCGImage:[originalImageTrack CGImage]
                        scale:2.0 orientation:UIImageOrientationUp];
    
	sliderBackground = [[UIImageView alloc] initWithImage:self.trackImage];
    sliderBackground.layer.shouldRasterize = YES;
	
	// Create the superview same size as track backround, and add the background image to it
	UIView *view = [[UIView alloc] initWithFrame:sliderBackground.frame];
	[view addSubview:sliderBackground];
	
	// Add the slider with correct geometry centered over the track
	slider = [[UISlider alloc] initWithFrame:sliderBackground.frame];
	CGRect sliderFrame = slider.frame;
	sliderFrame.size.width -= 21; //each "edge" of the track is 23 pixels wide
    
	slider.frame = sliderFrame;
	slider.center = sliderBackground.center;
	slider.backgroundColor = [UIColor clearColor];
	[slider setMinimumTrackImage:[UIImage imageNamed:@"sliderMaxMin-02.png"] forState:UIControlStateNormal];
	[slider setMaximumTrackImage:[UIImage imageNamed:@"sliderMaxMin-02.png"] forState:UIControlStateNormal];
    slider.layer.shouldRasterize = YES;
    
	UIImage *originalImage = [UIImage imageNamed:@"slideButtonPSD"];
    
    self.thumbImage = [UIImage imageWithCGImage:[originalImage CGImage]
                        scale:2.0 orientation:UIImageOrientationUp];
    
	[slider setThumbImage:self.thumbImage forState:UIControlStateNormal];
    
	slider.minimumValue = 0.0;
	slider.maximumValue = 1.0;
	slider.continuous = YES;
	slider.value = 5.0;
    
	// Set the slider action methods
	[slider addTarget:self 
			   action:@selector(sliderUp:) 
	 forControlEvents:UIControlEventTouchUpInside];
	[slider addTarget:self 
			   action:@selector(sliderDown:) 
	 forControlEvents:UIControlEventTouchDown];
	[slider addTarget:self 
			   action:@selector(sliderChanged:) 
	 forControlEvents:UIControlEventValueChanged];

	// Create the label with the actual size required by the text
	// If you change the text, font, or font size by using the "label" property,
	// you may need to recalculate the label's frame.
	NSString *labelText = NSLocalizedString(@"‣  ‣   Make a new coffee", @"SlideToCancel label");
    //	UIFont *labelFont = [UIFont systemFontOfSize:24];
	UIFont *labelFont = [UIFont fontWithName:@"STHeitiSC-Light" size:19];
	CGSize labelSize = [labelText sizeWithFont:labelFont];
	label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, labelSize.width, labelSize.height)];
	
	// Center the label over the slidable portion of the track
	CGFloat labelHorizontalCenter = slider.center.x + (self.thumbImage.size.width / 2);
	label.center = CGPointMake(labelHorizontalCenter, slider.center.y);
	
	// Set other label attributes and add it to the view
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.font = labelFont;
	label.text = labelText;
    
	[view addSubview:label];
	
	[view addSubview:slider];

	// This property is set to NO (disabled) on creation.
	// The caller must set it to YES to animate the slider.
	// It should be set to NO (disabled) when the view is not visible, in order
	// to turn off the timer and conserve CPU resources.
	self.enabled = NO;
	
	// Set the view controller's view property to all of the above
	self.view = view;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
}

// UISlider actions
- (void) sliderUp: (UISlider *) sender
{
	//filter out duplicate sliderUp events
	if (touchIsDown) {
		touchIsDown = NO;
		
		if (slider.value != 1.0)  //if the value is not the max, slide this bad boy back to zero
		{
			[slider setValue: 0 animated: YES];
			label.alpha = 1.0;
		}
		else {
			//tell the delagate we are slid all the way to the right
			[slider setValue: 0 animated: YES];
            
			[delegate cancelled];
		}
	}
}

- (void) sliderDown: (UISlider *) sender
{
	touchIsDown = YES;
}

- (void) sliderChanged: (UISlider *) sender
{
	// Fade the text as the slider moves to the right. This code makes the
	// text totally dissapear when the slider is 35% of the way to the right.
	label.alpha = MAX(0.0, 1.0 - (slider.value * 1.5));
}

- (void)dealloc {
	[self viewDidUnload];
}

@end
