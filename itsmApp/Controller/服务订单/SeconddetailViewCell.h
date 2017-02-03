//
//  SeconddetailViewCell.h
//  itsmApp
//
//  Created by admin on 2016/11/30.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrderDetailHandle.h"
#import "VoicePlayView.h"
#import "AudioManager.h"

@interface SeconddetailViewCell : UITableViewCell<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,VoicePlayDelegate,AudioPlayDelegate>

@property (strong,nonatomic) DetailModel *secondDetailModel;
@property (weak, nonatomic) IBOutlet UICollectionView *picCollectionView;
@property (strong,nonatomic) NSMutableArray *smallPicArray;//小图
@property (strong,nonatomic) NSMutableArray *bigPicArray;//大图
@property (copy,nonatomic) NSString *voicePath;


+ (CGFloat)cellHeight:(NSInteger)pictureCount;
+ (CGFloat)pictureItem;
@end
