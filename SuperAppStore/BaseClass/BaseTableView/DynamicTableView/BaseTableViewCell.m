//
//  BaseTableViewCell.m
//  ifly
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

#pragma mark - set method

-(void)setModel:(BaseModel *)model{
    _model = model;
    
    //TODO: set values
    
}

#pragma mark - public method

-(CGFloat)getCellHeightWithModel:(BaseModel *)model{
    self.model = model;
    
    //手动刷新布局
    [self layoutIfNeeded];
    if (!self.sepView) {
        return 50;
    }
    return CGRectGetMaxY(self.sepView.frame);
}

#pragma mark - initial method

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //TODO: setup ui
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
    
}

#pragma mark - setup ui

- (void)setupUI {
    //TODO: layout subviews
    
}

#pragma mark - event deal With

- (void)evetDealWith {
    //TODO: event deal with
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
