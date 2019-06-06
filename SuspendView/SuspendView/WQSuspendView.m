//
//  WQSuspendView.m
//  SuspendView
//
//  Created by 李文强 on 2019/6/6.
//  Copyright © 2019年 WenqiangLI. All rights reserved.
//

#import "WQSuspendView.h"

@interface WQSuspendView  (){
    CGPoint _originalPoint;//之前的位置
}

@property (nonatomic, assign) WQSuspendViewType type;

@end

@implementation WQSuspendView

static WQSuspendView *_suspendView;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configurationUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame showType:(WQSuspendViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self configurationUI];
    }
    return self;
}

- (void)configurationUI{
    //自定义
    self.backgroundColor = [UIColor redColor];
    //图片~文字等...
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

+ (void)remove{
    [_suspendView removeFromSuperview];
}

+ (void)show{
    [self showWithType:WQSuspendViewTypeNone];
}

+ (void)showWithType:(WQSuspendViewType)type{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _suspendView = [[WQSuspendView alloc] initWithFrame:CGRectMake(0, 200, 50, 50) showType:type];
    });
    if (!_suspendView.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:_suspendView];
        //让floatBtn在最上层(即便以后还有keywindow add subView，也会在 floatBtn下)
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_suspendView];
    }
}


- (void)pan:(UIPanGestureRecognizer *)pan{
    //获取当前位置
    CGPoint currentPosition = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        _originalPoint = currentPosition;
    }else if(pan.state == UIGestureRecognizerStateChanged){
        //偏移量(当前坐标 - 起始坐标 = 偏移量)
        CGFloat offsetX = currentPosition.x - _originalPoint.x;
        CGFloat offsetY = currentPosition.y - _originalPoint.y;
        
        //移动后的按钮中心坐标
        CGFloat centerX = self.center.x + offsetX;
        CGFloat centerY = self.center.y + offsetY;
        self.center = CGPointMake(centerX, centerY);
        
        //父试图的宽高
        CGFloat superViewWidth = self.superview.frame.size.width;
        CGFloat superViewHeight = self.superview.frame.size.height;
        CGFloat btnX = self.frame.origin.x;
        CGFloat btnY = self.frame.origin.y;
        CGFloat btnW = self.frame.size.width;
        CGFloat btnH = self.frame.size.height;
        
        //x轴左右极限坐标
        if (btnX > superViewWidth){
            //按钮右侧越界
            CGFloat centerX = superViewWidth - btnW/2;
            self.center = CGPointMake(centerX, centerY);
        }else if (btnX < 0){
            //按钮左侧越界
            CGFloat centerX = btnW * 0.5;
            self.center = CGPointMake(centerX, centerY);
        }
        
        //默认都是有导航条的，有导航条的，父试图高度就要被导航条占据，固高度不够
        CGFloat defaultNaviHeight = 64;
        CGFloat judgeSuperViewHeight = superViewHeight - defaultNaviHeight;
        
        //y轴上下极限坐标
        if (btnY <= 0){
            //按钮顶部越界
            centerY = btnH * 0.7;
            self.center = CGPointMake(centerX, centerY);
        }
        else if (btnY > judgeSuperViewHeight){
            //按钮底部越界
            CGFloat y = superViewHeight - btnH * 0.5;
            self.center = CGPointMake(btnX, y);
        }
    }else if (pan.state == UIGestureRecognizerStateEnded){
        CGFloat btnWidth = self.frame.size.width;
        CGFloat btnHeight = self.frame.size.height;
        CGFloat btnY = self.frame.origin.y;
        //        CGFloat btnX = self.frame.origin.x;
        //按钮靠近右侧
        switch (_type) {
                
            case WQSuspendViewTypeNone:{
                //自动识别贴边
                if (self.center.x >= self.superview.frame.size.width/2) {
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        //按钮靠右自动吸边
                        CGFloat btnX = self.superview.frame.size.width - btnWidth;
                        self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
                    }];
                }else{
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        //按钮靠左吸边
                        CGFloat btnX = 0;
                        self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
                    }];
                }
                break;
            }
            case WQSuspendViewTypeLeft:{
                [UIView animateWithDuration:0.5 animations:^{
                    //按钮靠左吸边
                    CGFloat btnX = 0;
                    self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
                }];
                break;
            }
            case WQSuspendViewTypeRight:{
                [UIView animateWithDuration:0.5 animations:^{
                    //按钮靠右自动吸边
                    CGFloat btnX = self.superview.frame.size.width - btnWidth;
                    self.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
                }];
            }
        }
    }
    
}





@end
