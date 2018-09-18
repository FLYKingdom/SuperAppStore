// RDVTabBarController.m
// RDVTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "RDVTabBarCenterItem.h"
#import <objc/runtime.h>
//#import "LoginViewController.h"
//#import "EventClickManager.h"
//#import "MyUtility.h"

@interface UIViewController (RDVTabBarControllerItemInternal)

- (void)rdv_setTabBarController:(RDVTabBarController *)tabBarController;

@end

@interface RDVTabBarController () {
    UIView *_contentView;
    
}
@property (nonatomic,assign) BOOL hasCenterButton;
@property (nonatomic, readwrite) RDVTabBar *tabBar;

@property (nonatomic, strong) UIView *sepView;

@property (nonatomic,strong) NSArray *tabConstraint;

@property (nonatomic) NSArray *contentConstraint;

@end

@implementation RDVTabBarController

static RDVTabBarController * tabBarController;
#pragma mark - View lifecycle

-(RDVTabBarItem *)getMessageItem{
    return [[[self tabBar] items] objectAtIndex:2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tabBarController=self;
    _tabBarHidden = YES;//默认为隐藏
    
    [self.view addSubview:[self contentView]];
    
    self.view.layer.masksToBounds = YES;
    
    CGSize viewSize = self.view.bounds.size;
    CGFloat tabBarHeight = 49;
    CGFloat tabBarStartingY = viewSize.height - tabBarHeight;
    
    [[self tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
    [self.view addSubview:[self tabBar]];
    
    //: 建立约束
    if (@available(iOS 11.0, *)) {
        self.view.insetsLayoutMarginsFromSafeArea = YES;
        
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        _tabBar.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tabConstraint = @[
                               [_tabBar.heightAnchor constraintEqualToConstant:44],
                               [_tabBar.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor],
                               [_tabBar.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
                               [_tabBar.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor]
                               ];
        [NSLayoutConstraint activateConstraints:self.tabConstraint];
        
        [self updateAllContentLayout:@[
                                       [_contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                       [_contentView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor],
                                       [_contentView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
                                       [_contentView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor]
                                       ]];
        
        if (IsIPhoneX) {//底部分割线
            [self.sepView setHidden:YES];
            [self.view addSubview:self.sepView];

        }
    } else {
        // Fallback on earlier versions
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|
         UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|
         UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
        
        [_tabBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|
         UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|
         UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
    }
    
    //self.view.backgroundColor=[UIColor redColor];
    [self setTabBarHidden:NO animated:NO];
    
}
+(RDVTabBarController *) getInstance{
    return tabBarController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:[self selectedIndex]];
    
}

- (NSUInteger)supportedInterfaceOrientations {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for (UIViewController *viewCotroller in [self viewControllers]) {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Methods

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        /**
         *添加tab栏其它坐标
         */
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers) {
            RDVTabBarItem *tabBarItem = [[RDVTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController rdv_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabBarItems];
        
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController rdv_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (RDVTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[RDVTabBar alloc] init];
        //[_tabBar setBackgroundColor:[UIColor clearColor]];
        [_tabBar setDelegate:self];
        
        //设置投影
        CALayer *layer= [_tabBar layer];
        [layer setShadowOffset:CGSizeMake(0, -0.7)];
        [layer setShadowRadius:1.8];
        [layer setShadowOpacity:0.7];
        [layer setShadowColor:RGBA(222, 222, 222, 1).CGColor];
    }
    return _tabBar;
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:DefaultBGColor];
        
    }
    return _contentView;
}

-(UIView *)sepView{
    if (!_sepView) {
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 778, kDeviceWidth, 0.5)];
        [sepView setBackgroundColor:RGBA(25, 25, 25, 0.2)];
//        [MyUtility addShadowView:sepView Opacity:0.2];
        _sepView = sepView;
    }
    return _sepView;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    if (_tabBarHidden == hidden) {
        return;
    }
    [self setTabBarHidden:hidden animated:animated delay:0.6f];
}
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated delay:(float) time{
    _tabBarHidden = hidden;
    
    __weak RDVTabBarController *weakSelf = self;
    CGSize viewSize = weakSelf.view.bounds.size;
    CGFloat contentViewHeight = viewSize.height;//CGRectGetHeight(_tabBar.frame) + CGRectGetHeight(_contentView.frame);
    //更新约束
    if (@available(iOS 11.0, *)) {
        //        if (hidden) {
        //            UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        //            [self updateAllContentLayout:@[
        //                                           [_contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        //                                           [_contentView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor],
        //                                           [_contentView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
        //                                           [_contentView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor],
        //                                           ]];
        //        }else{
        //            UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        //            [self updateAllContentLayout:@[
        //                                           [_contentView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        //                                           [_contentView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor],
        //                                           [_contentView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor],
        //                                           [_contentView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor],
        //                                           ]];
        //        }
    } else {
        // Fallback on earlier versions
        contentViewHeight = hidden?contentViewHeight:contentViewHeight-44;
        if ([weakSelf contentView]) {
            [[weakSelf contentView] setFrame:CGRectMake(CGRectGetMinX(_contentView.frame), CGRectGetMinY(_contentView.frame), viewSize.width, contentViewHeight)];
        }
    }
    [self.sepView setHidden:!hidden];//隐藏／显示 分割线
    
    void (^block)() = ^{
        if (!hidden) {
            [[weakSelf tabBar] setHidden:NO];
            [weakSelf tabBar].transform = CGAffineTransformIdentity;
        }else{
            CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
            if (!tabBarHeight) {
                tabBarHeight = 49;
            }
            
            CGAffineTransform originTramsform = [weakSelf tabBar].transform;
            [weakSelf tabBar].transform = CGAffineTransformTranslate(originTramsform, 0, tabBarHeight);
        }
        //        if (@available(iOS 11.0, *)) {
        //            [self.view layoutIfNeeded];//更新view约束
        //        }
        _tabBar.alpha = hidden?0:1;
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        [[weakSelf tabBar] setHidden:hidden];
    };
    
    if (animated) {
        
        [UIView animateWithDuration:time animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }
    
}

- (void)updateAllContentLayout:(NSArray *) layouts{
    
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    for (NSLayoutConstraint *constraint in self.contentConstraint) {
        [_contentView removeConstraint:constraint];
    }
    [NSLayoutConstraint deactivateConstraints:self.contentConstraint];
    
    [NSLayoutConstraint activateConstraints:layouts];
    self.contentConstraint = layouts;
}

- (void)updateTabContraint:(NSArray *) layouts{
    
    _tabBar.translatesAutoresizingMaskIntoConstraints = NO;
    for (NSLayoutConstraint *constraint in self.tabConstraint) {
        [_tabBar removeConstraint:constraint];
    }
    [NSLayoutConstraint deactivateConstraints:self.tabConstraint];
    
    [NSLayoutConstraint activateConstraints:layouts];
    self.tabConstraint = layouts;
}

- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}

#pragma mark - RDVTabBarDelegate

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index]]) {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index]) {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                //TODO:非主VC hidden tabBar 暂不恢复到主VC
                //                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    if (index == 1) {
//        [EventClickManager sendEventClick:clicked_EnterMall];
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
}


/**
 * 中间按钮被点击的代理事件
 */
- (void) tapCenterButton{
    
    if ([[self delegate] respondsToSelector:@selector(centerTaped)]) {
        [[self delegate] centerTaped];
    }
}


-(void) addCenterButton{
    self.hasCenterButton=YES;
    /**
     *添加中心坐标
     */
    RDVTabBarCenterItem *centerItem=[[RDVTabBarCenterItem alloc] init];
    
    [self.tabBar addCenterButton: centerItem];
    
}

#pragma mark - message relative method

-(void)dealloc{
    //注销观察者
    
    NSLog(@"controller %@  886",[self class]);
}

@end

#pragma mark - UIViewController+RDVTabBarControllerItem

@implementation UIViewController (RDVTabBarControllerItemInternal)

- (void)rdv_setTabBarController:(RDVTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(rdv_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (RDVTabBarControllerItem)

- (RDVTabBarController *)rdv_tabBarController {
    RDVTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(rdv_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController rdv_tabBarController];
    }
    return tabBarController;
}

- (RDVTabBarItem *)rdv_tabBarItem {
    RDVTabBarController *tabBarController = [self rdv_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)rdv_setTabBarItem:(RDVTabBarItem *)tabBarItem {
    RDVTabBarController *tabBarController = [self rdv_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

-(RDVTabBarItem *)rdv_MassageBarItem{
    RDVTabBarController *tabBarController = [self rdv_tabBarController];
    
    return [[[tabBarController tabBar] items] objectAtIndex:2];
}

@end

