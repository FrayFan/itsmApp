//
//  FeedbackSecondCell.h
//  itsmApp
//
//  Created by admin on 2016/12/14.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePickerHandler.h"

@interface FeedbackSecondCell : UITableViewCell

@property (nonatomic,weak) ImagePickerHandler *imagePickerHandler;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UILabel *promptLable;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@end
