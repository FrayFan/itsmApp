//
//  GetFeedbackHandle.h
//  itsmApp
//
//  Created by admin on 2016/12/25.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "NetworkingManager.h"
#import "FFLabel.h"

@interface GetFeedbackHandle : BaseNetworkingHandle

@property (strong,nonatomic) NSMutableArray *myFBModels;
@end


@interface MyFeedbackModel : BaseNetworkingObject

@property (nonatomic,copy) NSString *adviceID;
@property (nonatomic,copy) NSString *userID;
@property (nonatomic,copy) NSString *serviceCatalog;
@property (nonatomic,copy) NSString *adviceContent;
@property (nonatomic,strong) NSArray *attachmentURL;
@property (nonatomic,strong) NSArray *pictureURL;
@property (nonatomic,strong) NSMutableArray *smallPics;
@property (nonatomic,strong) NSMutableArray *bigPics;
@property (nonatomic,copy) NSString *processStatus;
@property (nonatomic,copy) NSString *processContent;
@property (nonatomic,copy) NSString *createTime;

+ (MyFeedbackModel *)makeFeedbakcModel:(NSDictionary *)dict;
@property (nonatomic,assign) float contentHeight;
@property (nonatomic,assign) float proContentHeight;

@end
