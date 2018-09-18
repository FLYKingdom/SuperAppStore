//
//  IdeaMainViewController.m
//  SuperAppStore
//
//  Created by mac on 2018/3/16.
//  Copyright © 2018年 FlyYardAppStore. All rights reserved.
//
// idea:
// focus on there is only one thing that will do
// do the thing best what you cna do

#import "IdeaMainViewController.h"
#import "UIButton+Extension.h"
#import <Masonry.h>

@interface IdeaMainViewController ()

//key word 力求言简意赅
@property (nonatomic, strong) UILabel *keyTitleLab;

// time line 关键时间节点
@property (nonatomic, strong) UILabel *timeLine;

// key node 节点说明
@property (nonatomic, strong) UILabel *keyNodeLab;


@end

@implementation IdeaMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor randomFlatColor]];
    
    [self setupNavigationTitle:@"Idea" nonTitle:NO];
    
    [self setupUI];
}

- (void)setupNavigation {
    UIButton *addNew = [UIButton buttonWithName:@"添加" andFont:DefaultMainFontSize color:DefaultFontColor cornerRadius:0];
    [addNew addTarget:self action:@selector(addNewAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addNew];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupUI {
    //组成部分
    
    //1. idea key word 爸妈杭州行
    UILabel *keyLab = [UILabel labelWithName:@"爸妈杭州行" fontSize:DefaultMainFontSize fontColor:DefaultFontColor];
    self.keyTitleLab = keyLab;
    [self.view addSubview:keyLab];
    [keyLab setFrame:CGRectMake((kDeviceWidth - 100)/2, 50, 100, 50)];
    
    
    
    
}

#pragma mark - evnet

- (void)addNewAction {
    //todo add new
    
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
