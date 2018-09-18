//
//  RefreshFooter.m
//  ifly
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "RefreshFooter.h"
#import "HexColor.h"


@interface RefreshFooter()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end

@implementation RefreshFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 40;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [HexColor colorWithHexString:@"999999"];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.label.frame = self.bounds;
    
    self.loading.center = CGPointMake(self.mj_w*0.5-60, self.mj_h * 0.5);
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
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.label.text = @"";
            [self.loading stopAnimating];
        }
            break;
        case MJRefreshStateRefreshing:{
            self.label.text = @"加载数据中";
            [self.loading startAnimating];
        }
            break;
        case MJRefreshStateNoMoreData:{
            NSDictionary *attributedDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,RGBA(25, 25, 25, 0.2),NSForegroundColorAttributeName, nil];
            NSDictionary *attributedDict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,RGBA(153, 153, 153, 1),NSForegroundColorAttributeName, nil];
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"————     " attributes:attributedDict];
            NSAttributedString *attributeStr1 = [[NSAttributedString alloc] initWithString:@"已经到底了呀～" attributes:attributedDict1];
            NSAttributedString *attributeStr2 = [[NSAttributedString alloc] initWithString:@"     ————" attributes:attributedDict];
            
            [attributeStr appendAttributedString:attributeStr1];
            [attributeStr appendAttributedString:attributeStr2];
            self.label.attributedText = attributeStr;
            [self.loading stopAnimating];
        }
            break;
        default:
            break;
    }
}

@end
