//
//  TentacleView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "TentacleView.h"

@implementation TentacleView {
    CGPoint lineStartPoint;
    CGPoint lineEndPoint;
    
    NSMutableArray * touchesArray;
    NSMutableArray * touchedArray;
    BOOL success;
}
@synthesize buttonArray;
@synthesize drawResultDelegate;
@synthesize touchBeginDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //huangcong----add
        buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i=0; i<9; i++) {
            NSInteger row = i/3;
            NSInteger col = i%3;
            // Button Frame
            
            NSInteger distance = 320/3;
            NSInteger size = distance/1.5;
            NSInteger margin = size/4;
            CGRect frame = CGRectMake(col*distance+margin, row*distance, size, size);
            UIButton * gesturePasswordButton = [[UIButton alloc]initWithFrame:frame];
            
            gesturePasswordButton.layer.masksToBounds = YES;
            gesturePasswordButton.layer.cornerRadius = CGRectGetHeight(frame)/2.0;
            gesturePasswordButton.backgroundColor = [UIColor whiteColor];
            
            [gesturePasswordButton setTag:i];
            [gesturePasswordButton setBackgroundImage:[UIImage imageNamed:@"gesture_grid_normal"] forState:UIControlStateNormal];
            [gesturePasswordButton setBackgroundImage:[UIImage imageNamed:@"gesture_grid_focused"] forState:UIControlStateSelected];
            //禁止按钮响应事件
            gesturePasswordButton.userInteractionEnabled = NO;
            [self addSubview:gesturePasswordButton];
            [buttonArray addObject:gesturePasswordButton];
        }
        //huangcong----add
        
        // Initialization code
        touchesArray = [[NSMutableArray alloc]initWithCapacity:0];
        touchedArray = [[NSMutableArray alloc]initWithCapacity:0];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        success = 1;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    [touchesArray removeAllObjects];
    [touchedArray removeAllObjects];
    [touchBeginDelegate gestureTouchBegin];
    success=1;
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i=0; i<buttonArray.count; i++) {
            UIButton * buttonTemp = ((UIButton *)[buttonArray objectAtIndex:i]);
            //[buttonTemp setSuccess:YES];
            [buttonTemp setSelected:NO];
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2);
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y", nil];
                [touchesArray addObject:dict];
                lineStartPoint = touchPoint;
            }
            [buttonTemp setNeedsDisplay];
        }
        
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i=0; i<buttonArray.count; i++) {
            UIButton * buttonTemp = ((UIButton *)[buttonArray objectAtIndex:i]);
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                if ([touchedArray containsObject:[NSString stringWithFormat:@"num%d",i]]) {
                    lineEndPoint = touchPoint;
                    [self setNeedsDisplay];
                    return;
                }
                [touchedArray addObject:[NSString stringWithFormat:@"num%d",i]];
                [buttonTemp setSelected:YES];
                [buttonTemp setNeedsDisplay];
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2);
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y",[NSString stringWithFormat:@"%d",i],@"num", nil];
                [touchesArray addObject:dict];
                break;
            }
        }
        lineEndPoint = touchPoint;
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSMutableString * resultString=[NSMutableString string];
    for ( NSDictionary * num in touchesArray ){
        if(![num objectForKey:@"num"])break;
        [resultString appendString:[num objectForKey:@"num"]];
    }
    //if(style==1){
    success = [drawResultDelegate DrawResult:resultString];
//    }
//    else {
//        success = [resetDelegate resetPassword:resultString];
//    }
    
    for (int i=0; i<touchesArray.count; i++) {
        NSInteger selection = [[[touchesArray objectAtIndex:i] objectForKey:@"num"]intValue];
        UIButton * buttonTemp = ((UIButton *)[buttonArray objectAtIndex:selection]);
        //[buttonTemp setSuccess:success];
        [buttonTemp setNeedsDisplay];
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    if (touchesArray.count<2)return;
    for (int i=0; i<touchesArray.count; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (![[touchesArray objectAtIndex:i] objectForKey:@"num"]) { //防止过快滑动产生垃圾数据
            [touchesArray removeObjectAtIndex:i];
            continue;
        }
        if (success) {
             CGContextSetRGBStrokeColor(context, 15/255.f, 165/255.f, 233/255.f, 1.0);
        }
        else {
            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f, 0.7);//红色
        }
        
        CGContextSetLineWidth(context,1);
        CGContextMoveToPoint(context, [[[touchesArray objectAtIndex:i] objectForKey:@"x"] floatValue], [[[touchesArray objectAtIndex:i] objectForKey:@"y"] floatValue]);
        if (i<touchesArray.count-1) {
            CGContextAddLineToPoint(context, [[[touchesArray objectAtIndex:i+1] objectForKey:@"x"] floatValue],[[[touchesArray objectAtIndex:i+1] objectForKey:@"y"] floatValue]);
        }
        else{
            if (success)
            {
                CGContextAddLineToPoint(context, lineEndPoint.x,lineEndPoint.y);
            }
        }
        CGContextStrokePath(context);
    }
}

- (void)enterArgin {
    [touchesArray removeAllObjects];
    [touchedArray removeAllObjects];
    for (int i=0; i<buttonArray.count; i++) {
        UIButton * buttonTemp = ((UIButton *)[buttonArray objectAtIndex:i]);
        [buttonTemp setSelected:NO];
        //[buttonTemp setSuccess:YES];
        [buttonTemp setNeedsDisplay];
    }
    
    [self setNeedsDisplay];
}

-(CGPoint)getCurrentPoint:(NSSet *)touches
{
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:touch.view];
    return point;
}
-(UIButton *)getCurrentBtnWithPoint:(CGPoint)point
{
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return Nil;
}

@end
