//
//  UIView+ViewController.m
//  04 Responder
//
//  Created by wei.chen on 15/9/21.
//  Copyright (c) 2015年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)


- (UIViewController *)viewController {
    //取得当前点击视图的下一个响应者
    UIResponder *next = self.nextResponder;
    
    do {
        
        //判断得到的响应者是否是控制器
        if ([next isKindOfClass:[UIViewController class]]) {
            //如果是将该响应者返回
            return (UIViewController *)next;
        }
        //如果不是继续往下找
        next = next.nextResponder;
        
        
    } while (next != nil); //条件是只要有响应者就继续循环找，直到找到为止
    
    return nil;
}


@end
