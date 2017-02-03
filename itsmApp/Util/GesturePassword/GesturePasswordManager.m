//
//  GesturePasswordManager.m
//  itsmApp
//
//  Created by itp on 2017/1/11.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "GesturePasswordManager.h"

#define kGesturePassword    @"GesturePassword"

@implementation GesturePasswordManager

+ (GesturePasswordManager *)share
{
    static GesturePasswordManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDict = [[NSUserDefaults standardUserDefaults] objectForKey:kGesturePassword];
        share = [[self alloc] initWithDictionary:infoDict];
    });
    return share;
}

- (id)initWithDictionary:(NSDictionary *)infoDict
{
    self = [super init];
    if (self) {
        _gestureString = infoDict[@"gesture"];
    }
    return self;
}

- (void)saveGesture:(NSString *)gesture
{
    _gestureString = gesture;
    NSDictionary *infoDict = @{@"gesture":self.gestureString ?:@""};
    [[NSUserDefaults standardUserDefaults] setObject:infoDict forKey:kGesturePassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
