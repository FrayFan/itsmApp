//
//  GetComplainHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetComplainHandle.h"
#import "NSDictionary+NSNull.h"
#import "FFLabel.h"
#import "common.h"

@implementation GetComplainHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"getComplainList";
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
    if ([obj.d isKindOfClass:[NSArray class]]) {
        NSMutableArray<ComplainModel *> *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *complainDic in obj.d) {
            NSDictionary *dataDic = [NSDictionary nullDic:complainDic];
            ComplainModel *complainModel = [ComplainModel makecomplainModel:dataDic];
            [tempArray addObject:complainModel];
        }
        self.complainModels = [NSMutableArray arrayWithArray:tempArray];
    }
    
}

@end

@implementation ComplainEngineerModel

+ (ComplainEngineerModel *)makeEngineerModel:(NSMutableDictionary *)dict
{
    ComplainEngineerModel *engineerModel = [[ComplainEngineerModel alloc]init];
    if (![dict isEqual:@""]) {
        engineerModel.engineerName = dict[@"EN"];
        engineerModel.engineerID = dict[@"EID"];
        engineerModel.engineerPhone = dict[@"EP"];
        engineerModel.engineerDept = dict[@"EDPT"];
        engineerModel.engineerHeadImg = dict[@"EIMG"];
        engineerModel.engineerSkill = dict[@"EK"];
        
        //处理技能标签
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *skillDic in engineerModel.engineerSkill) {
            NSString *skill = skillDic[@"CTNM"];
            [tempArray addObject:skill];
        }
        engineerModel.engineerSkill = tempArray;
        
    }
    
    return engineerModel;
}

@end


@implementation ComplainModel

+ (ComplainModel *)makecomplainModel:(NSDictionary *)dict
{
    ComplainModel *complainModel = [[ComplainModel alloc] init];
    complainModel.receiptId = dict[@"RID"];
    complainModel.userId = dict[@"UID"];
    complainModel.userName = dict[@"UNM"];
    complainModel.userPhone = dict[@"UP"];
    complainModel.userDept = dict[@"UDPT"];
    complainModel.createTime = dict[@"CTM"];
    complainModel.content = dict[@"CT"];
    complainModel.picturesURL = dict[@"PICURL"];
    complainModel.voidceURL = dict[@"VOIURL"];
    complainModel.attachmentURL = dict[@"ATTURL"];
    complainModel.type = dict[@"TY"];
    complainModel.subscribeTime = dict[@"SUBTM"];
    complainModel.complainTime = dict[@"CMTM"];
    complainModel.isVip = dict[@"ISVIP"];
    complainModel.location = dict[@"LT"];
    complainModel.orginalType = dict[@"OT"];
    complainModel.evaluateStatus = dict[@"EVS"];
    complainModel.ticketStatus = dict[@"TS"];
    complainModel.engineerModel = [ComplainEngineerModel makeEngineerModel:dict[@"EVO"]];
    complainModel.currentStage = dict[@"CS"];
    complainModel.nextStage = dict[@"NS"];
    complainModel.category1 = dict[@"C1"];
    complainModel.category2 = dict[@"C2"];
    
    //根据页面显示处理model
    //处理提单时间、预约时间
    complainModel.complainTime = [complainModel.complainTime substringWithRange:NSMakeRange(0, complainModel.complainTime.length-3)];

    //单据内容高度
    complainModel.contentHeight = [FFLabel getLableHeight:17 width:KScreenWidth-30 text:complainModel.content linespace:0];
    
    //处理单据显示状态
    NSArray *userStatusArray = KUserStatus;
    NSInteger statusIndex = [complainModel.ticketStatus integerValue];
    complainModel.ticketStatus = userStatusArray[statusIndex];
    
    
    //处理单据来源
    NSArray *typeArray = @[@"手机APP",@"IT网站",@"热线"];
    NSInteger typeIndex = [complainModel.orginalType integerValue];
    complainModel.orginalType = typeArray[typeIndex-1];
    
    return complainModel;
}

@end



