//
//  GesturePasswordController.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "GesturePasswordController.h"
#import "UIColor+HEX.h"
#import "ToastView.h"
#import "GesturePasswordManager.h"
#import "Utils.h"

//设备的状态栏高度
#define ScreenStatusBarHeight 20.0f
#define NavigationBarHeight 44.0f

@interface GesturePasswordController ()

@property (nonatomic,strong) GesturePasswordView * gesturePasswordView;

@end

@implementation GesturePasswordController {
    NSString * previousString;
    NSString * password;
}

@synthesize gesturePasswordView;
@synthesize type;
@synthesize verifyTime;
@synthesize imgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) wself = self;
    if (!self.completionBlock) {
        self.completionBlock = ^{
            [wself dismissViewControllerAnimated:YES completion:nil];
        };
    }
    // Do any additional setup after loading the view.
    previousString = [NSString string];
    password = [GesturePasswordManager share].gestureString;
    verifyTime= 0;
    if (GesturePasswordTypeSetting == type || GesturePasswordTypeModify == type)
    {
        [self reset];
    }
    else if(GesturePasswordTypeVerify == type || GesturePasswordTypeLockOrSuspendVerify == type)
    {
        [self verify];
    }

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    //页面析构，取消延迟执行函数
}


#pragma mark - 验证手势密码
- (void)verify{
    verifyTime = 5;
    
    CGRect frameForgesturePasswordView = [UIScreen mainScreen].bounds;
    
    //去除状态栏, 也即y向下移动状态栏的高度
    frameForgesturePasswordView.origin.y += (ScreenStatusBarHeight);
    frameForgesturePasswordView.size.height -= (ScreenStatusBarHeight);
    gesturePasswordView = [[GesturePasswordView alloc]initWithFrame:frameForgesturePasswordView andflag:2];
    [gesturePasswordView.tentacleView setDrawResultDelegate:self];

    NSString *title = @"忘记手势密码？";
    [gesturePasswordView.title setHidden:YES];
    [gesturePasswordView.actionButton setTitle:title forState:UIControlStateNormal];
    [gesturePasswordView.actionButton addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:gesturePasswordView];
}

#pragma mark - 重置手势密码
- (void)reset
{
    NSString *title = @"设置手势密码";
    NSString *txt = @"绘制解锁图案";
    
    CGRect frameForgesturePasswordView = [UIScreen mainScreen].bounds;
    //去除状态栏, 也即y向下移动状态栏的高度
    frameForgesturePasswordView.origin.y += (ScreenStatusBarHeight);
    frameForgesturePasswordView.size.height -= (ScreenStatusBarHeight);
    
    if (self.showNavigationBar) {
        frameForgesturePasswordView.origin.y += (NavigationBarHeight);
        frameForgesturePasswordView.size.height -= NavigationBarHeight;
        
        UIButton *leftButton = [Utils leftButtonWithTitleAndImage:@"返回"];
        [leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.title = title;
        title = @"";
    }
    
    gesturePasswordView = [[GesturePasswordView alloc] initWithFrame: frameForgesturePasswordView andflag:1];
    [gesturePasswordView.tentacleView setDrawResultDelegate:self];
    [gesturePasswordView.title setText:title];
    [gesturePasswordView.state setText:txt];
    [gesturePasswordView.state setTextColor:[UIColor getColor:@"05b8f3"]];
    txt = @"重新设置手势";
    [gesturePasswordView.actionButton setTitle:txt forState:UIControlStateNormal];
    [gesturePasswordView.actionButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:gesturePasswordView];
}

- (void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 判断是否已存在手势密码
- (BOOL)exist{

    password = [GesturePasswordManager share].gestureString;
    if ([password isEqualToString:@""])return NO;
    return YES;
}

#pragma mark - 清空记录
- (void)clear{
    
}

#pragma mark - 改变手势密码
- (void)change
{
    NSString *txt = @"绘制解锁图案";
    previousString=@"";
    [gesturePasswordView.state setText:txt];
    [gesturePasswordView.state setTextColor:[UIColor getColor:@"05b8f3"]];
    [gesturePasswordView.tentacleView enterArgin];
}

#pragma mark - 忘记手势密码
- (void)forget{
    
}

- (BOOL)DrawResult:(NSString *)result
{
    if (GesturePasswordTypeVerify == type || GesturePasswordTypeLockOrSuspendVerify == type)
    {
        return [self verification:result];
    }
    else
    {
        return [self resetPassword:result];
    }
}

- (BOOL)verification:(NSString *)result{
    NSString *txt;
    if ([result isEqualToString:password]) {
        txt = @"输入正确";
        [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
        [gesturePasswordView.state setText:txt];
        if (self.completionBlock) {
            self.completionBlock();
        }
        return YES;
    }
    if (verifyTime > 1)
    {
        txt = @"密码错了，还可以输入%d次";
        [gesturePasswordView.state setTextColor:[UIColor redColor]];
        verifyTime--;
        [gesturePasswordView.state setText:[[NSString alloc] initWithFormat: txt,verifyTime]];
        gesturePasswordView.state.lineBreakMode =NSLineBreakByWordWrapping;
        [gesturePasswordView.tentacleView enterArgin];
    }
    else
    {
        NSString *title = @"设置手势密码";
        NSString *txt = @"绘制解锁图案";
        [gesturePasswordView.title setText:title];
        [gesturePasswordView.state setText:txt];
        [gesturePasswordView.state setTextColor:[UIColor getColor:@"05b8f3"]];
        txt = @"重新设置手势";
        [gesturePasswordView.actionButton setTitle:txt forState:UIControlStateNormal];
        [gesturePasswordView.actionButton addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchDown];
        gesturePasswordView.state.lineBreakMode =NSLineBreakByWordWrapping;
        [gesturePasswordView.tentacleView enterArgin];
        type = GesturePasswordTypeSetting;
        [[GesturePasswordManager share] saveGesture:nil];
    }
    
    return NO;
}

- (BOOL)resetPassword:(NSString *)result{
    NSString *txt;
    if (result.length < 5)
    {
        txt = @"最少连接5个点，请重新输入";
        [gesturePasswordView.state setTextColor:[UIColor redColor]];
        [gesturePasswordView.state setText:txt];
        [gesturePasswordView.tentacleView enterArgin];
        return NO;
    }
    
    if ([previousString isEqualToString:@""]) {
        previousString=result;
        txt = @"再次绘制解锁图案";
        [gesturePasswordView.tentacleView enterArgin];
        [gesturePasswordView.state setTextColor:[UIColor getColor:@"05b8f3"]];
        [gesturePasswordView.state setText:txt];
        return YES;
    }
    else {
        if ([result isEqualToString:previousString]) {

            [gesturePasswordView.state setTextColor:[UIColor colorWithRed:2/255.f green:174/255.f blue:240/255.f alpha:1]];
            txt = @"已保存手势密码";
            [gesturePasswordView.state setText:txt];
            if (GesturePasswordTypeSetting == type)
            {//首次登陆时设置
                txt = @"手势密码设置成功，请记住密码";
                [ToastView showWithText:txt];
                [[GesturePasswordManager share] saveGesture:result];
                if (self.completionBlock) {
                    self.completionBlock();
                }
            }
            else if (GesturePasswordTypeModify == type)
            {
                txt = @"手势密码修改成功，请记住密码";
                [ToastView showWithText:txt];
                [[GesturePasswordManager share] saveGesture:result];
                if (self.completionBlock) {
                    self.completionBlock();
                }
            }
            return YES;
        }
        else{
            //previousString =@"";
            txt = @"与上次绘制不一致，请重新绘制";
            [gesturePasswordView.state setTextColor:[UIColor redColor]];
            [gesturePasswordView.state setText:txt];
            [gesturePasswordView.tentacleView enterArgin];
            return NO;
        }
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
