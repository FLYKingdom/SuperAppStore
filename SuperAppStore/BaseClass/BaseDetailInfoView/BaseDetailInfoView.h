//
//  BaseDetailInfoView.h
//  Bunny
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DetailViewTypeEdit,
    DetailViewTypeDisplay,
} DetailViewType;

@interface BaseDetailInfoView : UIScrollView

@property (nonatomic, copy) void(^eventCallBack)(NSInteger eventIndex);

-(instancetype)initWithFrame:(CGRect)frame type:(DetailViewType) type;

//sub class user method
- (void)setupUI;

@end
