//
//  GetComplainListHandle.m
//  itsmApp
//
//  Created by admin on 2017/1/6.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "GetComplainListHandle.h"

@implementation GetComplainListHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}

+ (NSString *)commandName
{
    return @"getCanComplainServiceReceipt";
}

+ (NSString *)path
{
    return ComplainPath;
}

+ (NSDictionary *)data
{
    return @{@"RK":@"01",@"TS":@"00"};
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSArray class]]) {
        NSMutableArray<ComplainListModel *> *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *orderDic in obj.d) {
            NSDictionary *dataDic = [NSDictionary nullDic:orderDic];
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
            [tempDic  setValue:self.requestObj.d[@"RK"] forKey:@"RL"];//添加角色
            //判断是否已接单
            if ([[tempDic objectForKey:@"EVO"] isKindOfClass:[NSDictionary class]]) {
                [tempDic setObject:@(1) forKey:@"ISAPT"];
            }else{
                [tempDic setObject:@(0) forKey:@"ISAPT"];
            }
            
            ComplainListModel *orderModel = [ComplainListModel makeOrdersModel:tempDic];
            [tempArray addObject:orderModel];
        }
        self.orderModels = [NSMutableArray arrayWithArray:tempArray];
    }
    
}

@end

@implementation ComplainListModel

+ (ComplainListModel *)makeOrdersModel:(NSMutableDictionary *)dict
{
    ComplainListModel *ordersModel = [[ComplainListModel alloc] init];
    ordersModel.receiptId = dict[@"RID"];
    ordersModel.userId = dict[@"UID"];
    ordersModel.userName = dict[@"UNM"];
    ordersModel.userPhone = dict[@"UP"];
    ordersModel.userDept = dict[@"UDPT"];
    ordersModel.createTime = dict[@"CTM"];
    ordersModel.content = dict[@"CT"];
    ordersModel.picturesURL = dict[@"PICURL"];
    ordersModel.voidceURL = dict[@"VOIURL"];
    ordersModel.attachmentURL = dict[@"ATTURL"];
    ordersModel.type = dict[@"TY"];
    ordersModel.subscribeTime = dict[@"SUBTM"];
    ordersModel.isVip = dict[@"ISVIP"];
    ordersModel.location = dict[@"LT"];
    ordersModel.orginalType = dict[@"OT"];
    ordersModel.evaluateStatus = dict[@"EVS"];
    ordersModel.ticketStatus = dict[@"TS"];
    ordersModel.engineerModel = [ComEngineerModel makeEngineerModel:dict[@"EVO"]];
    ordersModel.currentStage = dict[@"CS"];
    ordersModel.nextStage = dict[@"NS"];
    ordersModel.category1 = dict[@"C1"];
    ordersModel.category2 = dict[@"C2"];
    ordersModel.identity = dict[@"RL"];
    ordersModel.isAccepted = dict[@"ISAPT"];
    
    //根据页面显示处理model
    //处理提单时间、预约时间
    ordersModel.createTime = [ordersModel.createTime substringWithRange:NSMakeRange(0, ordersModel.createTime.length-3)];
    if (ordersModel.subscribeTime.length>0) {
        ordersModel.subscribeTime = [ordersModel.subscribeTime substringWithRange:NSMakeRange(0, ordersModel.subscribeTime.length-3)];
    }

    //单据内容高度
    ordersModel.contentHeight = [FFLabel getLableHeight:17 width:KScreenWidth-30 text:ordersModel.content linespace:0];
    
    //处理单据来源
    NSArray *typeArray = @[@"手机APP",@"IT网站",@"热线"];
    NSInteger typeIndex = [ordersModel.orginalType integerValue];
    ordersModel.orginalType = typeArray[typeIndex-1];
    
    //处理单据显示状态
    if ([ordersModel.identity isEqualToString:@"01"]) {
        NSArray *userStatusArray = KUserStatus;
        NSInteger statusIndex = [ordersModel.ticketStatus integerValue];
        ordersModel.ticketStatus = userStatusArray[statusIndex];
        
    }else{
        NSArray *userStatusArray = KEngineerStatus;
        NSInteger statusIndex = [ordersModel.ticketStatus integerValue];
        ordersModel.ticketStatus = userStatusArray[statusIndex];
    }
    
    
    return ordersModel;
}

@end


@implementation ComEngineerModel


+ (ComEngineerModel *)makeEngineerModel:(NSMutableDictionary *)dict
{
    ComEngineerModel *engineerModel = [[ComEngineerModel alloc]init];
    if (![dict isEqual:@""]) {
        engineerModel.engineerName = dict[@"EN"];
        engineerModel.engineerID = dict[@"EID"];
        engineerModel.engineerPhone = dict[@"EP"];
        engineerModel.engineerDept = dict[@"EDPT"];
        engineerModel.engineerHeadImg = dict[@"EIMG"];
        engineerModel.engineerSkill = dict[@"EK"];
        
        //处理头像图片URL
        engineerModel.engineerHeadImg = [ComEngineerModel getAllPathWithBaseURL:engineerModel.engineerHeadImg];
        
        //处理技能标签
        if ([engineerModel.engineerSkill isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *skillDic in engineerModel.engineerSkill) {
                NSString *skill = skillDic[@"CTNM"];
                [tempArray addObject:skill];
            }
            engineerModel.engineerSkill = tempArray;

        }
        
    }
    
    
    return engineerModel;
}

+ (NSString *)getAllPathWithBaseURL:(NSString *)dataPath
{
    NetworkingManager *netManager = [NetworkingManager share];
    NSString *path = [netManager.urlManager path:FileDownLoadPath];
    NSString *encodeToken = [[EMMSecurity share].token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "].invertedSet];
    NSString *encodeFilePath = [dataPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "].invertedSet];
    path = [path stringByAppendingFormat:@"?F=%@&T=%@&EU=%@",encodeFilePath,encodeToken,[EMMSecurity share].userId];
    
    NSString *dataURL = [NSString stringWithFormat:@"%@/%@",netManager.httpManager.internetBaseURL,dataPath];
    return dataURL;
}

@end
