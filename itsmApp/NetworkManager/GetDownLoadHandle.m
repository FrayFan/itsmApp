//
//  GetDownLoadHandle.m
//  itsmApp
//
//  Created by admin on 2016/12/26.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "GetDownLoadHandle.h"
#import "NetworkingManager.h"
#import "EMMSecurity.h"

@implementation GetDownLoadHandle


- (instancetype)init{
    self = [super init];
    if (self) {
 
    }
    return self;
}

-(void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    
    NetworkingManager *networkingManager = [self networkingManager];
    NSString *path = [networkingManager.urlManager path:FileDownLoadPath];
    NSString *encodeToken = [[EMMSecurity share].token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "].invertedSet];
    NSString *encodeFilePath = [_filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "].invertedSet];
    path = [path stringByAppendingFormat:@"?F=%@&T=%@&EU=%@",encodeFilePath,encodeToken,[EMMSecurity share].userId];

    _dataPath = path;
    
}


- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSDictionary class]]) {
//        self.receiptDict = obj.d;
    }
}


@end
