//
//  BaseStaticTableView.h
//  ifly
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseStaticCell.h"

@interface BaseStaticTableView : UITableView

//data
@property (nonatomic, strong) NSArray *dataArray;

//回调 block
@property (nonatomic, copy) void(^tableViewDidClicked)(NSInteger infoID);

@property (nonatomic, copy) void(^tableViewCellEventCall)(NSInteger event,BaseModel *model);

#pragma mark - 初始化 方法

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellClass:(NSString *)cellClass editable:(BOOL)editable sepViewStyle:(SepViewStyle) sepStyle;


/**
 生成静态tableView的数据源数组
 
 @param tipArr     tipArr section之间section间隔
 @param iconName iconName

 @return dataArr
 */
+(NSArray *)generateTableArr:(NSArray *)tipArr iconPath:(NSString *)iconName;

-(void) addHeaderView:(UIView *) headerView;

@end
