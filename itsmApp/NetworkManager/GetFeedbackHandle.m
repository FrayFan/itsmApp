//
//  GetFeedbackHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/25.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetFeedbackHandle.h"
#import "common.h"
#import "NSDictionary+NSNull.h"
#import "EMMSecurity.h"

@implementation GetFeedbackHandle

-(instancetype)init
{
    self = [super init];
    return self;
}

+ (NSString *)commandName
{
    return @"getAdviseList";
}

+ (NSString *)path
{
    return FeedbackPath;
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSArray class]]) {
        NSMutableArray<MyFeedbackModel *> *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *FBDic in obj.d) {
            NSDictionary *dataDic = [NSDictionary nullDic:FBDic];
            MyFeedbackModel *FBModel = [MyFeedbackModel makeFeedbakcModel:dataDic];
            [tempArray addObject:FBModel];
        }
        self.myFBModels = tempArray;
    }
}

@end


@implementation MyFeedbackModel

+ (MyFeedbackModel *)makeFeedbakcModel:(NSDictionary *)dict
{
    MyFeedbackModel *myFBModel = [[MyFeedbackModel alloc] init];
    myFBModel.adviceID = dict[@"AID"];
    myFBModel.userID = dict[@"UID"];
    myFBModel.serviceCatalog = dict[@"SCG"];
    myFBModel.adviceContent = dict[@"ACT"];
    myFBModel.attachmentURL= dict[@"ATTURL"];
    myFBModel.pictureURL = dict[@"PICURL"];
    myFBModel.processStatus = dict[@"PSTS"];
    myFBModel.processContent = dict[@"PSCT"];
    myFBModel.createTime = dict[@"CTM"];
    
    
    myFBModel.contentHeight = [FFLabel getLableHeight:15 width:KScreenWidth-45 text:myFBModel.adviceContent linespace:0];
    
    myFBModel.proContentHeight = [FFLabel getLableHeight:15 width:KScreenWidth-45 text:myFBModel.processContent linespace:0];
    
    //处理提单时间
    myFBModel.createTime = [myFBModel.createTime substringWithRange:NSMakeRange(0, myFBModel.createTime.length-3)];
    
    //处理反馈状态
    NSArray *status = @[@"待处理",@"处理完"];
    if ([myFBModel.processStatus isEqualToString:@"001"]) {
        myFBModel.processStatus = status[0];
    }else{
        myFBModel.processStatus = status[1];
    }
    
    //处理图片URL
    myFBModel.smallPics = [NSMutableArray array];
    myFBModel.bigPics = [NSMutableArray array];
    
    if ([myFBModel.pictureURL isKindOfClass:[NSArray class]]) {
        for (NSDictionary *picDic in myFBModel.pictureURL) {
            NSString *path = picDic[@"small"];
            NSString *smallPic = [MyFeedbackModel getAllPathWithBaseURL:path];
            [myFBModel.smallPics addObject:smallPic];
            
            NSString *tempPath = picDic[@"big"];
            NSString *bigPic = [MyFeedbackModel getAllPathWithBaseURL:tempPath];
            [myFBModel.bigPics addObject:bigPic];
        }

    }
    
    return myFBModel;
}

+ (NSString *)getAllPathWithBaseURL:(NSString *)dataPath
{
    NetworkingManager *netManager = [NetworkingManager share];
    NSString *path = [netManager.urlManager path:FileDownLoadPath];
    NSString *encodeToken = [[EMMSecurity share].token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "].invertedSet];
    NSString *encodeFilePath = [dataPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "].invertedSet];
    path = [path stringByAppendingFormat:@"?F=%@&T=%@&EU=%@",encodeFilePath,encodeToken,[EMMSecurity share].userId];
    
    NSString *dataURL = [NSString stringWithFormat:@"%@/%@",netManager.httpManager.internetBaseURL,path];
    return dataURL;
}


@end
