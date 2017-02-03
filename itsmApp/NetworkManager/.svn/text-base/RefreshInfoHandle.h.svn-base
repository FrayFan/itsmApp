//
//  RefreshInfoHandle.h
//  itsmApp
//
//  Created by itp on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"

extern NSString * const UnReadMessageDidChangeNotification;

@interface RefreshInfoHandle : BaseNetworkingHandle

- (void)updateRefreshTime;

@end

@interface UnreadMessage : NSObject

@property (nonatomic,assign,readonly)NSInteger unreadCount;

@property (nonatomic,strong,readonly)NSString *refreshTime;

+ (UnreadMessage *)share;

- (void)resetWithRefreshTime:(NSString *)latestRefreshTime;

@end
