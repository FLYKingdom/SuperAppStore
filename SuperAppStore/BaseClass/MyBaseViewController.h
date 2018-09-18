//
//  MyBaseViewController.h
//  schoolIM
//
//  Created by bingo on 14-10-15.
//  Copyright (c) 2014年 profusionup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

//#import "MobClick.h"

/**
 联网加载数据后的两种加入table的方式：
 ADD_RECORD_BY_INSERT :插入到表格底部
 ADD_RECORD_BY_CLEAR_CACHE:清空缓存替换之前的记录
 **/
typedef enum{ADD_RECORD_BY_INIT,ADD_RECORD_BY_RELOAD,ADD_RECORD_BY_INSERT,ADD_RECORD_BY_CLEAR_CACHE} AddRecordType;


@interface MyBaseViewController : UIViewController{

    bool gestureDisable;
    bool backButtonDisable;

}

@property (nonatomic,retain) UILabel *navigationTitle;
@property (assign,nonatomic) BOOL isFooterView;  //是否是顶级的菜单，如果是顶级的菜单，那么不需要在viewDidLoad中加入导航按钮，否则需要加入导航按钮

@property (nonatomic, copy) void((^finishedBack)(NSInteger infoID,id moreInfo));

-(instancetype) initWithModalStyle;

-(id) initIsFooterView:(BOOL)isFooter;

#pragma mark - public method


/**
 设置 导航栏的title 并注册 页面事件

 @param titleStr
 @param nonTitle 是否展示title
 */
-(void)setupNavigationTitle:(NSString *)titleStr nonTitle:(BOOL) nonTitle;

/**
 *  统一设置背景颜色
 *
 *  @param backgroundColor 目标背景图片
 */
- (void)setupBackgroundColor;


/**
 *  push新的控制器到导航控制器，也就是页面跳转
 *
 *  @param newViewController 目标新的控制器对象
 */
- (void)pushNewViewController:(UIViewController *)newViewController;

/**
 *  显示加载的loading，没有文字的
 */
- (void)showLoading;
/**
 *  隐藏在该View上的所有HUD，不管有哪些，都会全部被隐藏,也就是停止加载
 */
- (void)hideLoading;
/**
 *  显示成功的HUD
 */
- (void)showSuccess;
/**
 *  显示错误的HUD
 */
- (void)showError;
/**
 *这种加载框锁住界面，加载没完成不能进行下一步的操作
 */
-(void)showOnWindow;
/**
 * 一些操作结果的提示,提示没有消失不能进行下一步操作
 */
- (void)showOnWindowWithString:(NSString *)content;
/**
 *一些操作结果的提示,提示没有消失可以进行下一步操作
 */
-(void) showToastWithString:(NSString *)content;

-(void) scrollisScrolling:(UIScrollView *)scrollView;

#pragma mark - set bar style

-(void) setTranslucentBarStyle:(UIScrollView *) scrollView;

@end
