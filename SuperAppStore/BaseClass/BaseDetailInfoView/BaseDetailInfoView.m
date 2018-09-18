//
//  BaseDetailInfoView.m
//  Bunny
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseDetailInfoView.h"

@interface BaseDetailInfoView ()

//view
@property (nonatomic, strong) UIView *sepView;

//data
@property (nonatomic, assign) DetailViewType type;

@end

@implementation BaseDetailInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame type:(DetailViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        
        self.scrollEnabled = YES;
        
        [self setupUI];
        
        if (!self.sepView) {
            self.contentSize = self.frame.size;
        }else{
            self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetMaxY(self.sepView.frame));
        }
        
    }
    return self;
}

- (void)setupUI {
    // set up ui
    
}

@end
