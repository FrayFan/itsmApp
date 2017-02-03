//
//  GetFAQDetailHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetFAQDetailHandle.h"
#import "FFLabel.h"
#import "common.h"

@implementation GetFAQDetailHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"getFAQInfo";
}

+ (NSString *)path
{
    return FAQListPath;
}

+ (NSDictionary *)data
{
    return @{@"RK":@"01",@"TS":@"00",@"FID":@""};
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    FAQDetailModel *FAQDetail = [FAQDetailModel makeDetailModel:obj.d];
    _FAQModels = [NSMutableArray arrayWithObject:FAQDetail];
}


@end



@implementation FAQDetailModel

+ (FAQDetailModel *)makeDetailModel:(NSDictionary *)dict
{
    FAQDetailModel *FAQDeModel = [[FAQDetailModel alloc] init];
    FAQDeModel.FAQID = dict[@"FID"];
    FAQDeModel.FAQTitle = dict[@"FT"];
    FAQDeModel.FAQContent = dict[@"FCT"];
    
    //根据页面显示处理model
    //单据内容高度
    if ([FAQDeModel.FAQContent class]!= NULL) {
        
        FAQDeModel.contentHeight = [FFLabel getLableHeight:15 width:KScreenWidth-30 text:FAQDeModel.FAQContent linespace:0];
        
    }

    return FAQDeModel;
}


@end
