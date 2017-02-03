//
//  ServiceCatalogTableViewCell.h
//  itsmApp
//
//  Created by itp on 2016/12/13.
//  Copyright © 2016年 itp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceCatalogTableViewCell;

@protocol ServiceCatalogTableViewDelegate <NSObject>

@optional
- (void)selectServiceCatalog:(ServiceCatalogTableViewCell *)cell;

@end

@interface ServiceCatalogTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *serviceCatalogButton;
@property (weak, nonatomic)id<ServiceCatalogTableViewDelegate> delegate;
@end
