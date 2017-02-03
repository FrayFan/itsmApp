//
//  GetOrderDetailHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/20.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetOrderDetailHandle.h"
#import "NSDictionary+NSNull.h"
#import "FFLabel.h"
#import "common.h"

@interface GetOrderDetailHandle ()

@end

@implementation GetOrderDetailHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"getServiceReceipt";
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
    ResponseObject *obj = response;
    NSDictionary *dataDic = [NSDictionary nullDic:obj.d];
    [dataDic  setValue:self.requestObj.d[@"RK"] forKey:@"RL"];//添加角色
    DetailModel *detailModel = [DetailModel makeDetailModel:dataDic];
    _detailModels = [NSMutableArray arrayWithObject:detailModel];
    
}


@end



@implementation DetailModel

+ (DetailModel *)makeDetailModel:(NSDictionary *)dict
{
    DetailModel *detailModel = [[DetailModel alloc] init];
    detailModel.receiptId = dict[@"RID"];
    detailModel.userId = dict[@"UID"];
    detailModel.userName = dict[@"UNM"];
    detailModel.userPhone = dict[@"UP"];
    detailModel.userDept = dict[@"UDPT"];
    detailModel.createTime = dict[@"CTM"];
    detailModel.content = dict[@"CT"];
    detailModel.picturesURL = dict[@"PICURL"];
    detailModel.voidceURL = dict[@"VOIURL"];
    detailModel.attachmentURL = dict[@"ATTURL"];
    detailModel.type = dict[@"TY"];
    detailModel.subscribeTime = dict[@"SUBTM"];
    detailModel.isVip = dict[@"ISVIP"];
    detailModel.location = dict[@"LT"];
    detailModel.orginalType = dict[@"OT"];
    detailModel.evaluateStatus = dict[@"EVS"];
    detailModel.ticketStatus = dict[@"TS"];
    detailModel.engineerModel = [DetEngineerModel makeEngineerModel:dict[@"EVO"]];
    detailModel.engineerSolution = dict[@"ESLN"];
    detailModel.currentStage = dict[@"CS"];
    detailModel.nextStage = dict[@"NS"];
    detailModel.category1 = dict[@"C1"];
    detailModel.category2 = dict[@"C2"];
    detailModel.category3 = dict[@"C3"];
    detailModel.identity = dict[@"RL"];
    detailModel.voiceDuration = dict[@"VD"];
    
    
    //根据页面显示处理model
    //处理提单时间、预约时间
    detailModel.createTime = [detailModel.createTime substringWithRange:NSMakeRange(0, detailModel.createTime.length-3)];
    if (detailModel.subscribeTime.length>0) {
        detailModel.subscribeTime = [detailModel.subscribeTime substringWithRange:NSMakeRange(0, detailModel.subscribeTime.length-3)];
    }
    
    //计算定位信息宽度
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:13]};
    CGSize size = [detailModel.location sizeWithAttributes:attrs];
    detailModel.locationWidth = size.width;
    
    //单据内容高度
    detailModel.contentHeight = [FFLabel getLableHeight:17 width:KScreenWidth-31 text:detailModel.content linespace:0];
    
    //处理单据显示状态
    if ([detailModel.identity isEqualToString:@"01"]) {
        NSArray *userStatusArray = KUserStatus;
        NSInteger statusIndex = [detailModel.ticketStatus integerValue];
        detailModel.ticketStatus = userStatusArray[statusIndex];
        
    }else{
        NSArray *userStatusArray = KEngineerStatus;
        NSInteger statusIndex = [detailModel.ticketStatus integerValue];
        detailModel.ticketStatus = userStatusArray[statusIndex];
    }

    //处理单据来源
    NSArray *typeArray = @[@"手机APP",@"IT网站",@"热线"];
    NSInteger typeIndex = [detailModel.orginalType integerValue];
    detailModel.orginalType = typeArray[typeIndex-1];
    
    return detailModel;
}

@end

@implementation DetEngineerModel


+ (DetEngineerModel *)makeEngineerModel:(NSMutableDictionary *)dict
{
    DetEngineerModel *engineerModel = [[DetEngineerModel alloc]init];
    if (![dict isEqual:@""]) {
        engineerModel.engineerName = dict[@"EN"];
        engineerModel.engineerID = dict[@"EID"];
        engineerModel.engineerPhone = dict[@"EP"];
        engineerModel.engineerDept = dict[@"EDPT"];
        engineerModel.engineerHeadImg = dict[@"EIMG"];
        engineerModel.engineerSkill = dict[@"EK"];
        
        //处理技能标签
        if ([engineerModel.engineerSkill isKindOfClass:[NSArray class]]) {
            NSMutableArray *stringArray = [[NSMutableArray alloc]init];
            for (NSDictionary *skillDic in engineerModel.engineerSkill) {
                NSString *skill = skillDic[@"CTNM"];
                [stringArray addObject:skill];
            }
            
            engineerModel.skill = [stringArray componentsJoinedByString:@"   "];
            engineerModel.skill = [engineerModel.skill stringByAppendingString:@"  "];
        }
    
    }
    
    return engineerModel;
}

@end
