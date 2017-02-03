//
//  AppDelegate.m
//  itsmApp
//
//  Created by itp on 2016/11/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "AppDelegate.h"
#import "EMMSecurity.h"
#import "EMMAppUpdate.h"

#import "MBProgressHUD.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "GetUserInfoHandle.h"

#import "GesturePasswordManager.h"
#import "GesturePasswordController.h"

//#define EMMAppID @"A00195" //测试
#define EMMAppID @"A00246" //正式

#define kHaveGesturePassword    @"HaveGesturePassword"

@interface AppDelegate ()<EMMSecurityVerifyDelegate,NetworkHandleDelegate>
@property (nonatomic,strong)MMDrawerController *drawerController;
@property (nonatomic,strong)GetUserInfoHandle *userInfoHandle;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[EMMSecurity share] applicationLaunchingWithAppId:EMMAppID];
    [EMMSecurity share].delegate = self;//10164014
    
//    [[EMMSecurity share] loginWithUserId:@"10164014" password:@"1"];
    
    [[EMMAppUpdate share] checkAppVersion:EMMAppID withSSOToken:[EMMSecurity share].token];
    
    self.drawerController = (MMDrawerController *)self.window.rootViewController;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [self.drawerController setCenterViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"CenterNavigation"]];
    
    [self.drawerController setLeftDrawerViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"LeftViewController"]];
    [self.drawerController setShouldStretchDrawer:NO];
    [self.drawerController setShowsShadow:NO];
//    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:240.0];
//    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    if ([[GesturePasswordManager share].gestureString length] == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            GesturePasswordController *gesturePasswordController = [[GesturePasswordController alloc] initWithNibName:@"GesturePasswordController" bundle:nil];
            gesturePasswordController.type = GesturePasswordTypeSetting;
            [self.drawerController presentViewController:gesturePasswordController animated:NO completion:nil];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            GesturePasswordController *gesturePasswordController = [[GesturePasswordController alloc] initWithNibName:@"GesturePasswordController" bundle:nil];
            gesturePasswordController.type = GesturePasswordTypeVerify;
            [self.drawerController presentViewController:gesturePasswordController animated:NO completion:nil];
        });
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark SecurityVerifyDelegate

/**
 *  安全认证失败
 *
 *  @param errorCode 错误码
 *
 *  TokenNotFound = 0   没有读取到token 如果是MOA需要跳转到登录界面，如果是其他程序自动跳转到MOA去登录
 *  TokenInvalidate     读取到token 校验后token失效
 *  EncryptionError     加密串校验失败
 *  PasswordError       用户名密码校验失败
 *
 *  @param errorMsg  错误提示语
 */
- (void)securityVerifyFailureWithCode:(NSInteger)errorCode errorMsg:(NSString *)errorMsg
{
    NSLog(@"securityVerifyFailure,errorCode =%ld,errorMsg = %@",(long)errorCode,errorMsg);    
}

static BOOL needUserInfo = YES;

/**
 *  安全验证成功
 *
 *  @param verifyType (TokenVerify = 0,EncryptionVerify,PasswordVerify,SSOVerify)
 */
- (void)securityVerifySuccess:(NSInteger)verifyType
{
    NSLog(@"securityVerifySuccess verifyType = %ld",(long)verifyType);
    
//    if ([[UserBaseInfo share].userId isEqualToString:[EMMSecurity share].userId]) {
//        needUserInfo = NO;
//    }
//    else
//    {
//        needUserInfo = YES;
//    }
    
    if (needUserInfo)
    {
//        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        self.userInfoHandle = [[GetUserInfoHandle alloc] init];
        self.userInfoHandle.delegate = self;
        [self.userInfoHandle sendRequest];
    }
    
}

#pragma mark NetworkHandleDelegate

- (void)successed:(id)handle response:(id)response
{
    if (handle == self.userInfoHandle) {
        needUserInfo = NO;
    }
}

- (void)failured:(id)handle error:(NSError *)error
{
    if (handle == self.userInfoHandle) {
        needUserInfo = YES;
    }
}

@end
