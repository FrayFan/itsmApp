//
//  RefreshInfoHandle.m
//  itsmApp
//
//  Created by itp on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "RefreshInfoHandle.h"
#import "NetworkingManager.h"
#import "GetUserInfoHandle.h"

#define kRefreshTime @"refreshTime"
#define kUnreadCount @"unreadCount"

NSString * const UnReadMessageDidChangeNotification = @"UnReadMessageDidChange";


@interface UnreadMessage ()

- (void)updateWithContent:(NSDictionary *)content;

@end

@implementation RefreshInfoHandle

- (id)init
{
    self = [super init];
    if (self) {
        [self updateRefreshTime];
    }
    return self;
}

+ (NSString *)path
{
    return MessagesPath;
}

+ (NSString *)commandName
{
    return @"getRefreshMsgCount";
}

- (void)updateRefreshTime
{
    self.requestObj.d[@"RFT"] = [UnreadMessage share].refreshTime ?:@"";
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSDictionary class]]) {
        [[UnreadMessage share] updateWithContent:obj.d];
    }
}


@end

@implementation UnreadMessage

- (id)init
{
    self = [super init];
    if (self) {
        _refreshTime = [[NSUserDefaults standardUserDefaults] objectForKey:kRefreshTime];
        _unreadCount = [[[NSUserDefaults standardUserDefaults] objectForKey:kUnreadCount] integerValue];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidChange) name:UserDidChangeNotification object:nil];
    }
    return self;
}

- (void)updateWithContent:(NSDictionary *)content
{
    _unreadCount = [content[@"CNT"] integerValue] ?:0;
    [[NSUserDefaults standardUserDefaults] setObject:@(self.unreadCount) forKey:kUnreadCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UnReadMessageDidChangeNotification object:nil];
}

- (void)resetWithRefreshTime:(NSString *)latestRefreshTime
{
    _refreshTime = latestRefreshTime ?:@"";
    _unreadCount = 0;
    [[NSUserDefaults standardUserDefaults] setObject:self.refreshTime forKey:kRefreshTime];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.unreadCount) forKey:kUnreadCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UnReadMessageDidChangeNotification object:nil];
}

- (void)userDidChange
{
    [self resetWithRefreshTime:nil];
}

+ (UnreadMessage *)share
{
    static UnreadMessage *lib = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lib = [[self alloc] init];
    });
    return lib;
}

@end

