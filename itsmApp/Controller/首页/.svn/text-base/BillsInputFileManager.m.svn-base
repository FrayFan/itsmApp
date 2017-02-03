//
//  BillsInputFileManager.m
//  itsmApp
//
//  Created by itp on 2016/12/19.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "BillsInputFileManager.h"
#import <UIKit/UIKit.h>
#import "ZipArchive.h"

#define kBillsDirectoryName @"BillsInput"

@implementation BillsInputFileManager

+ (NSString *)billsInputFileDirectory
{
    static NSString *directory = nil;
    if ([directory length] == 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *basePath = paths.firstObject;
        directory = [basePath stringByAppendingPathComponent:kBillsDirectoryName];
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
    NSString *baseDirectory = [self billsInputFileDirectory];
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
    return [self baseDirectoryWithName:@"pics"];
}

+ (NSString *)picturesDirectoryWithOriginal:(BOOL)original
{
    NSString *baseDirectory = [self pictureDirectory];
    NSString *path = nil;
    if (original) {
        path = [baseDirectory stringByAppendingPathComponent:@"big"];
    }
    else
    {
        path = [baseDirectory stringByAppendingPathComponent:@"small"];
    }
    
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

+ (NSString *)audiosDirectory
{
    return [self baseDirectoryWithName:@"audios"];
}

+ (NSString *)otherFileDirectory
{
    return [self baseDirectoryWithName:@"files"];
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
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

+ (NSString *)archiveBillsWithPics:(NSArray *)pics audiosPath:(NSString *)audiosPath otherFile:(NSString *)otherFile
{
    NSString *billsInputFileDirectory = [self billsInputFileDirectory];
    NSString *zipFilePath = [[billsInputFileDirectory stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"bills.zip"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:zipFilePath]) {
        [fileManager removeItemAtPath:zipFilePath error:nil];
    }

    NSString *smallDirectory = [self picturesDirectoryWithOriginal:NO];
    [self cleanDirectory:smallDirectory];
    NSString *bigDirectory = [self picturesDirectoryWithOriginal:YES];
    [self cleanDirectory:bigDirectory];
    
    if (pics.count > 0) {

        [pics enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIImage *smallImage = [self scaleImage:obj toSize:CGSizeMake(80.0, 80.0)];
            NSString *fileName = [NSString stringWithFormat:@"%lu.jpg",idx+1];
            NSString *smallImagePath = [smallDirectory stringByAppendingPathComponent:fileName];
            [UIImageJPEGRepresentation(smallImage,1.0) writeToFile:smallImagePath atomically:YES];
            NSString *bigImagePath = [bigDirectory stringByAppendingPathComponent:fileName];
            [UIImageJPEGRepresentation(obj,0.5) writeToFile:bigImagePath atomically:YES];
            
        }];
    }
    
    NSString *audiosDirctory = [self audiosDirectory];
    
    [self cleanDirectory:audiosDirctory];
    
    if ([audiosPath length] > 0 && [fileManager fileExistsAtPath:audiosPath]) {

        NSString *targetPath = [audiosDirctory stringByAppendingPathComponent:[audiosPath lastPathComponent]];
        NSError *error = nil;
        if(![fileManager copyItemAtPath:audiosPath toPath:targetPath error:&error])
        {
            NSLog(@"copyItemAtPath:%@ toPath:%@ error:%@",audiosPath,targetPath,error);
        }
    }

    NSString *otherFileDirectory = [self otherFileDirectory];
    
    [self cleanDirectory:otherFileDirectory];
    
    if ([otherFile length] > 0 && [fileManager fileExistsAtPath:otherFile]) {

        NSString *targetPath = [otherFileDirectory stringByAppendingPathComponent:[audiosPath lastPathComponent]];
        NSError *error = nil;
        if(![fileManager copyItemAtPath:otherFile toPath:targetPath error:&error])
        {
            NSLog(@"copyItemAtPath:%@ toPath:%@ error:%@",otherFile,targetPath,error);
        }
    }
    
    BOOL success = [SSZipArchive createZipFileAtPath:zipFilePath withContentsOfDirectory:billsInputFileDirectory];
    return success ? zipFilePath:nil;
}


@end
