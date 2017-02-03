//
//  Util.m
//  itsmApp
//
//  Created by itp on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>
#import "UIColor+HEX.h"

@implementation Utils

+ (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (UIViewController *)mostFrontViewController {
    UIViewController *vc = [self rootViewController];
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (void)showMessageAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle
{
    [self showMessageAlertWithTitle:title message:message actionTitle:actionTitle actionHandler:nil];
}

+ (void)showMessageAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle actionHandler:(void (^)())actionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action;
    if (actionHandler) {
        action = [UIAlertAction actionWithTitle:actionTitle
                                          style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action){
                                            actionHandler();
                                        }];
    }else {
        action = [UIAlertAction actionWithTitle:actionTitle
                                          style:UIAlertActionStyleCancel
                                        handler:nil];
    }
    
    [alertController addAction:action];
    
    [[self mostFrontViewController] presentViewController:alertController animated:YES completion:nil];
    
}


+ (NSURL *)createFolderWithName:(NSString *)folderName inDirectory:(NSString *)directory {
    NSString *path = [directory stringByAppendingPathComponent:folderName];
    NSURL *folderURL = [NSURL URLWithString:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error;
        [fileManager createDirectoryAtPath:path
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&error];
        if (!error) {
            return folderURL;
        }else {
            NSLog(@"创建文件失败 %@", error.localizedFailureReason);
            return nil;
        }
        
    }
    return folderURL;
}


+ (NSString*)dataPath {
    static NSString *_dataPath;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataPath = [NSString stringWithFormat:@"%@/Library/appdata/chatbuffer", NSHomeDirectory()];
    });
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:_dataPath]){
        [fm createDirectoryAtPath:_dataPath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil];
    }
    
    return _dataPath;
}

+ (UIButton *)leftButtonWithTitleAndImage:(NSString *)title {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0,80, 44);
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [leftButton setTitleColor:[UIColor getColor:@"080808"] forState:UIControlStateNormal];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(11,-8, 11, 47)];
    return leftButton;
}


@end
