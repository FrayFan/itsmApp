//
//  GetEvaluateHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/20.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetEvaluateHandle.h"

@interface GetEvaluateHandle ()

@end

@implementation GetEvaluateHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"getEvaluateCatalogList";
}

+ (NSString *)path
{
    return EvaluatePath;
}

+ (NSDictionary *)data
{
    return @{@"RK":@"",@"RID":@""};
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSArray class]]) {
        NSMutableArray<EvaluateModel *> *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *evaluateDic in obj.d) {
            EvaluateModel *evaluateModel = [EvaluateModel makeEvaluateModel:evaluateDic];
            [tempArray addObject:evaluateModel];
        }
        self.evaluteModels = [NSArray arrayWithArray:tempArray];
    }
    
}

@end


@implementation EvaluateModel

+ (EvaluateModel *)makeEvaluateModel:(NSDictionary *)dict
{
    EvaluateModel *evaluateModel = [[EvaluateModel alloc] init];
    evaluateModel.rank = dict[@"RK"];
    evaluateModel.abstract = dict[@"ABS"];
    evaluateModel.catalogs = dict[@"CTS"];
    
    return evaluateModel;
}

@end
