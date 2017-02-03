//
//  GetComplainListHandle.h
//  itsmApp
//
//  Created by admin on 2017/1/6.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"
#import "NetworkingManager.h"
#import "NSDictionary+NSNull.h"
#import "EMMSecurity.h"
#import "FFLabel.h"
#import "common.h"

@interface GetComplainListHandle : BaseNetworkingHandle

@property (nonatomic,strong) NSMutableArray *orderModels;
@end

@class ComEngineerModel;
@interface ComplainListModel : BaseNetworkingObject

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
@property (nonatomic,copy) NSString *isVip;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *orginalType;
@property (nonatomic,copy) NSString *evaluateStatus;
@property (nonatomic,copy) NSString *ticketStatus;
@property (nonatomic,strong) ComEngineerModel *engineerModel;
@property (nonatomic,copy) NSString *currentStage;
@property (nonatomic,copy) NSString *nextStage;
@property (nonatomic,copy) NSString *category1;
@property (nonatomic,copy) NSString *category2;

@property (nonatomic,assign) NSNumber *isAccepted;
@property (nonatomic,copy) NSString *identity;
@property (nonatomic,assign) float contentHeight;
+ (ComplainListModel *)makeOrdersModel:(NSMutableDictionary *)dict;


@end

@interface ComEngineerModel : BaseNetworkingHandle

@property (nonatomic,copy) NSString *engineerName;
@property (nonatomic,copy) NSString *engineerID;
@property (nonatomic,copy) NSString *engineerPhone;
@property (nonatomic,copy) NSString *engineerDept;
@property (nonatomic,copy) NSString *engineerHeadImg;
@property (nonatomic,strong) NSArray *engineerSkill;

+ (ComEngineerModel *)makeEngineerModel:(NSMutableDictionary *)dict;
@end
