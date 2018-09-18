//
//  CustomDisplayView.m
//  ifly
//
//  Created by mac on 2017/7/16.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "CustomDisplayView.h"

@interface CustomDisplayView ()

//data
@property (nonatomic, strong) id value;

@property (nonatomic, assign) NSTextAlignment valueAlignment;

@end

@implementation CustomDisplayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setDisplay:(id)displayModel value:(id)value{
    self.value = value;
    self.displayModel = displayModel;
    
    //设置value
}

-(CGFloat)getViewMaxHeight:(DisplayAtomModel *) displayModel value:(id) value{
    
    return 29;
}

- (instancetype)initWithFrame:(CGRect)frame alignment:(NSTextAlignment) alignment
{
    self = [super initWithFrame:frame];
    if (self) {
        self.valueAlignment = alignment;
        [self setUpUIWithAlignment:alignment];
    }
    return self;
}
         
- (void)setUpUIWithAlignment:(NSTextAlignment) alignment{
    //TODO: 设置自定义布局
    
}

@end
