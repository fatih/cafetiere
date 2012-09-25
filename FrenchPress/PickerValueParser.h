//
//  PickerValueParser.h
//  FrenchPress
//
//  Created by Fatih Arslan on 9/24/12.
//  Copyright (c) 2012 Fatih Arslan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerValueParser : NSObject <QPickerValueParser>

@property (nonatomic, readonly) NSArray *timeValues;

@end
