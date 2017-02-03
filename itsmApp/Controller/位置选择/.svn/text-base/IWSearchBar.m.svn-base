//
//  IWSearchBar.m
//  ItcastWeibo
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWSearchBar.h"

@interface IWSearchBar()
@end

@implementation IWSearchBar
+ (instancetype)searchBar
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // 左边的放大镜图标
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchbar_textfield_search_icon"]];
        iconView.frame = CGRectMake(0, 0, 12, 12);
        iconView.contentMode = UIViewContentModeCenter;
        self.leftView = iconView;
        self.leftViewMode = UITextFieldViewModeAlways;
        // 字体
        self.font = [UIFont systemFontOfSize:13];
        // 右边的清除按钮
        self.clearButtonMode = UITextFieldViewModeAlways;
        // 设置提醒文字
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入城市名或拼音查询" attributes:attrs];
        // 设置键盘右下角按钮的样式
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    if (self.isFirstResponder || [self.text length] > 0) {
        return CGRectMake(10, 0, 12, self.bounds.size.height);
    }
    else
    {
        CGSize size = [self.placeholder sizeWithAttributes:@{NSFontAttributeName:self.font}];
        CGFloat width = MIN(size.width, self.bounds.size.width);
        return CGRectMake(bounds.size.width/2.0-(12.0+width)/2.0, 0.0, 12, self.bounds.size.height);
    }
}

@end
