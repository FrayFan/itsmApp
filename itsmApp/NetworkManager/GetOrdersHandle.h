//
//  GetOrdersHandle.h
//  itsmApp
//
//  Created by admin on 2016/12/18.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"
#import "NetworkingManager.h"
#import "common.h"

@interface GetOrdersHandle : BaseNetworkingHandle

@property (nonatomic,strong) NSMutableArray *orderModels;
@end

@class EngineerModel;
@interface OrdersModel : BaseNetworkingObject

@property (nonatomic,copy) NSString *receiptId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userPhone;
@property (nonatomic,copy) NSString *userDept;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *picturesURL;
@property (nonatomic,copy) NSString *voidceURL;
@property (nonatomic,copy) NSString *attachmentURL;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *subscribeTime;
@property (nonatomic,copy) NSString *complainTime;
@property (nonatomic,copy) NSString *isVip;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *orginalType;
@property (nonatomic,assign) float orginalTypeWidth;
@property (nonatomic,copy) NSString *evaluateStatus;
@property (nonatomic,copy) NSString *ticketStatus;
@property (nonatomic,strong) EngineerModel *engineerModel;
@property (nonatomic,copy) NSString *currentStage;
@property (nonatomic,copy) NSString *nextStage;
@property (nonatomic,copy) NSString *category1;
@property (nonatomic,copy) NSString *category2;

@property (nonatomic,assign) NSNumber *isAccepted;
@property (nonatomic,copy) NSString *identity;
@property (nonatomic,assign) float contentHeight;
+ (OrdersModel *)makeOrdersModel:(NSMutableDictionary *)dict;


@end

@interface EngineerModel : BaseNetworkingHandle

@property (nonatomic,copy) NSString *engineerName;
@property (nonatomic,copy) NSString *engineerID;
@property (nonatomic,copy) NSString *engineerPhone;
@property (nonatomic,copy) NSString *engineerDept;
@property (nonatomic,copy) NSString *engineerHeadImg;
@property (nonatomic,strong) NSArray *engineerSkill;
@property (nonatomic,copy) NSString *skill;

+ (EngineerModel *)makeEngineerModel:(NSMutableDictionary *)dict;
@end



