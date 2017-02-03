//
//  GetProcessHandle.h
//  itsmApp
//
//  Created by admin on 2016/12/19.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BaseNetworkingHandle.h"
#import "BaseNetworkingObject.h"

@interface GetProcessHandle : BaseNetworkingHandle

@property (nonatomic,strong,readonly) NSMutableArray *processModels;
@end


@interface ProcessModel : BaseNetworkingObject

@property (nonatomic,strong) NSMutableArray *nodesModels;
@property (nonatomic,copy) NSString *receiptId;
@property (nonatomic,strong) NSArray *nodes;

+ (ProcessModel *)makeProcessModel:(NSDictionary *)dict;

@end

@interface NodesModel : BaseNetworkingObject

@property (nonatomic,copy) NSString *processTime;
@property (nonatomic,copy) NSString *processAbstract;
@property (nonatomic,copy) NSString *processDetail;

+ (NodesModel *)makeNodesModel:(NSDictionary *)dict;
@property (nonatomic,assign) float firstContentHeight;
@property (nonatomic,assign) float OtherContentHeight;

@end
