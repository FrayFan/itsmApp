//
//  TentacleView.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//
#import <UIKit/UIKit.h>

/*
@protocol ResetDelegate <NSObject>

- (BOOL)resetPassword:(NSString *)result;

@end

@protocol VerificationDelegate <NSObject>

- (BOOL)verification:(NSString *)result;

@end*/

@protocol DrawResultDelegate <NSObject>

- (BOOL)DrawResult:(NSString *)result;

@end

@protocol TouchBeginDelegate <NSObject>

- (void)gestureTouchBegin;

@end



@interface TentacleView : UIView

@property (nonatomic,strong) NSMutableArray * buttonArray;

//@property (nonatomic,assign) id<VerificationDelegate> rerificationDelegate;

//@property (nonatomic,assign) id<ResetDelegate> resetDelegate;
@property (nonatomic,assign) id<DrawResultDelegate> drawResultDelegate;

@property (nonatomic,assign) id<TouchBeginDelegate> touchBeginDelegate;


- (void)enterArgin;

@end
