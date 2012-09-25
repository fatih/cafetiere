//
//  PickerValueParser.m
//  FrenchPress
//
//  Created by Fatih Arslan on 9/24/12.
//  Copyright (c) 2012 Fatih Arslan. All rights reserved.
//

#import "PickerValueParser.h"

@implementation PickerValueParser
{
    NSDictionary *valuesMap;
}

-(id)init
{
    self = [super init];
    
    if (self) {
        NSMutableArray *minsArray = [[NSMutableArray alloc] init];
        NSMutableArray *secsArray = [[NSMutableArray alloc] init];
        NSString *strVal = [[NSString alloc] init];
        
        
        for (int i = 0; i <= 59; i++) {
            if (i <= 9) {
                strVal = [NSString stringWithFormat:@"%d", i];
            } else {
                strVal = [NSString stringWithFormat:@"%d", i];
            }
            [secsArray addObject:strVal];
        }
        
        for (int i = 0; i <= 10; i++) {
            if (i <= 9) {
                strVal = [NSString stringWithFormat:@"%d", i];
            } else {
                strVal = [NSString stringWithFormat:@"%d", i];
            }
            [minsArray addObject:strVal];
        }
        
        valuesMap = @{@"min": minsArray, @"sec": secsArray};
        
    }
    
    return self;
}

- (NSArray *)timeValues
{
    return @[valuesMap[@"min"], valuesMap[@"sec"]];
}

- (id)objectFromComponentsValues:(NSArray *)componentsValues
{
//    NSLog(@"objectFromComponentsValues");
    return [componentsValues componentsJoinedByString:@":"];
}

- (NSArray *)componentsValuesFromObject:(id)object
{
//    NSLog(@"componentsValuesFromObject");
    NSString *stringValue = [object isKindOfClass:[NSString class]] ? object : [object description];
    return [stringValue componentsSeparatedByString:@":"];
 
}


- (NSString *)presentationOfObject:(id)object
{
//    NSLog(@"presentationObject");
    NSArray *pickerValues = [object componentsSeparatedByString:@":"];
//    NSLog(@"%@ min %@ sec", pickerValues[0], pickerValues[1]);
    
    if ([pickerValues[0] isEqualToString:@"0"]) {
        if ([pickerValues[1] isEqualToString:@"0"]) {
            return  [NSString stringWithFormat:@"Disabled"];
        }
        return  [NSString stringWithFormat:@"%@ sec", pickerValues[1]];
    } else {
        return  [NSString stringWithFormat:@"%@ mins %@ sec", pickerValues[0], pickerValues[1]];
    }
    
}


@end
