//
//  GetUserInfoApi.m
//  RedPacket
//
//  Created by itp on 15/11/10.
//  Copyright © 2015年 itp. All rights reserved.
//

#import "GetUserInfoHandle.h"
#import "NetworkingManager.h"
#import "EMMNetworking.h"
#import "NSDictionary+NSNull.h"

NSString * const UserInfoDidUpdateNotification = @"UserInfoDidUpdate";
NSString * const UserDidChangeNotification = @"UserDidChange";

@interface GetUserInfoHandle ()

@end

@implementation GetUserInfoHandle

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSString *)commandName
{
    return @"getUserInfo";
}

+ (NSString *)path
{
    return BaseDataPath;
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSDictionary class]]) {
        [[UserBaseInfo share] refreshUserInfo:[NSDictionary nullDic:obj.d]];
    }
}

@end


#define kUserInfo   @"UserInfo"

@interface UserBaseInfo ()
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *department;
@property (nonatomic,copy) NSString *mobilePhone;
@property (nonatomic,copy) NSString *headerUrl;
@property (nonatomic,copy) NSString *rank;
@property (nonatomic,copy) NSString *isVip;
@end

@implementation UserBaseInfo

+ (UserBaseInfo *)share
{
    static UserBaseInfo *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDict = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
        share = [[self alloc] initWithDictionary:infoDict];
    });
    return share;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super initWithDictionary:dict];
    if (self) {
        self.userId = dict[@"UID"];
        self.userName = dict[@"UNM"];
        self.department = dict[@"DPT"];
        self.mobilePhone = dict[@"MPH"];
        self.headerUrl = dict[@"LGURL"];
        self.rank = dict[@"RK"];
        self.isVip = dict[@"ISVIP"];
        if ([self.isVip length] == 0) {
            self.isVip = @"F";
        }
    }
    return self;
}

- (NSDictionary *)networkingDictionary
{
    return @{@"UID":self.userId ?:@"",
             @"UNM":self.userName ?:@"",
             @"DPT":self.department ?:@"",
             @"MPH":self.mobilePhone ?:@"",
             @"LGURL":self.headerUrl ?:@"",
             @"RK":self.rank ?:@"",
             @"ISVIP":self.isVip ?:@"F"};
}

- (void)refreshUserInfo:(NSDictionary *)info
{
    NSString *currentUserId = info[@"UID"];
    if (![self.userId isEqualToString:currentUserId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidChangeNotification object:nil userInfo:nil];
    }
    self.userId = currentUserId;
    self.userName = info[@"UNM"];
    self.department = info[@"DPT"];
    self.mobilePhone = info[@"MPH"];
    self.headerUrl = info[@"LGURL"];
    self.rank = info[@"RK"];
    self.isVip = info[@"ISVIP"];
    if ([self.isVip length] == 0) {
        self.isVip = @"F";
    }
    [[NSUserDefaults standardUserDefaults] setObject:[self networkingDictionary] forKey:kUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoDidUpdateNotification object:nil userInfo:nil];
}

- (BOOL)isEngineer
{
    return [self.rank isEqualToString:@"02"];
}

@end

