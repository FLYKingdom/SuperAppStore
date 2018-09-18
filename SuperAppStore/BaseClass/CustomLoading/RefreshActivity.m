//
//  RefreshActivity.m
//  ifly
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "RefreshActivity.h"

@interface RefreshActivity ()
{
    // Target, method, object and block
    id targetForExecuting;
    SEL methodForExecuting;
    id objectForExecuting;
    dispatch_block_t completionBlock;
}

@property (strong, nonatomic) CALayer *contentLayer;

@property (strong, nonatomic) UILabel *titleLbl;
@property (strong, nonatomic) UILabel *subTitleLbl;

// Mask
@property (strong, nonatomic) CALayer *maskLayer;

// Window
@property (weak, nonatomic) UIView *containerView;

-(void) initCommon;


@end


@implementation RefreshActivity

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
        UIImage *imageColored = [UIImage imageNamed:@"frame_loading1"];
        self.frame = CGRectMake(0, 0, ActivityHeight, ActivityHeight);
        self.center = view.center;
        //    CGFloat scale = [UIScreen mainScreen].scale;
        CGRect frame = CGRectMake(0, 0, ActivityHeight, ActivityHeight);
        
        self.hidden = YES;
        
        [self initCommon];
        
        _contentLayer = [CALayer layer];
        _contentLayer.frame = frame;
        _contentLayer.backgroundColor = [UIColor clearColor].CGColor;
        _contentLayer.contents = (id)imageColored.CGImage;
        [self.layer addSublayer:_contentLayer];
        
    }
    return self;
}
-(void) initCommon
{
    _isAnimate = NO;
}

#pragma mark Action
-(void) show
{
    if (_isAnimate)
        return;
    
    [_containerView addSubview:self];
    
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
