//
//  FeedbackImageManager.m
//  itsmApp
//
//  Created by itp on 2017/1/3.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "FeedbackImageManager.h"
#import <UIKit/UIKit.h>
#import "ZipArchive.h"

#define kFeedbackDirectoryName @"Feedback"

@implementation FeedbackImageManager

+ (NSString *)feedbackFileDirectory
{
    static NSString *directory = nil;
    if ([directory length] == 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *basePath = paths.firstObject;
        directory = [basePath stringByAppendingPathComponent:kFeedbackDirectoryName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:directory]) {
            NSError *error = nil;
            [fileManager createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:&error];
            if (error) {
                NSLog(@"createDirectoryAtPath:%@ Error:%@",directory,error);
                return nil;
            }
        }
    }
    return directory;
}

+ (NSString *)baseDirectoryWithName:(NSString *)name
{
    NSString *baseDirectory = [self feedbackFileDirectory];
    NSString *path = [baseDirectory stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"createDirectoryAtPath:%@ Error:%@",path,error);
            return nil;
        }
    }
    return path;
}

+ (NSString *)pictureDirectory
{
    return [self baseDirectoryWithName:@"picture"];
}

+ (void)cleanDirectory:(NSString *)directory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:directory];
    NSString *file;
    while ((file = [dirEnum nextObject])) {
        NSError *error = nil;
        [fileManager removeItemAtPath:[directory stringByAppendingPathComponent:file] error:&error];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }
}

+ (NSString *)archiveFeedbackWithPics:(NSArray *)pics
{
    if (pics.count == 0) {
        return nil;
    }
    NSString *feedbackFileDirectory = [self feedbackFileDirectory];
    NSString *zipFilePath = [[feedbackFileDirectory stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"feedback.zip"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:zipFilePath]) {
        [fileManager removeItemAtPath:zipFilePath error:nil];
    }
    
    NSString *pictureDirectory = [self pictureDirectory];
    [self cleanDirectory:pictureDirectory];
    
    [pics enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *fileName = [NSString stringWithFormat:@"%lu.jpg",idx+1];
        NSString *imagePath = [pictureDirectory stringByAppendingPathComponent:fileName];
        [UIImageJPEGRepresentation(obj,0.5) writeToFile:imagePath atomically:YES];
        
    }];
    
    BOOL success = [SSZipArchive createZipFileAtPath:zipFilePath withContentsOfDirectory:feedbackFileDirectory];
    return success ? zipFilePath:nil;
}

@end
