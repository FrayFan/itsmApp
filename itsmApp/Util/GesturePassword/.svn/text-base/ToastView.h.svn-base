//
//  ToastView.h
//  MOA
//
//  Created by SoftDA on 14-5-20.
//  Copyright (c) 2014年 zte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : NSObject
{
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
    UIWindow * displayWindow;
}
+ (void)showWithText:(NSString *) text_;
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;


+ (void)showWithText:(NSString *)text_ DisplayWindow:(UIWindow *) window;
+ (void)showWithText:(NSString *)text_
            duration:(CGFloat)duration_ DisplayWindow:(UIWindow *) window;

+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_ DisplayWindow:(UIWindow *) window;
+ (void)showWithText:(NSString *)text_
           topOffset:(CGFloat)topOffset_
            duration:(CGFloat)duration_ DisplayWindow:(UIWindow *) window;

+ (void)showWithText:(NSString *)text_
        bottomOffset:(CGFloat)bottomOffset_ DisplayWindow:(UIWindow *) window;
+ (void)showWithText:(NSString *)text_
        bottomOffset:(CGFloat)bottomOffset_
            duration:(CGFloat)duration_ DisplayWindow:(UIWindow *) window;





- (id)initWithText:(NSString *)text_;
- (void)setDuration:(CGFloat) duration_;
- (void)setDisplayWindow:(UIWindow *) window;

- (void)dismissToast;
- (void)toastTaped:(UIButton *)sender_;

- (void)showAnimation;
- (void)hideAnimation;

- (void)show;
- (void)showFromTopOffset:(CGFloat) topOffset_;
- (void)showFromBottomOffset:(CGFloat) bottomOffset_;

@end
