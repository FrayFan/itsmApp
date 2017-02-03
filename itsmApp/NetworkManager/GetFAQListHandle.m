//
//  GetFAQListHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetFAQListHandle.h"

@implementation GetFAQListHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"getFAQList";
}

+ (NSString *)path
{
    return FAQListPath;
}

+ (NSDictionary *)data
{
    return @{@"RK":@"",@"RID":@"",@"CTS":@[@{}],@"EVCT":@""};
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSArray class]]) {
        NSMutableArray<FAQListModel *> *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *FAQDic in obj.d) {
            FAQListModel *FAQModel = [FAQListModel makeFAQModel:FAQDic];
            [tempArray addObject:FAQModel];
        }
        self.FAQModels = [NSMutableArray arrayWithArray:tempArray];
    }
    
}

@end

@implementation FAQListModel

+ (FAQListModel *)makeFAQModel:(NSDictionary *)dict
{
    FAQListModel *FAQlModel = [[FAQListModel alloc] init];
    FAQlModel.FAQID = dict[@"FID"];
    FAQlModel.FAQTitle = dict[@"FT"];

    return FAQlModel;
}

@end
