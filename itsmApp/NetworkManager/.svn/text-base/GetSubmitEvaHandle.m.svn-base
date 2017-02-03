//
//  GetSubmitEvaHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/21.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetSubmitEvaHandle.h"

@implementation GetSubmitEvaHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"createEvaluate";
}

+ (NSString *)path
{
    return EvaluatePath;
}

+ (NSDictionary *)data
{
    return @{@"RK":@"",@"RID":@"",@"CTS":@[@{}],@"EVCT":@""};
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    
}

@end
