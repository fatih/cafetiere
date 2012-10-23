// NOTE: This viewController is once created but abandoded because of the use of Quickdialog.

#import "PickerViewController.h"

@interface PickerViewController ()

@end

@implementation PickerViewController

@synthesize myPicker;

-(id)init
{
    self = [super init];
    if (self) {
        self.minsArray = [[NSMutableArray alloc] init];
        self.secsArray = [[NSMutableArray alloc] init];
        NSString *strVal = [[NSString alloc] init];
        
        
        for (int i = 0; i <= 59; i++) {
            if (i <= 9) {
                strVal = [NSString stringWithFormat:@"  %3d", i];
            } else {
                strVal = [NSString stringWithFormat:@"  %d", i];
            }
            [self.secsArray addObject:strVal];
        }
        
        for (int i = 0; i <= 10; i++) {
            if (i <= 9) {
                strVal = [NSString stringWithFormat:@"  %3d", i];
            } else {
                strVal = [NSString stringWithFormat:@"  %d", i];
            }
            [self.minsArray addObject:strVal];
        }
        
        NSLog(@"[minsArray count]: %d", [self.minsArray count]);
        NSLog(@"[secsArray count]: %d", [self.secsArray count]);
    }
    return  self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PickerViewController viewDidload method");
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myPicker = [[UIPickerView alloc] init];
    self.myPicker.dataSource = self;
    self.myPicker.delegate = self;
    self.myPicker.showsSelectionIndicator = YES;
    [[self myPicker] selectRow:4 inComponent:0 animated:YES]; // 04 min
    [[self myPicker] selectRow:0 inComponent:1 animated:YES]; // 00 sec
    
    // Calculate the screen's width.
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float pickerWidth = screenWidth * 3 / 4;
    
    // Calculate the starting x coordinate.
    float xPoint = screenWidth / 2 - pickerWidth / 2;
//    [self.myPicker setFrame: CGRectMake(xPoint, 30.0f, pickerWidth, 200.0f)];
    
    self.myPicker.center = self.view.center;
    
    [self.view addSubview:self.myPicker];
    
    
    CGSize pickerSize = [self.myPicker sizeThatFits:CGSizeZero];
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    
    // toolbarHeight = 4
    CGFloat pickerTop = screenRect.size.height - 4 - pickerSize.height;
    CGRect pickerRect = CGRectMake(xPoint, pickerTop - 4, pickerSize.width * 3 / 4, 180.0f);
    self.myPicker.frame = pickerRect;
    
    CGFloat top = pickerTop + 2;
    CGFloat height = pickerSize.height - 2;
    [self addPickerLabel:@"mins" rightX:142.0 top:top height:height - 47];
    [self addPickerLabel:@"sec." rightX:245.0 top:top height:height - 47];
    
}

- (void)addPickerLabel:(NSString *)labelString rightX:(CGFloat)rightX top:(CGFloat)top height:(CGFloat)height {
#define PICKER_LABEL_FONT_SIZE 18
#define PICKER_LABEL_ALPHA 0.7
    UIFont *font = [UIFont boldSystemFontOfSize:PICKER_LABEL_FONT_SIZE];
    CGFloat x = rightX - [labelString sizeWithFont:font].width;
    
    // White label 1 pixel below, to simulate embossing.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, top + 1, rightX, height)];
    label.text = labelString;
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.alpha = PICKER_LABEL_ALPHA;
    [self.view addSubview:label];
    
    // Actual label.
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, top, rightX, height)];
    label.text = labelString;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.alpha = PICKER_LABEL_ALPHA;
    [self.view addSubview:label];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger result = 0;
    if ([pickerView isEqual:self.myPicker]) {
        result = 2; // min and sec
    }
    return result;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    if (![pickerView isEqual:self.myPicker])
        return result;
    
    if (component == 0) {
        result = [self.minsArray count];
    }
    else if (component == 1) {
        result = [self.secsArray count];
    }
    
    return result;
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    NSString *result = nil;
    if (![pickerView isEqual:self.myPicker])
        return result;
    
    switch (component)
    {
        case 0:
            return [self.minsArray objectAtIndex:row];
            break;
        case 1:
            return [self.secsArray objectAtIndex:row];
            break;
    }
    return result;
    
}


- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    
    NSString *minsStr = [NSString stringWithFormat:@"%@",[self.minsArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
    NSString *secsStr = [NSString stringWithFormat:@"%@",[self.secsArray objectAtIndex:[pickerView selectedRowInComponent:1]]];
    
    int minsInt = [minsStr intValue];
    int secsInt = [secsStr intValue];
    
    NSTimeInterval interval = secsInt + (minsInt*60);
    NSLog(@"mins: %d sec: %d interval: %f", minsInt, secsInt, interval);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
