//
//  Util.h
//  itsmApp
//
//  Created by itp on 2016/12/7.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (void)showMessageAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle;

+ (NSURL *)createFolderWithName:(NSString *)folderName inDirectory:(NSString *)directory;

+ (NSString *)dataPath;

+(UIButton *)leftButtonWithTitleAndImage:(NSString *)title;

@end
