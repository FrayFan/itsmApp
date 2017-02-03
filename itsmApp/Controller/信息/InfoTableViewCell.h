//
//  InfoTableViewCell.h
//  itsmApp
//
//  Created by itp on 2016/12/22.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end
