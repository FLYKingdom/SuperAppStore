//
//  DetailDisplayCell.h
//  ifly
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "DisplayAtomModel.h"
#import "BaseStaticCell.h"
#import "CustomDisplayView.h"

@interface DetailDisplayCell : UITableViewCell

@property (nonatomic, strong) UIView *sepView;

@property (nonatomic, assign) SepViewStyle sepStyle;

-(void) setTip:(DisplayAtomModel *) displayModel value:(id) value;

-(CGFloat) getCellHeight:(DisplayAtomModel *) displayModel value:(id) value;;

@end
