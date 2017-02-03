//
//  GetEvaluateHandle.h
//  itsmApp
//
//  Created by admin on 2016/12/20.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"
#import "NetworkingManager.h"
#import "common.h"

@interface GetEvaluateHandle : BaseNetworkingHandle

@property (nonatomic,strong) NSArray *evaluteModels;
@end


@interface EvaluateModel : BaseNetworkingObject

@property (nonatomic,copy) NSString *rank;
@property (nonatomic,copy) NSString *abstract;
@property (nonatomic,strong) NSArray *catalogs;

+ (EvaluateModel *)makeEvaluateModel:(NSDictionary *)dict;

@end
