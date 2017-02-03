//
//  SeconddetailViewCell.m
//  itsmApp
//
//  Created by admin on 2016/11/30.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "SeconddetailViewCell.h"
#import "PictureTableViewCell.h"
#import "UIView+Additions.h"
#import "UIView+ViewController.h"
#import "PictureCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "GetDownLoadHandle.h"
#import "NetworkingManager.h"
#import "EMMFileManager.h"
#import "SDPhotoBrowser.h"
#import "AudioManager.h"

#define KSpace 15
#define kPictureIdentify @"pictureIdentify"

@interface SeconddetailViewCell ()<NetworkHandleDelegate,SDPhotoBrowserDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) GetDownLoadHandle *pictureLoadHandle;
@property (nonatomic,strong) GetDownLoadHandle *voiceLoadHandle;
@property (weak, nonatomic) IBOutlet UIImageView *animateImage;
@property (nonatomic,strong) UIScrollView *bigScrollView;
@property (nonatomic,assign) NSInteger index;

@end

@implementation SeconddetailViewCell{
    
    NSInteger cellCount;
    BOOL isPlay;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self createSubViews];
    
    isPlay = YES;
    
}

- (void)createSubViews
{
    self.picCollectionView.delegate = self;
    self.picCollectionView.dataSource = self;
    
    [self.picCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kPictureIdentify];
    self.picCollectionView.scrollEnabled = NO;
    CGFloat itemH = [SeconddetailViewCell pictureItem];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.picCollectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(itemH, itemH);
    flowLayout.minimumLineSpacing = KSpace;
    flowLayout.minimumInteritemSpacing = KSpace;
    [self.picCollectionView reloadData];
    self.height = [SeconddetailViewCell cellHeight:cellCount];
    
    
}

+ (CGFloat)pictureItem
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 15.0*2;
    CGFloat picWidth = (width - 4*KSpace)/5;
    
    return picWidth;
}

+ (CGFloat)cellHeight:(NSInteger)pictureCount
{
    CGFloat picWidth = (CGFloat)[SeconddetailViewCell pictureItem];
    NSInteger row = ceil((double)pictureCount/5);
    CGFloat collecttionHeight = picWidth*row + (row-1)*KSpace + 30;
    
    return collecttionHeight;
}

#pragma mark - UICollectionViewDelegateFlowLayout,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if ([_secondDetailModel.picturesURL isKindOfClass:[NSArray class]]) {
        return _secondDetailModel.picturesURL.count;
    }else{
        return 0;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kPictureIdentify forIndexPath:indexPath];
    
    //发送下载图片请求
    NSString *picPath = _smallPicArray[indexPath.row];
    [cell.picutreView sd_setImageWithURL:[NSURL URLWithString:picPath] placeholderImage:[UIImage imageNamed:@"default_header"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            cell.picutreView.image = [UIImage imageNamed:@"default_header"];
        }
        
    }];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = _smallPicArray.count;
    photoBrowser.sourceImagesContainerView = self.picCollectionView;
    
    [photoBrowser show];
    
}


- (NSString *)getAllPathWithBaseURL:(NSString *)dataPath
{
    NetworkingManager *netManager = [NetworkingManager share];
    NSString *dataURL = [NSString stringWithFormat:@"%@/%@",netManager.httpManager.internetBaseURL,dataPath];
    return dataURL;
}


-(void)setSecondDetailModel:(DetailModel *)secondDetailModel
{
    _pictureLoadHandle = [[GetDownLoadHandle alloc]init];
    _secondDetailModel = secondDetailModel;
    _smallPicArray = [NSMutableArray array];
    _bigPicArray = [NSMutableArray array];
    
    if ([_secondDetailModel.picturesURL isKindOfClass:[NSArray class]]) {
        
        for (NSDictionary *picDic in _secondDetailModel.picturesURL) {
            NSString *smallFilePath = [picDic valueForKey:@"small"];
            _pictureLoadHandle.filePath = smallFilePath;
            NSString *smallAllPath = [self getAllPathWithBaseURL:_pictureLoadHandle.dataPath];
            [_smallPicArray addObject:smallAllPath];
            NSString *bigFilePath = [picDic valueForKey:@"big"];
            _pictureLoadHandle.filePath = bigFilePath;
            NSString *bigAllPath = [self getAllPathWithBaseURL:_pictureLoadHandle.dataPath];
            [_bigPicArray addObject:bigAllPath];
        }
    }

}


#pragma mark - NetworkHandleDelegate
- (void)successed:(id)handle response:(id)response
{
    
}

- (void)failured:(id)handle error:(NSError *)error
{
    
}

#pragma mark - SDPhotoBrowserDelegate

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[self collectionView:_picCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.picutreView.image;
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = _bigPicArray[index];
    return [NSURL URLWithString:urlStr];
}






@end

