//
//  RefreshHeader.m
//  ifly
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "RefreshHeader.h"
#import "RefreshActivity.h"
#import "HexColor.h"

@interface RefreshHeader()
@property (weak, nonatomic) UILabel *label;
//@property (weak, nonatomic) UIImageView *logo;

@property (nonatomic, strong) RefreshActivity *loadingControl;

@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation RefreshHeader

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        UIImage *arrowImage = [UIImage imageNamed:@"refreshArrow"];
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrowImage];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 60;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [HexColor colorWithHexString:@"999999"];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // loading
    RefreshActivity *loadingV = [[RefreshActivity alloc] initWithView:self];
    loadingV.center = self.center;
    [self addSubview:loadingV];
    self.loadingControl = loadingV;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    
    CGFloat maxWidth = 100 + ActivityHeight + 10;
    CGFloat startX = (self.mj_w - maxWidth)*0.5;
    self.label.frame = CGRectMake(startX+ActivityHeight +10, 0, 100, self.mj_h);
    self.loadingControl.center = CGPointMake(startX+ActivityHeight*0.5, self.mj_h * 0.5);
    
    // 箭头的中心点
    CGPoint arrowCenter = CGPointMake(startX+ActivityHeight*0.5, self.mj_h * 0.5);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }

//    self.loadingControl.center = CGPointMake(self.mj_w * 0.5, self.mj_h*0.5);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
//    switch (state) {
//        case MJRefreshStateIdle:
//            [self.loadingControl dismiss];
//            [self.loadingControl setHidden:NO];
//            self.label.text = @"下拉可以刷新";
//            break;
//        case MJRefreshStatePulling:
//            [self.loadingControl dismiss];
//            [self.loadingControl setHidden:NO];
//            self.label.text = @"松开立即刷新";
//            break;
//        case MJRefreshStateRefreshing:
//            self.label.text = @"努力加载中...";
//            [self.loadingControl setHidden:YES];
//            [self.loadingControl show];
//            break;
//        default:
//            break;
//    }
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingControl.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingControl.alpha = 1.0;
                [self.loadingControl dismiss];
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loadingControl dismiss];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
        self.label.text = @"下拉可以刷新";
    } else if (state == MJRefreshStatePulling) {
        [self.loadingControl dismiss];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
        self.label.text = @"松开立即刷新";
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingControl.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingControl show];
        self.arrowView.hidden = YES;
        self.label.text = @"努力加载中...";
    }
}

//#pragma mark 监听拖拽比例（控件被拖出来的比例）
//- (void)setPullingPercent:(CGFloat)pullingPercent
//{
//    [super setPullingPercent:pullingPercent];
//    
//    // 1.0 0.5 0.0
//    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//}

@end
