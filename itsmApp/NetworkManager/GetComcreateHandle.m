//
//  GetComcreateHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/23.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetComcreateHandle.h"

@implementation GetComcreateHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"createComplain";
}

+ (NSString *)path
{
    return ComplainPath;
}

+ (NSDictionary *)data
{
    return @{@"CCT":@"",@"RID":@"",@"BCUID":@""};
}

- (void)willHandleSuccessedResponse:(id)response
{
//        ResponseObject *obj = response;
    
}

@end
