//
//  FileUploadHandle.m
//  itsmApp
//
//  Created by itp on 2016/12/16.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "FileUploadHandle.h"
#import "NetworkingManager.h"
#import "EMMSecurity.h"

//@interface PictureObject : BaseNetworkingObject
//@property (nonatomic,copy)NSString *bigImageURL;
//@property (nonatomic,copy)NSString *smallImageURL;
//@end

@interface FileUploadHandle ()
@property (nonatomic,copy)NSDictionary *resultDict;
@end

@implementation FileUploadHandle

+ (NSString *)path
{
    return UploadPath;
}

- (NSURLRequest *)customRequest
{
    NetworkingManager *networkingManager = [self networkingManager];
    NSString *path = [networkingManager.urlManager path:[[self class] path]];
    NSString *encodeToken = [[EMMSecurity share].token stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "].invertedSet];
    path = [path stringByAppendingFormat:@"?T=%@&EU=%@",encodeToken,[EMMSecurity share].userId];
    if (self.type == 2) {
        path = [path stringByAppendingString:@"&C=2"];
    }
    __weak typeof(self) weakSelf = self;
    NSMutableURLRequest *request = [networkingManager.httpManager multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<EMMMultipartFormData> formData) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            NSData *data = [NSData dataWithContentsOfFile:strongSelf.zipFilePath];
            [formData appendPartWithFileData:data name:@"attachFile" fileName:[strongSelf.zipFilePath lastPathComponent] mimeType:[strongSelf.zipFilePath pathExtension]];
        }
    }];
    
    
    return request;
}

- (void)willHandleSuccessedResponse:(id)response
{
    ResponseObject *obj = response;
    if ([obj.d isKindOfClass:[NSDictionary class]]) {
        self.resultDict = obj.d;
    }
}

@end

//@interface ReceiptObject : BaseNetworkingObject
//@property (nonatomic,copy)NSString *receiptId;
//@property (nonatomic,copy)NSArray *pictures;
//@property (nonatomic,copy)NSString *voiURL;
//@property (nonatomic,copy)NSString *attURL;
//@end
//
//@implementation ReceiptObject
//
//- (id)initWithDictionary:(NSDictionary *)dict
//{
//    self = [super initWithDictionary:dict];
//    if (self) {
//        _receiptId = dict[@"RID"];
//        NSArray *pics = dict[@"PICURL"];
//        if ([pics isKindOfClass:[NSArray class]] && pics.count > 0) {
//            NSMutableArray *temp = [[NSMutableArray alloc] init];
//            [pics enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                PictureObject *pic = [[PictureObject alloc] initWithDictionary:obj];
//                [temp addObject:pic];
//            }];
//            _pictures = [NSArray arrayWithArray:temp];
//        }
//        _voiURL = dict[@"VOIURL"];
//        _attURL = dict[@"ATTURL"];
//    }
//    return self;
//}
//
//- (NSDictionary *)networkingDictionary
//{
//    return @{@"RID":self.receiptId ?:@"",
//             @"PICURL":[self.pictures networkingArray] ?:NULLObject,
//             @"VOIURL":self.voiURL ?:@"",
//             @"ATTURL":self.attURL ?:@""};
//}
//
//@end
//
//
//@implementation PictureObject
//
//- (id)initWithDictionary:(NSDictionary *)dict
//{
//    self = [super initWithDictionary:dict];
//    if (self) {
//        _smallImageURL = dict[@"small"];
//        _bigImageURL = dict[@"big"];
//    }
//    return self;
//}
//
//- (NSDictionary *)networkingDictionary
//{
//    return @{@"small":self.smallImageURL ?:@"",
//             @"big":self.bigImageURL ?:@""};
//}
//
//@end

