//
//  BaseStaticCell.m
//  ifly
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseStaticCell.h"
#import "Masonry.h"
#import "UILabel+Extension.h"


@interface BaseStaticCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation BaseStaticCell

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - set method

-(void)setModel:(StaticCellModel *)model{
    _model = model;
    
    //: set values
    if (!model || [model.iconPath isEqualToString:@""]) {
        [self.iconView setHidden:YES];
        [self.tipLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.left).offset(16);
            make.top.equalTo(self.contentView.top);
            make.height.equalTo(50);
        }];
    }else{
        [self.iconView setHidden:NO];
        [self.tipLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.right).offset(11);
            make.top.equalTo(self.contentView.top);
            make.height.equalTo(50);
        }];
        UIImage *iconImg = [UIImage imageNamed:model.iconPath];
        if (iconImg) {
            [self.iconView setImage:iconImg];
        }
    }
    
    
    [self.tipLabel setText:model.tipStr];
}

#pragma mark - public method

-(CGFloat)getCellHeight{
//    self.model = model;
//    
//    //手动刷新布局
//    [self layoutIfNeeded];
//    if (!self.sepView) {
//        return 0;
//    }
    return 50;//CGRectGetMaxY(self.sepView.frame);
}


-(void)setSepViewStyle:(SepViewStyle)style{
    switch (style) {
            
        case SepViewStyleFullLine:
        {
            [self.sepView setHidden:NO];
            [self.sepView updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.left);//.offset(16);
            }];
        }
            break;
        case SepViewStyleNone:
        {
            [self.sepView setHidden:YES];
        }
            break;
            
        case SepViewStyleCommon:
        default:
        {
            [self.sepView setHidden:NO];
            [self.sepView updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.left).offset(16);
            }];
        }
            break;
    }
}

#pragma mark - initial method

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //TODO: setup ui
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
    
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

#pragma mark - setup ui

-(void)setupUI{
    
    UIImageView *iconView = [[UIImageView alloc] init];
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    [iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(16);
        make.height.equalTo(17);
    }];
    
    UILabel *tipLabel = [UILabel labelWithName:@"" fontSize:16 fontHexColor:@"333333"];
    self.tipLabel = tipLabel;
    [self.contentView addSubview:tipLabel];
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.right).offset(11);
        make.top.equalTo(self.contentView.top);
        make.height.equalTo(50);
    }];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sell_icon_next"]];
    arrowView.contentMode = UIViewContentModeRight;
    [self.contentView addSubview:arrowView];
    [arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right).offset(-16);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(20);
        make.height.equalTo(50);
    }];
    
    UIView *sepView = [[UIView alloc] init];
    [sepView setBackgroundColor:RGBA(51, 51, 51, 0.2)];
    self.sepView = sepView;
    [self.contentView addSubview:sepView];
    [sepView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.right);
        make.left.equalTo(self.contentView.left).offset(16);
        make.top.equalTo(tipLabel.bottom);
        make.height.equalTo(0.5);
    }];
}

@end
