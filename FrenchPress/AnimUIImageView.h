//
//  AnimUIImageView.h
//  FrenchPress
//
//  Created by Fatih Arslan on 9/6/12.
//  Copyright (c) 2012 Fatih Arslan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimUIImageView : UIImageView



@property (nonatomic) BOOL hasAnim;
@property (nonatomic) NSTimeInterval animDuration;


-(id)init;

-(void)animImages:(NSArray *)images;
-(void)animRepeatCount:(NSInteger)count;

-(void)startAnim;
-(void)stopAnim;
-(void)pauseAnim;
-(void)resumeAnim:(NSTimeInterval)resumeTime;

@end
