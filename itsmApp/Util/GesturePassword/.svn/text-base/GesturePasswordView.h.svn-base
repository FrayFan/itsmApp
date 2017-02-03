//
//  GesturePasswordView.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//
/*
@protocol GesturePasswordDelegate <NSObject>

- (void)forget;
- (void)change;

@end*/

#import <UIKit/UIKit.h>
#import "TentacleView.h"

@interface GesturePasswordView : UIView<TouchBeginDelegate>
//@interface GesturePasswordView : UIScrollView<TouchBeginDelegate>

@property (nonatomic,strong) TentacleView * tentacleView;

@property (nonatomic,strong) UILabel * displayName;

@property (nonatomic,strong) UILabel * state;

@property (nonatomic,strong) UILabel * title;

@property (nonatomic,strong) UIImageView * imgView;
@property (nonatomic,strong) UIButton * actionButton;

- (id)initWithFrame:(CGRect)frame andflag: (int) flag;
@end
