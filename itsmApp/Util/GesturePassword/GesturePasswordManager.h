//
//  GesturePasswordManager.h
//  itsmApp
//
//  Created by itp on 2017/1/11.
//  Copyright © 2017年 itp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GesturePasswordManager : NSObject
@property (nonatomic,strong,readonly)NSString *gestureString;

+ (GesturePasswordManager *)share;

- (void)saveGesture:(NSString *)gesture;

@end
