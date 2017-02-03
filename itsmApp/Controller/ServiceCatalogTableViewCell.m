//
//  ServiceCatalogTableViewCell.m
//  itsmApp
//
//  Created by itp on 2016/12/13.
//  Copyright © 2016年 itp. All rights reserved.
//

#import "ServiceCatalogTableViewCell.h"

@implementation ServiceCatalogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)serviceCatalogAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectServiceCatalog:)]) {
        [self.delegate selectServiceCatalog:self];
    }
    
}

@end
