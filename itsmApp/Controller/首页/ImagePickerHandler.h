//
//  ImagePickerHandler.h
//  itsmApp
//
//  Created by itp on 2016/11/28.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ImagePickerHandler;

@protocol ImagePickerHandlerDelegate <NSObject>

@optional

- (void)didFinishImagePickerHandler:(ImagePickerHandler *)handle;

@end

@interface ImagePickerHandler : NSObject
@property (weak,nonatomic)UIViewController<ImagePickerHandlerDelegate> *viewController;
@property (assign,nonatomic)NSInteger maxImages;
@property (assign,nonatomic)NSInteger columnNumber;
@property (strong, nonatomic) NSMutableArray *pictureArray;
@property (strong, nonatomic) NSMutableArray *assetArray;

- (void)pushImagePickerController;

- (void)takePhoto;

- (void)previewPictureAtIndex:(NSInteger)index;

@end
