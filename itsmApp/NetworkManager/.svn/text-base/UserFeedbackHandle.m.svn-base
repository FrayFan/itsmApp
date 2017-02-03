//
//  UserFeedbackHandle.m
//  itsmApp
//
//  Created by itp on 2016/12/26.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "UserFeedbackHandle.h"

@implementation UserFeedbackHandle
+ (NSString *)path
{
    return FeedbackPath;
}

+ (NSString *)commandName
{
    return @"createAdvise";
}

- (void)buildFeedbackData
{
    [self.requestObj.d setObject:self.scg ?:@"" forKey:@"SCG"];
    [self.requestObj.d setObject:self.feedback ?:@"" forKey:@"ACT"];
    if (self.picDict) {
        [self.requestObj.d addEntriesFromDictionary:self.picDict];
    }
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSDictionary class]]) {
        
    }
}

@end
