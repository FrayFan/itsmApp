//
//  GetComProcessHandle.h
//  itsmApp
//
//  Created by admin on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"
#import "NetworkingManager.h"
#import "FFLabel.h"
#import "common.h"

@interface GetComProcessHandle : BaseNetworkingHandle

@property (nonatomic,strong) NSMutableArray *comProcessModels;
@end


@interface ComProcessModel : BaseNetworkingObject

@property (nonatomic,copy) NSString *complainID;
@property (nonatomic,copy) NSString *complainStatus;
@property (nonatomic,copy) NSString *complainUserId;
@property (nonatomic,copy) NSString *complainProcessUserId;
@property (nonatomic,copy) NSString *beComplainedUserId;
@property (nonatomic,copy) NSString *complainContent;
@property (nonatomic,copy) NSString *complainProcessContent;
@property (nonatomic,copy) NSString *receiptId;

+ (ComProcessModel *)makecomplainModel:(NSDictionary *)dict;
@property (nonatomic,assign) float complainHeight;
@property (nonatomic,assign) float beComplainHeight;


@end
