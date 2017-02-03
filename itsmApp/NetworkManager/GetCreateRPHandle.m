//
//  GetCreateRPHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/23.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetCreateRPHandle.h"

@implementation GetCreateRPHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"createReceiptProcess";
}

+ (NSString *)path
{
    return BaseDataPath;
}

+ (NSDictionary *)data
{
    return @{@"RID":@"01",@"PSN":@"00",@"EUID":@"",@"PSLT":@"00"};
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
}



@end
