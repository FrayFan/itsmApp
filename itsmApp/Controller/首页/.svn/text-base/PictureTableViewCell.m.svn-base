//
//  PictureTableViewCell.m
//  itsmApp
//
//  Created by itp on 2016/11/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "PictureTableViewCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+Layout.h"
#import "PictureCollectionViewCell.h"
#import "UIView+ViewController.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"




#define kPictureIdentify @"pictureIdentify"

#define kMargin     15
#define kMaxImageNum   9

@interface PictureTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate>

@property (assign, nonatomic)BOOL editPictureCollection;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@end

@implementation PictureTableViewCell

+ (NSInteger)columnCount
{
    return 5;
}

+ (CGFloat)pictureItemWidth
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 15.0*2;
    NSInteger columnCount = [PictureTableViewCell columnCount];
    CGFloat wh = (width - (columnCount - 1) * kMargin) / columnCount;
    return wh;
}

+ (CGFloat)cellHeight:(NSInteger)pictureCount
{
    NSInteger cellCount = pictureCount + 1;
    CGFloat itemHeight = [PictureTableViewCell pictureItemWidth];
    NSInteger count = [PictureTableViewCell columnCount];
    NSInteger row = ceil((double)cellCount/(double)count);
    CGFloat collectionHeight = itemHeight*row + (row-1)*kMargin;
    CGFloat height = 12.0 + 21.0 + 4.0 + 12.0;
    height += collectionHeight;
    return height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.pictureCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kPictureIdentify];
    CGFloat itemWH = [PictureTableViewCell pictureItemWidth];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.pictureCollectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    flowLayout.minimumLineSpacing = kMargin;
    flowLayout.minimumInteritemSpacing = kMargin;
    [self.pictureCollectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImagePickerHandler:(ImagePickerHandler *)imagePickerHandler
{
    _imagePickerHandler = imagePickerHandler;
    [self.pictureCollectionView reloadData];
}

#pragma mark UICollectionViewDelegate

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewController.view endEditing:YES];
    if (indexPath.row < self.imagePickerHandler.pictureArray.count) {
        [self.imagePickerHandler previewPictureAtIndex:indexPath.row];
    }
    else if (indexPath.row == self.imagePickerHandler.pictureArray.count) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
#pragma clang diagnostic pop
        [sheet showInView:self.viewController.view];
    }
    
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(self.imagePickerHandler.pictureArray.count+1, kMaxImageNum);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPictureIdentify forIndexPath:indexPath];
    if(indexPath.row < self.imagePickerHandler.pictureArray.count)
    {
        cell.picutreView.image = self.imagePickerHandler.pictureArray[indexPath.row];
    }
    else if (indexPath.row == self.imagePickerHandler.pictureArray.count) {
        cell.picutreView.image = [UIImage imageNamed:@"add_picture"];
    }
    
    return cell;
}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        [self.imagePickerHandler takePhoto];
    } else if (buttonIndex == 1) {
        [self.imagePickerHandler pushImagePickerController];
    }
}

@end
