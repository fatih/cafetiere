#import <UIKit/UIKit.h>

@interface PickerViewController : UIViewController
            <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *myPicker;

@property(retain, nonatomic) NSMutableArray *minsArray;
@property(retain, nonatomic) NSMutableArray *secsArray;

@end
