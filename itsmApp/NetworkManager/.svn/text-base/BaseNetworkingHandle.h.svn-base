//
//  BaseNetworkingHandle.h
//  RedPacket
//
//  Created by itp on 15/11/11.
//  Copyright © 2015年 itp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkingManager.h"

@protocol NetworkHandleDelegate <NSObject>

@optional

- (void)successed:(id)handle response:(id)response;

- (void)failured:(id)handle error:(NSError *)error;

@end


@protocol NetworkHandleProtocol <NSObject>

- (void)sendRequest;

+ (NSString *)path;

+ (NSString *)commandName;

- (NetworkingManager *)networkingManager;

@optional

- (NSURLRequest *)customRequest;

- (NSURLRequest *)customDownLoadRequest;

- (void)willHandleSuccessedResponse:(id)response;

- (void)didHandleSuccessedResponse:(id)response;

- (void)willHandleFailure:(NSError *)error;

- (void)didHandleFailure:(NSError *)error;

@end

@interface BaseNetworkingHandle : NSObject<NetworkHandleProtocol>
@property (nonatomic,weak)id<NetworkHandleDelegate> delegate;
@property (nonatomic,strong,readonly)RequestObject *requestObj;

@end
