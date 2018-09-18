//
//  ZSLoadingView.m
//  ifly
//
//  Created by mac on 17/4/21.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "ZSLoadingView.h"
#import "HexColor.h"

#define LoadSize CGSizeMake(100, 74)

@interface ZSLoadingView ()
{
    // Target, method, object and block
    id targetForExecuting;
    SEL methodForExecuting;
    id objectForExecuting;
    dispatch_block_t completionBlock;
}

@property (strong, nonatomic) CALayer *contentLayer;

@property (strong, nonatomic) UILabel *titleLbl;

// Mask
@property (strong, nonatomic) CALayer *maskLayer;

// Window
@property (weak, nonatomic) UIView *containerView;

//@property (nonatomic, strong) UIView *subContainer;

-(void) initCommon;

@end


@implementation ZSLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        _containerView = view;
        
//        UIView *contanerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LoadSize.width, LoadSize.height)];
//        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        CGFloat offset = 0;//CGRectGetHeight(view.frame)/6;
//        NSLog(@"center window = %@",NSStringFromCGPoint(window.center));
        CGPoint newCenter = CGPointMake(view.center.x, view.center.y - offset);
//        if ([window.subviews firstObject]) {
//            UIView *tmpView = [window.subviews firstObject];
//            newCenter = [tmpView convertPoint:tmpView.center toView:view];
//        }
//        NSLog(@"new center = %@",NSStringFromCGPoint(newCenter));
        
        [self initCommon];
        self.frame = CGRectMake(0, 0, LoadSize.width, LoadSize.height);
        self.center = newCenter;
//        contanerV.center = self.center;
//        self.subContainer = contanerV;
//        [self addSubview:contanerV];
        
        UIImage *imageColored = [UIImage imageNamed:@"frame_loading1"];
        CGSize imageSize = CGSizeMake(50.5, 50);
        CGRect frame = CGRectMake((LoadSize.width - imageSize.width)*0.5-3, 0, imageSize.width, imageSize.height);
        
        _contentLayer = [CALayer layer];
        _contentLayer.frame = frame;
        _contentLayer.backgroundColor = [UIColor clearColor].CGColor;
        _contentLayer.contents = (id)imageColored.CGImage;
        [self.layer addSublayer:_contentLayer];

        // Title
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(frame) +10, LoadSize.width, 14)];
        _titleLbl.text = @"努力加载中...";
        _titleLbl.font = [UIFont boldSystemFontOfSize:14];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.textColor = [HexColor colorWithHexString:@"999999"];
        
        [self addSubview:_titleLbl];
    }
    return self;
}

-(void)remakePosition:(CGPoint)position{
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    CGPoint tmpCenter = CGPointMake(window.center.x + , <#CGFloat y#>)
//    CGPoint newCenter ;
//    if (window) {
//        newCenter = [_containerView convertPoint:window.center fromView:window];
//    }else{
//        newCenter = _containerView.center;
//        
//    }
//    self.frame = CGRectMake(0, 0, LoadSize.width, LoadSize.height);
//    self.center = newCenter;
    CGPoint tmpCenter = self.center;
    CGPoint newCenter = CGPointMake(tmpCenter.x + position.x, tmpCenter.y+position.y);
    self.center = newCenter;
    
}

-(void) initCommon
{
    _isAnimate = NO;
    [self setBackgroundColor:[UIColor clearColor]];
}

#pragma mark Action
-(void) show
{
    if (_isAnimate)
        return;
    
    if (_containerView) {
        [_containerView addSubview:self];
        [_containerView bringSubviewToFront:self];
    }
    
    _isAnimate = YES;
    self.hidden = NO;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:12];
    for (int i = 1; i<=12; i++) {
        NSString *loadImgName = [NSString stringWithFormat:@"frame_loading%d",i];
        UIImage *image = [UIImage imageNamed:loadImgName];
        [tmpArr addObject:(id)image.CGImage];
    }
    NSArray *values = tmpArr.copy;
    
    [anim setValues:values];
    [anim setDuration:1.0f];
    anim.repeatCount = MAXFLOAT;
    
    [_contentLayer addAnimation:anim forKey:@"content"];
    
}
-(void) dismiss
{
    if (!_isAnimate)
        return;
    
    [self removeFromSuperview];
    _isAnimate = NO;
}

@end
