//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"

typedef NS_ENUM(NSInteger, GesturePasswordType) {
    
    GesturePasswordTypeDefault = 0,                          //
    GesturePasswordTypeSetting,                              //设置
    GesturePasswordTypeVerify,                               //验证
    GesturePasswordTypeModify,                               //修改
    GesturePasswordTypeLockOrSuspendVerify,                  //挂起/锁屏 后的验证
};

typedef void (^GesturePasswordCompletionBlock) (void);

@interface GesturePasswordController : UIViewController <DrawResultDelegate>
{

}
/*
 1--设置
 2--验证
 3--修改
 4--挂起/锁屏 后的验证
 */
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger verifyTime;
@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,assign) BOOL showNavigationBar;
@property (nonatomic,copy) GesturePasswordCompletionBlock completionBlock;

- (void)clear;

- (BOOL)exist;

@end
