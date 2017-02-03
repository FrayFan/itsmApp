//
//  GetCancelHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetCancelHandle.h"

@implementation GetCancelHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"cancelReceipt";
}

+ (NSString *)path
{
    return BaseDataPath;
}

+ (NSDictionary *)data
{
    return @{@"RK":@"01",@"TS":@"00",@"RID":@""};
}

- (void)willHandleSuccessedResponse:(id)response
{
//    ResponseObject *obj = response;
    
}



@end
