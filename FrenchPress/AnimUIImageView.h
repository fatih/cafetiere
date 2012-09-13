//
//  AnimUIImageView.h
//  FrenchPress
//
//  Created by Fatih Arslan on 9/6/12.
//  Copyright (c) 2012 Fatih Arslan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimUIImageView : UIImageView

@property (nonatomic, copy) NSMutableArray *animationImages;

@property NSInteger animCount;
@property NSInteger animIndex;

@property (nonatomic) NSTimer *animTimer;
@property (nonatomic) UIImage *animImage;

@property NSTimeInterval timeCount;
@property NSTimeInterval passedTime;

@property (nonatomic) BOOL hasAnim;
@property (nonatomic) NSTimeInterval animDuration;

-(void)animImages:(NSArray *)images;
-(void)animRepeatCount:(NSInteger)count;

-(void)startAnim;
-(void)stopAnim;
-(void)pauseAnim;
-(void)resumeAnim:(NSTimeInterval)resumeTime;

@end
