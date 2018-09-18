//
//  DetailDisplayTableView.h
//  ifly
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseStaticCell.h"
#import "DetailDisplayCell.h"

@class DetailDisplayTableView;

//@protocol CustomCellDelegate <NSObject>
//
//@optional
//
///**
// 获取最底部valueLabel（用于计算cell 高度）
//
// @return return value description
// */
//-(UILabel *) getBottomValueLabel;
//
//
///**
// 获取valueView容器View（用于自定义布局）
//
// @return view
// */
//-(UIView *) getValueViewContainer;
//
//@end

@protocol DisplayDetailDelegate <NSObject>

@optional

-(NSInteger)numberOfSectionsInTableView:(DetailDisplayTableView *)tableView;

-(NSInteger)tableView:(DetailDisplayTableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(UITableViewCell *)tableView:(DetailDisplayTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(CGFloat)tableView:(DetailDisplayTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(CGFloat)tableView:(DetailDisplayTableView *)tableView heightForHeaderInSection:(NSInteger)section;

-(UIView *)tableView:(DetailDisplayTableView *)tableView viewForHeaderInSection:(NSInteger)section;

-(CGFloat)tableView:(DetailDisplayTableView *)tableView heightForFooterInSection:(NSInteger)section;

-(UIView *)tableView:(DetailDisplayTableView *)tableView viewForFooterInSection:(NSInteger)section;

-(void)tableView:(DetailDisplayTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DetailDisplayTableView : UITableView

@property (nonatomic, strong) NSArray *tipModelArr;

@property (nonatomic, strong) NSMutableDictionary *detailDict;

@property (nonatomic, weak) id<DisplayDetailDelegate> displayDelegate;

//@property (nonatomic, weak) id<CustomCellDelegate> customCellDelegate;

-(instancetype)initWithFrame:(CGRect)frame tipModelArr:(NSArray *) tipModelArr sepViewStyle:(SepViewStyle) sepStyle;

-(instancetype)initWithFrame:(CGRect)frame tipModelArr:(NSArray *)tipModelArr cellClass:(NSString *) cellClass sepViewStyle:(SepViewStyle)sepStyle;

/**
 设置详情页value的

 @param detailInfo detailInfo description
 */
-(void) setDetailInfoWithDict:(id) detailInfo;

@end
