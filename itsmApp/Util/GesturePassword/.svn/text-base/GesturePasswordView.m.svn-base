//
//  GesturePasswordView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordView.h"
#import "TentacleView.h"
#import "UIColor+HEX.h"
#import "GetUserInfoHandle.h"
#import "UIImageView+EMMFileCache.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_LENGTH (MAX(ScreenWidth, ScreenHeight))
#define SCREEN_MIN_LENGTH (MIN(ScreenWidth, ScreenHeight))
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)

#define Head_height 0.0f
#define Foot_height 10.0f
@implementation GesturePasswordView

@synthesize imgView;
@synthesize actionButton;
@synthesize title;
@synthesize tentacleView;
@synthesize state;
@synthesize displayName;


- (id)initWithFrame:(CGRect)frame andflag: (int) flag
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat label_height = 0;
        
        CGFloat orgY = Head_height;
        if(2 == flag)
        {
            //验证手势密码时，隐藏标题
            //其中，顶部和底部的宽度需要去除，9个按钮的高度为320， 头像的高度为60
            label_height = (frame.size.height - Head_height - Foot_height - 320.0f - 60.0f)/3;
            title = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, Head_height, 280, 0)];
        }
        else if(1 == flag)
        {
            //设置手势密码时，隐藏标题
            //其中，顶部和底部的宽度需要去除，9个按钮的高度为320， 9个小点的高度为50， 外加10的间隔
            label_height = (frame.size.height - Head_height - Foot_height - 320.0f - 60.0f)/4;
            title = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, Head_height, 280, label_height)];
            
            orgY += label_height;
        }
        
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont systemFontOfSize:17.0f]];
        [title setTextColor:[UIColor getColor:@"181818"]];
        [self addSubview:title];
        
       
        UserBaseInfo *user = [UserBaseInfo share];
        NSString *userUri;
        if(user.userName==nil)
        {
            userUri =[[NSString alloc] initWithFormat:@""];
        }
        else
        {
            userUri = user.userName;
        }
        
        orgY += IS_IPHONE_4_OR_LESS ?0:20;
        if(2 == flag)
        {
            CGRect frame = [UIScreen mainScreen].bounds;
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-85)/2, orgY, 85, 85)];
            imgView.layer.masksToBounds = YES;
            imgView.layer.cornerRadius = CGRectGetHeight(imgView.frame)/2.0;
            
            [self addSubview:imgView];
            
            UserBaseInfo *info = [UserBaseInfo share];
            [imgView emm_setImageWithURL:[NSURL URLWithString:info.headerUrl ?:@""] placeholderImage:[UIImage imageNamed:@"default_face"]];
            
            orgY += imgView.bounds.size.height;
        }
        else if(1 == flag)
        {
            orgY += 10.0;
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-25, orgY, 50, 50)];
            for (int i=0; i<9; i++) {
                NSInteger row = i/3;
                NSInteger col = i%3;
                // Button Frame
            
                NSInteger distance = 50/3;
                NSInteger size = distance/1.5;
                NSInteger margin = size/4;
                UIButton * setButton = [[UIButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
                [setButton setBackgroundImage:[UIImage imageNamed:@"gesture_patternindicator_grid_normal"] forState:UIControlStateNormal];
                //禁止按钮响应事件
                setButton.userInteractionEnabled = NO;
                [imgView addSubview:setButton];
            }
            
            orgY += imgView.bounds.size.height;
        }
        [self addSubview:imgView];
        
    
        displayName = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, orgY, 280, IS_IPHONE_4_OR_LESS ? label_height: label_height / 2)];
        [displayName setTextAlignment:NSTextAlignmentCenter];
        [displayName setText:user.userName];
        [displayName setFont:[UIFont systemFontOfSize:15.f]];
        [displayName setTextColor:[UIColor grayColor]];
        [self addSubview:displayName];
        
        orgY += displayName.bounds.size.height;
        state = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/2-140, orgY, 280, label_height)];
        [state setTextAlignment:NSTextAlignmentCenter];
        [state setFont:[UIFont systemFontOfSize:13.f]];
        [self addSubview:state];
        

        orgY += state.bounds.size.height;
        tentacleView = [[TentacleView alloc]initWithFrame:CGRectMake(frame.size.width/2-160, orgY, 320, 320)];
        [self addSubview:tentacleView];
        //huangcong ---add
        
   
        
        float actionButtonHeight = label_height /2;
        actionButton = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2-140, frame.size.height - actionButtonHeight - 40, 280, actionButtonHeight)];
        [actionButton.titleLabel setFont:[UIFont systemFontOfSize:17.f]];
        [actionButton setTitleColor:[UIColor getColor:@"05b8f3"] forState:UIControlStateNormal];
        [self addSubview:actionButton];
        
    }
    
    return self;
}

- (void)gestureTouchBegin {
    [self.state setText:@""];
}


@end
