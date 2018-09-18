//
//  BaseTableView.h
//  ifly
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

#import "MyBaseViewController.h"

typedef enum : NSUInteger {
    TableViewRefreshTypeHeader,
    TableViewRefreshTypeFooter,
    TableViewRefreshTypeLoading,//initial loading style
} TableViewRefreshType;

@class BaseTableView;

@protocol CustomTableViewDelegate <NSObject>

@required
//设置自定义 空场景样式
-(UIView *) setCustomEmptyView:(BaseTableView *) tableView;

@end

@interface BaseTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, copy) NSString *cellClass;//用于改变cell样式 使用set方法

@property (nonatomic, weak) id<CustomTableViewDelegate> customDelegate;

@property (nonatomic) BOOL showRefreshHeader;

@property (nonatomic, assign) BOOL enableNonHeaderResfreshData;//设置头部刷新是否加载数据

@property (nonatomic) BOOL showRefreshFooter;

//回调 event

@property (nonatomic, copy) BOOL (^tableViewDidTriggerRefresh)(TableViewRefreshType type);//reload

@property (nonatomic, copy) void(^tableViewDidClicked)(NSInteger infoID,BaseModel *model);//did selected at row

@property (nonatomic, copy) void(^tableViewDidScroll)(UIScrollView *scrollView);

@property (nonatomic, copy) void(^tableViewDidDelete)(NSInteger infoID);//did delete row

@property (nonatomic, copy) void(^tableViewCellEventCall)(NSInteger event,BaseModel *model);//cell inner event

#pragma mark - public method

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellClass:(NSString *) cellClass editable:(BOOL) editable;

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellClass:(NSString *) cellClass;

//包装成 二维数组
+(NSMutableArray *)getDateMatrixWithArr:(NSArray *) dataArr;

#pragma mark - data method

- (void)showResult:(AddRecordType) type;

-(void)insertRowAtBottom:(NSArray *) newDatas;

@end
