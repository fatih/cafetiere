//Constants.h

//Duration between app start and countdown
FOUNDATION_EXPORT NSTimeInterval const kStartTime;

// Coffee step duration in seconds
// French Press
FOUNDATION_EXPORT NSString *const kFrenchWaterTime;
FOUNDATION_EXPORT NSString *const kFrenchStirTime;
FOUNDATION_EXPORT NSString *const kFrenchSteepTime;
FOUNDATION_EXPORT NSString *const kFrenchFinishTime;

// AeroPress
FOUNDATION_EXPORT NSString *const kAeroWaterTime;
FOUNDATION_EXPORT NSString *const kAeroStirTime;
FOUNDATION_EXPORT NSString *const kAeroSteepTime;
FOUNDATION_EXPORT NSString *const kAeroFinishTime;

// Coffee step states in boolean
FOUNDATION_EXPORT NSString *const kStartAtLaunch;
FOUNDATION_EXPORT BOOL const kAddWaterStep;
FOUNDATION_EXPORT BOOL const kAddStirStep;
