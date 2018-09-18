//
//  BaseNavViewController.m
//  ifly
//
//  Created by mac on 17/5/8.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *blackList;//屏蔽手势 黑名单

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self initConfig];
}

#pragma mark - initconfig

- (void)initConfig {
    //初始化方法
//    self.blackList = [NSArray arrayWithObjects:@"BookPlanDetailVc",@"SearchListViewController", nil];
}

#pragma mark - UIGestureRecognizerDelegate
// 是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.childViewControllers.count == 1) {
        return  NO;
    }
    
    
    BOOL isInBlack = NO;
    for (NSString *vcClass in self.blackList) {
        Class blackClass = NSClassFromString(vcClass);

        if ([self.topViewController isKindOfClass:blackClass]) {
            isInBlack = YES;
            break;
        }
    }
    
    if (isInBlack) {
        return NO;
    }
    
    
    return self.childViewControllers.count > 1;
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
