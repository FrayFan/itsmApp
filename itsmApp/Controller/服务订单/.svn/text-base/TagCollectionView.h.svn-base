//
//  TagCollectionView.h
//  itsmApp
//
//  Created by admin on 2016/11/24.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagCollectionViewDelegate <NSObject>

@optional
- (void)addWarningPromptView;

@end

@interface TagCollectionView : UICollectionView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,weak) id<TagCollectionViewDelegate>warningDelegate;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSMutableDictionary *cellSelectedDic;//单元格选中状态存储字典
@property (nonatomic,strong) NSMutableArray *selectItemDics;//选中的标签单元格
@property (nonatomic,assign) NSInteger starCount;//星星数量

- (void)switchCollectionViewPage;

@end
