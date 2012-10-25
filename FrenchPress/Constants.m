//Constants.m

//Duration between app start and countdown
NSTimeInterval const kStartTime = 1.5f;

// Coffee step duration in seconds
//FrenchPress
NSString *const kFrenchWaterTime = @"15";
NSString *const kFrenchStirTime = @"5";
NSString *const kFrenchSteepTime = @"240";
NSString *const kFrenchFinishTime = @"1";

// AeroPress
NSString *const kAeroWaterTime = @"5";
NSString *const kAeroStirTime = @"10";
NSString *const kAeroSteepTime = @"10";
NSString *const kAeroFinishTime = @"20";

// Coffee step states in boolean
NSString *const kStartAtLaunch = @"startAtLaunch";
BOOL const kAddWaterStep = YES;
BOOL const kAddStirStep = YES;
