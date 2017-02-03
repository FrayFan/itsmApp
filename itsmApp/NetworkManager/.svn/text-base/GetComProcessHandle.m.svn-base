//
//  GetComProcessHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetComProcessHandle.h"
#import "NSDictionary+NSNull.h"

@implementation GetComProcessHandle
-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"getComplainProcess";
}

+ (NSString *)path
{
    return ComplainPath;
}

+ (NSDictionary *)data
{
    return @{@"RK":@"",@"RID":@""};
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDic = [NSDictionary nullDic:obj.d];
        ComProcessModel *complainModel = [ComProcessModel makecomplainModel:dataDic];
        _comProcessModels = [NSMutableArray arrayWithObject:complainModel];

    }

}

@end


@implementation ComProcessModel

+ (ComProcessModel *)makecomplainModel:(NSDictionary *)dict
{
    ComProcessModel *comProcessModel = [[ComProcessModel alloc] init];
    comProcessModel.receiptId = dict[@"RID"];
    comProcessModel.complainID = dict[@"CST"];
    comProcessModel.complainStatus = dict[@"UNM"];
    comProcessModel.complainUserId = dict[@"CUID"];
    comProcessModel.complainProcessUserId = dict[@"CPUID"];
    comProcessModel.beComplainedUserId = dict[@"BCUID"];
    comProcessModel.complainContent = dict[@"CCT"];
    comProcessModel.complainProcessContent = dict[@"CPCT"];
    
    //投诉内容高度
    if (comProcessModel.complainContent.length>0) {
        comProcessModel.complainHeight = [FFLabel getLableHeight:15 width:KScreenWidth-45 text:comProcessModel.complainContent linespace:0];
        
    }
    
    //回复内容高度
    if ([comProcessModel.complainProcessContent class]== NULL) {
        comProcessModel.beComplainHeight = [FFLabel getLableHeight:15 width:KScreenWidth-45 text:comProcessModel.complainProcessContent linespace:0];
        
    }


    return comProcessModel;
}

@end
