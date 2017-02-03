//
//  GetOrderDetailHandle.h
//  itsmApp
//
//  Created by admin on 2016/12/20.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"
#import "NetworkingManager.h"

@interface GetOrderDetailHandle : BaseNetworkingHandle

@property (nonatomic,strong) NSMutableArray *detailModels;

@end

@class DetEngineerModel;
@interface DetailModel : BaseNetworkingObject

@property (nonatomic,copy) NSString *receiptId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userPhone;
@property (nonatomic,copy) NSString *userDept;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSArray *picturesURL;
@property (nonatomic,strong) NSArray *voidceURL;
@property (nonatomic,strong) NSArray *attachmentURL;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *subscribeTime;
@property (nonatomic,copy) NSString *isVip;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *orginalType;
@property (nonatomic,copy) NSString *evaluateStatus;
@property (nonatomic,copy) NSString *ticketStatus;
@property (nonatomic,strong) DetEngineerModel *engineerModel;
@property (nonatomic,copy) NSString *engineerSolution;
@property (nonatomic,copy) NSString *currentStage;
@property (nonatomic,copy) NSString *nextStage;
@property (nonatomic,copy) NSString *category1;
@property (nonatomic,copy) NSString *category2;
@property (nonatomic,copy) NSString *category3;
@property (nonatomic,copy) NSString *voiceDuration;

@property (nonatomic,copy) NSString *identity;
@property (nonatomic,assign) float contentHeight;
@property (nonatomic,assign) float locationWidth;
+ (DetailModel *)makeDetailModel:(NSDictionary *)dict;

@end

@interface DetEngineerModel : BaseNetworkingHandle

@property (nonatomic,copy) NSString *engineerName;
@property (nonatomic,copy) NSString *engineerID;
@property (nonatomic,copy) NSString *engineerPhone;
@property (nonatomic,copy) NSString *engineerDept;
@property (nonatomic,copy) NSString *engineerHeadImg;
@property (nonatomic,strong) NSArray *engineerSkill;
@property (nonatomic,copy) NSString *skill;

+ (DetEngineerModel *)makeEngineerModel:(NSMutableDictionary *)dict;
@end


