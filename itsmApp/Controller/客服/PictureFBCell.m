//
//  PictureFBCell.m
//  itsmApp
//
//  Created by admin on 2017/1/5.
//  Copyright © 2017年 itp. All rights reserved.
//

#import "PictureFBCell.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"

#define KSpace 15

@interface PictureFBCell ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
@implementation PictureFBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createSubViews];
}

- (void)createSubViews
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PICTURECELL"];
    self.collectionView.scrollEnabled = NO;
    CGFloat itemH = [PictureFBCell pictureItem];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(itemH, itemH);
    flowLayout.minimumLineSpacing = KSpace;
    flowLayout.minimumInteritemSpacing = KSpace;
    [self.collectionView reloadData];
    
}

+ (CGFloat)pictureItem
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 15.0*2;
    CGFloat picWidth = (width - 2*KSpace)/3;
    
    return picWidth;
}

+ (CGFloat)cellHeight:(NSInteger)pictureCount
{
    CGFloat picWidth = (CGFloat)[PictureFBCell pictureItem];
    CGFloat height = 85;
    height += picWidth;
    return height;
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_myFBModel.pictureURL isKindOfClass:[NSArray class]]) {
        return _myFBModel.pictureURL.count;
    }else{
        return 0;
    }
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PICTURECELL" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    imageView.tag = 333;
    [cell addSubview:imageView];
    //发送下载图片请求
    NSString *picPath = _myFBModel.smallPics[indexPath.row];
    [imageView sd_setImageWithURL:[NSURL URLWithString:picPath] placeholderImage:[UIImage imageNamed:@"default_header"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) {
            imageView.image = [UIImage imageNamed:@"default_header"];
        }
    }];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = _myFBModel.smallPics.count;
    photoBrowser.sourceImagesContainerView = _collectionView;
    
    [photoBrowser show];
    
}


#pragma mark - SDPhotoBrowserDelegate

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[self collectionView:_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    UIImageView *imageView = [cell viewWithTag:333];
    return imageView.image;
}


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = _myFBModel.bigPics[index];
    return [NSURL URLWithString:urlStr];}




-(void)setMyFBModel:(MyFeedbackModel *)myFBModel
{
    _myFBModel = myFBModel;
}

@end
