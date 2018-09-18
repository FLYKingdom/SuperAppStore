//
//  DetailDisplayCell.m
//  ifly
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "DetailDisplayCell.h"

@interface DetailDisplayCell ()

@property (nonatomic, strong) UILabel *tipLabel;

//@property (nonatomic, strong) UIView *valueView;

@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, strong) CustomDisplayView *valueView;

//data

@property (nonatomic, strong) DisplayAtomModel *displayModel;

@end

@implementation DetailDisplayCell


-(CGFloat)getCellHeight:(DisplayAtomModel *)displayModel value:(id)value{
    if (!displayModel.isNecessary && (!value || [value isEqualToString:@""])) {
        return 0.01;
    }
    
    [self setTip:displayModel value:value];
    
    CGFloat maxSepY ;
    if (self.valueLabel) {
        [self layoutIfNeeded];
        maxSepY = CGRectGetMaxY(self.valueLabel.frame);
    }else if (self.valueView){
        maxSepY = [self.valueView getViewMaxHeight:displayModel value:value];
    }else{
        return 29;
    }
    
    maxSepY += (self.sepStyle == SepViewStyleFullLine)?15:0;
    return maxSepY >= 29?maxSepY:29;
}

-(void)setTip:(DisplayAtomModel *)displayModel value:(id)value{
    // set value
    [self.tipLabel setText:displayModel.tipStr];
    
    //value view
    if (self.valueLabel) {
        [self.valueLabel setText:value];
        
        return;
    }
    
    if (self.valueView) {
        [self.valueView setDisplay:displayModel value:value];
        
        return;
    }
    
    self.displayModel = displayModel;
    
    if (displayModel.style == DisplayStyleCommonLab || displayModel.style == DisplayStyleErrorLab) {
        
        NSString *valueStr = [value isKindOfClass:[NSString class]]?value:@"";
        NSString *colorStr = displayModel.style == DisplayStyleCommonLab?@"666666":@"ff0000";
        UILabel *displayLab = [UILabel labelWithName:valueStr fontSize:14 fontHexColor:colorStr];
        [displayLab setTextAlignment:displayModel.valueAlignment];
        self.valueLabel = displayLab;
        [displayLab setNumberOfLines:0];
        CGFloat width = kDeviceWidth -32 - 64 - 30;
        [self.contentView addSubview:displayLab];
        [displayLab makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.right).offset(-16);
            make.top.equalTo(self.contentView.top).offset(12);
//            make.left.equalTo(self.tipLabel.right).offset(-5);
            make.width.equalTo(width);
//            make.top.equalTo(self.valueView.top).offset(12.5);
//            make.left.right.equalTo(self.valueView);//.offset(16);
        }];
    }else{
        //TODO: 添加custom view
        Class customViewClass = NSClassFromString(displayModel.valueViewClass);
        CGFloat width = kDeviceWidth -32 - 64 - 30;
        CustomDisplayView *valueView = [[customViewClass alloc] initWithFrame:CGRectMake(0, 0, width, 29) alignment:displayModel.valueAlignment];
        self.valueView = valueView;
        [valueView setDisplay:displayModel value:value];
        [self.contentView addSubview:valueView];
        [valueView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.right).offset(-16);
            make.top.equalTo(self.contentView.top);
            make.width.equalTo(width);
        }];
    }
    
}

-(void)setSepStyle:(SepViewStyle)sepStyle{
    _sepStyle = sepStyle;
    
    switch (sepStyle) {
            
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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    
    return self;
}

#pragma mark - setup ui

- (void)setupUI {
    
    UILabel *tipLabel = [UILabel labelWithName:@"" fontSize:14 fontHexColor:@"666666"];
    self.tipLabel = tipLabel;
    [self.contentView addSubview:tipLabel];
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.top.equalTo(self.contentView.top).offset(15);
        make.height.equalTo(14);
        make.width.equalTo(80);
    }];
    
//    UIView *valueView = [[UIView alloc] init];
//    self.valueView = valueView;
//    [self.contentView addSubview:valueView];
//    [valueView makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.right).offset(-16);
//        make.bottom.top.equalTo(tipLabel);
//        make.left.equalTo(tipLabel.right).offset(-5);
//    }];
    
    UIView *sepView = [[UIView alloc] init];
    self.sepView = sepView;
    [sepView setBackgroundColor:RGBA(51, 51, 51, 0.2)];
    [self.contentView addSubview:sepView];
    [sepView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).offset(16);
        make.right.equalTo(self.contentView.right);
        make.height.equalTo(0.5);
        make.bottom.equalTo(self.contentView.bottom);
    }];
}

#pragma mark - event


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
