//
//  GetUserInfoApi.h
//  RedPacket
//
//  Created by itp on 15/11/10.
//  Copyright © 2015年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"

extern NSString * const UserInfoDidUpdateNotification;

extern NSString * const UserDidChangeNotification;

@interface GetUserInfoHandle : BaseNetworkingHandle


@end


@interface UserBaseInfo : BaseNetworkingObject
@property (nonatomic,copy,readonly) NSString *userId;
@property (nonatomic,copy,readonly) NSString *userName;
@property (nonatomic,copy,readonly) NSString *department;
@property (nonatomic,copy,readonly) NSString *mobilePhone;
@property (nonatomic,copy,readonly) NSString *headerUrl;
@property (nonatomic,copy,readonly) NSString *rank;
@property (nonatomic,copy,readonly) NSString *isVip;

+ (UserBaseInfo *)share;

- (void)refreshUserInfo:(NSDictionary *)info;

- (BOOL)isEngineer;

@end
