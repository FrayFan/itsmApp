//
//  GetProcessHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/19.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetProcessHandle.h"
#import "NetworkingManager.h"
#import "NSDictionary+NSNull.h"
#import "FFLabel.h"
#import "common.h"

@interface GetProcessHandle ()

@end

@implementation GetProcessHandle

-(instancetype)init
{
    self = [super init];
    [self.requestObj.d addEntriesFromDictionary:[[self class] data]];
    
    return self;
}


+ (NSString *)commandName
{
    return @"getReceiptProcessList";
}

+ (NSString *)path
{
    return BaseDataPath;
}

+ (NSDictionary *)data
{
    return @{@"RK":@"",@"RID":@""};
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    
    if ([obj.d isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *dataDic = [NSDictionary nullDic:obj.d];
        ProcessModel *processModel = [ProcessModel makeProcessModel:dataDic];
        _processModels = [NSMutableArray arrayWithObject:processModel];

        
    }
}

@end


@implementation ProcessModel

+ (ProcessModel *)makeProcessModel:(NSDictionary *)dict
{
    ProcessModel *processModel = [[ProcessModel alloc] init];
    processModel.receiptId = dict[@"RID"];
    processModel.nodes = dict[@"NDS"];
    
    if (processModel.nodes.lastObject) {
        
        NSMutableArray *nodesArray = [NSMutableArray array];
        for (NSDictionary *nodeDic in processModel.nodes) {
            
            NodesModel *nodeModel = [NodesModel makeNodesModel:nodeDic];
            [nodesArray addObject:nodeModel];
        }
        processModel.nodesModels = nodesArray;
        
    }
    return processModel;
}

@end

@implementation NodesModel

+ (NodesModel *)makeNodesModel:(NSDictionary *)dict
{
    NodesModel *nodeModel = [[NodesModel alloc] init];
    nodeModel.processTime = dict[@"PTM"];
    nodeModel.processAbstract = dict[@"PABS"];
    nodeModel.processDetail = dict[@"PDTL"];
    
    //处理提单时间、预约时间
    nodeModel.processTime = [nodeModel.processTime substringWithRange:NSMakeRange(0, nodeModel.processTime.length-3)];
 
    //第一行内容高度
    nodeModel.firstContentHeight = [FFLabel getLableHeight:17 width:KScreenWidth-60 text:nodeModel.processAbstract linespace:0];
    
    //其他行内容高度
    nodeModel.OtherContentHeight = [FFLabel getLableHeight:15 width:KScreenWidth-60 text:nodeModel.processAbstract linespace:0];
    
    return nodeModel;
}




@end
