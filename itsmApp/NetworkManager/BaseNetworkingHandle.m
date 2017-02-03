//
//  BaseNetworkingHandle.m
//  RedPacket
//
//  Created by itp on 15/11/11.
//  Copyright © 2015年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "EMMNetworking.h"
#import "NetworkingManager.h"

@implementation BaseNetworkingHandle

- (id)init
{
    self = [super init];
    if (self) {
        _requestObj = [[RequestObject alloc] initWithCommandName:[[self class] commandName]];
        [_requestObj.d addEntriesFromDictionary:@{@"UID":self.requestObj.eu}];
    }
    return self;
}

+ (NSString *)path
{
    return @"";
}

+ (NSString *)commandName
{
    return @"";
}

- (NetworkingManager *)networkingManager
{
    return [NetworkingManager share];
}

- (void)sendRequest
{
    if ([self respondsToSelector:@selector(customRequest)]) {
        NSURLRequest *request = [self customRequest];
        [self sendRequestWithRequest:request];
    }else
    {
        [self sendRequestWithMethod:@"POST" dataEncodingType:PostDataEncodingTypeJSON];
    }
}

- (void)sendRequestWithMethod:(NSString *)method dataEncodingType:(PostDataEncodingType)encodingType
{
    if ([method length] == 0) {
        NSLog(@"method is nil");
        return;
    }
    
    NetworkingManager *manager = [self networkingManager];
    NSString *postPath = [manager.urlManager path:[[self class] path]];
 
    if ([postPath length] == 0) {
        NSLog(@"postPath is nil");
        return;
    }
    
    NSDictionary *postDict = [self.requestObj requestDictionary];
    
    NSURLRequest *request = [manager.httpManager requestWithMethod:method
                                                              path:postPath
                                                        parameters:postDict
                                              postDataEncodingType:encodingType];

    [self sendRequestWithRequest:request];
}

- (void)sendRequestWithRequest:(NSURLRequest *)request
{
    NetworkingManager *manager = [self networkingManager];
    __weak typeof(self) weakSelf = self;
    EMMHTTPRequestOperation *op = [manager.httpManager HTTPRequestOperationWithRequest:request success:^(EMMHTTPRequestOperation *operation, id responseObject) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            
            NSDictionary *responseDict = [operation responseJSON];
            ResponseObject *result = nil;
            if ([responseDict isKindOfClass:[NSDictionary class]])
            {
                result = [[ResponseObject alloc] initWithDictionary:responseDict];
            }
            
            if (result.s) {
                if ([strongSelf respondsToSelector:@selector(willHandleSuccessedResponse:)]) {
                    [strongSelf willHandleSuccessedResponse:result];
                }
                
                if ([strongSelf.delegate respondsToSelector:@selector(successed:response:)]) {
                    [strongSelf.delegate successed:strongSelf response:result];
                }
                
                if ([strongSelf respondsToSelector:@selector(didHandleSuccessedResponse:)]) {
                    [strongSelf didHandleSuccessedResponse:result];
                }
            }
            else
            {
                NSError *error = [NSError errorWithDomain:@"NetworkHandleEroor" code:[result.c integerValue] userInfo:nil];
                if ([strongSelf respondsToSelector:@selector(willHandleFailure:)]) {
                    [strongSelf willHandleFailure:error];
                }
                
                if ([strongSelf.delegate respondsToSelector:@selector(failured:error:)]) {
                    [strongSelf.delegate failured:strongSelf error:error];
                }
                
                if ([strongSelf respondsToSelector:@selector(didHandleFailure:)]) {
                    [strongSelf didHandleFailure:error];
                }
            }
        }
        else
        {
            NSLog(@"weaself release");
        }
        
    } failure:^(EMMHTTPRequestOperation *operation, NSError *error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf) {
            if ([strongSelf respondsToSelector:@selector(willHandleFailure:)]) {
                [strongSelf willHandleFailure:error];
            }
            
            if ([strongSelf.delegate respondsToSelector:@selector(failured:error:)]) {
                [strongSelf.delegate failured:strongSelf error:error];
            }
            
            if ([strongSelf respondsToSelector:@selector(didHandleFailure:)]) {
                [strongSelf didHandleFailure:error];
            }
        }
        
    }];
    [manager.httpManager enqueueHTTPRequestOperation:op];
}

@end
