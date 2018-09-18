//
//  BaseTableViewCell.h
//  ifly
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

#import "Masonry.h"
#import "UILabel+Extension.h"
#import "HexColor.h"

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) BaseModel *model;

@property (nonatomic, copy) void(^callBack)(NSInteger event,BaseModel *model);

@property (nonatomic, strong) UIView *sepView;//分割view

#pragma mark - public method
-(CGFloat)getCellHeightWithModel:(BaseModel *) model;

#pragma mark - can inherit method
- (void)setupUI;

@end
