//
//  BaseStaticTableView.m
//  ifly
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseStaticTableView.h"

#import "HexColor.h"

@interface BaseStaticTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSString *cellClass;

@property (nonatomic, strong) UIView *headeView;

@property (nonatomic, assign) SepViewStyle sepStyle;

//data

@end

@implementation BaseStaticTableView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - public method

- (void)addHeaderView:(UIView *)headerView {
    //TODO: 设置header view
    self.headeView = headerView;
    self.tableHeaderView = headerView;
    [self reloadData];
}

#pragma mark - class method

+(NSArray *)generateTableArr:(NSArray *)tipArr iconPath:(NSString *)iconName{
    
    NSString *sectionNote = @"section";
    int i = 0;
    NSMutableArray *finalArr = [NSMutableArray array];
    NSMutableArray *tmpSectionArr = [NSMutableArray array];
    
    for (NSString *tipStr in tipArr) {
        NSString *iconPath = !iconName?@"":[NSString stringWithFormat:@"%@%d",iconName,i];
        if ([tipStr isEqualToString:sectionNote]) {
            //更换 section
            [finalArr addObject:tmpSectionArr];
            
            tmpSectionArr = [NSMutableArray array];
        }else{
            StaticCellModel *model = [StaticCellModel modelWithTipStr:tipStr iconPath:iconPath];
            
            [tmpSectionArr addObject:model];
            i++;
        }
        
    }
    
    [finalArr addObject:tmpSectionArr];
    
    return finalArr.copy;
}

#pragma mark - set method

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    [self reloadData];
    
}

#pragma mark - initial method

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellClass:(NSString *)cellClass editable:(BOOL)editable sepViewStyle:(SepViewStyle)sepStyle{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self setBackgroundColor:DefaultBGColor];
        //        NSLog(@"class = %@",NSClassFromString(cellClass));
        [self registerClass:NSClassFromString(cellClass) forCellReuseIdentifier:cellClass];
        self.cellClass = cellClass;
        self.sepStyle = sepStyle;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellClass:(NSString *)cellClass{
    return [self initWithFrame:frame style:style cellClass:cellClass editable:NO sepViewStyle:SepViewStyleNone];
}

#pragma mark - tableview datasource delegate method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count <= section) {
        return 0;
    }
    NSArray *sectionArr = [self.dataArray objectAtIndex:section];
    
    return sectionArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    Class cellClass = NSClassFromString(self.cellClass);
//    
//    if (cellClass == NULL) {
//        cellClass = [BaseStaticCell class];
//    }
    
    BaseStaticCell *cell = [self dequeueReusableCellWithIdentifier:self.cellClass];
    
    //取数据源
    if (self.dataArray.count <= indexPath.section) {
        return cell;
    }
    
    NSArray *sectionArr = [self.dataArray objectAtIndex:indexPath.section];
    
    if (sectionArr.count <= indexPath.row) {
        return cell;
    }
    
    StaticCellModel *model = [sectionArr objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    if (indexPath.row == sectionArr.count -1) {
        //最后一行 sep处理
        [cell setSepViewStyle:self.sepStyle];
    }else{
        //非最后一行
        [cell setSepViewStyle:SepViewStyleCommon];
    }
    
    __weak typeof(self) weakSelf = self;
    cell.callBack = ^(NSInteger event,BaseModel *model){
        if (weakSelf.tableViewCellEventCall) {
            weakSelf.tableViewCellEventCall(event,model);
        }
    };
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    Class cellClass = NSClassFromString(self.cellClass);
//    
//    if (cellClass == NULL) {
//        cellClass = [BaseStaticCell class];
//    }
    BaseStaticCell *cell = [self dequeueReusableCellWithIdentifier:self.cellClass];
    //取数据源
    if (self.dataArray.count <= indexPath.section) {
        return 0;
    }
    
    NSArray *sectionArr = [self.dataArray objectAtIndex:indexPath.section];
    
    if (sectionArr.count <= indexPath.row) {
        return 0;
    }
    
    return [cell getCellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取数据源
    if (self.dataArray.count <= indexPath.section) {
        return;
    }
    
    NSArray *sectionArr = [self.dataArray objectAtIndex:indexPath.section];
    
    if (sectionArr.count <= indexPath.row) {
        return;
    }
    
    NSArray *foreSectionArr = indexPath.section <= 0?nil:[self.dataArray objectAtIndex:indexPath.section-1];
    NSInteger foreIndex = !foreSectionArr?0:foreSectionArr.count;
    
    if (self.tableViewDidClicked) {
        self.tableViewDidClicked(indexPath.row+foreIndex);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.dataArray.count == 1) {
        return 0.01;
    }
    
    //TODO: section custom height
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count == 1) {
        return 0.01;
    }
    
    //: setion custom height
    return 7;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


@end
