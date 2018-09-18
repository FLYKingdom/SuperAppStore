//
//  BaseStaticCell.h
//  ifly
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticCellModel.h"

typedef enum : NSUInteger {
    SepViewStyleCommon,//leftsep 16
    SepViewStyleNone,//最后一行 无line
    SepViewStyleFullLine,//最后一行 通栏
} SepViewStyle;//

@interface BaseStaticCell : UITableViewCell

@property (nonatomic, strong) StaticCellModel *model;

@property (nonatomic, copy) void(^callBack)(NSInteger event,BaseModel *model);

@property (nonatomic, strong) UIView *sepView;//分割view

#pragma mark - public method

-(CGFloat)getCellHeight;

-(void) setSepViewStyle:(SepViewStyle) style;

#pragma mark - can inherit method
- (void)setupUI;

@end
