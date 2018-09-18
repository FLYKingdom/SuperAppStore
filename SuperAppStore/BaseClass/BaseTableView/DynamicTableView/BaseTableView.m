//
//  BaseTableView.m
//  ifly
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseTableView.h"
#import "BaseTableViewCell.h"
#import "RefreshHeader.h"
#import "RefreshFooter.h"
#import "HexColor.h"

@interface BaseTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *emptyView;

//data
@property (nonatomic, assign) BOOL isEnd;//是否加载到底部了

@property (nonatomic, assign) BOOL editable;//是否可以编辑

@property (nonatomic, assign) CGFloat lastOffset;

@property (nonatomic, assign) BOOL isDownward;//是否是下拉

@end

@implementation BaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)emptyView {
    
    if (!_emptyView) {
        if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(setCustomEmptyView:)]) {
            _emptyView = [self.customDelegate setCustomEmptyView:self];
        }else{
            CGFloat topY = CGRectGetHeight(self.frame) /3 -64;
            UIView *emptyView = [[UIView alloc] init];
            
            UIImage *tipIcon = [UIImage imageNamed:@"nonResult"];
            UIImageView *prompt = [[UIImageView alloc] initWithImage:tipIcon];
            [emptyView addSubview:prompt];
            [prompt setFrame:CGRectMake((kDeviceWidth - tipIcon.size.width)*0.5, 0, tipIcon.size.width, tipIcon.size.height)];
            
            UILabel *promptTitle = [[UILabel alloc] init];
            [promptTitle setText:@"暂无读书记录"];
            [promptTitle setFont:[UIFont systemFontOfSize:14]];
            [promptTitle setTextColor:[HexColor colorWithHexString:@"999999"]];
            promptTitle.textAlignment = NSTextAlignmentCenter;
            [emptyView addSubview:promptTitle];
            [promptTitle setFrame:CGRectMake(0, CGRectGetMaxY(prompt.frame)+10, kDeviceWidth, 14)];
            [emptyView setFrame:CGRectMake(0, topY, kDeviceWidth, CGRectGetMaxY(promptTitle.frame))];
            _emptyView = emptyView;
        }
        
    }
    
    return _emptyView;
}

#pragma mark - class method

+(NSMutableArray *)getDateMatrixWithArr:(NSArray *)dataArr{
    if (dataArr.count == 0) {
        return nil;
    }
    
    NSMutableArray *sectionArr = [NSMutableArray arrayWithArray:dataArr];
    NSMutableArray *matrix = [NSMutableArray arrayWithObjects:sectionArr, nil];

    return matrix;
}

#pragma mark - set method

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    [self reloadData];
    
}

- (void)setShowRefreshHeader:(BOOL)showRefreshHeader
{
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            __weak typeof(self) weakSelf = self;
            self.mj_header = [RefreshHeader headerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerHeaderRefresh];
            }];
        }
        else{
        }
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter
{
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            __weak typeof(self) weakSelf = self;
            RefreshFooter *footer = [RefreshFooter footerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerFooterRefresh];
            }];
            
            // 设置footer
            self.mj_footer = footer;
            
        }
        else{
            [self.mj_footer setHidden:YES];
        }
    }
}

-(void)setCellClass:(NSString *)cellClass{
    _cellClass = cellClass;
    
    [self registerClass:NSClassFromString(cellClass) forCellReuseIdentifier:cellClass];
    
    [self reloadData];
}

#pragma mark - initial method

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellClass:(NSString *)cellClass editable:(BOOL)editable{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self setBackgroundColor:DefaultBGColor];
//        NSLog(@"class = %@",NSClassFromString(cellClass));
        [self registerClass:NSClassFromString(cellClass) forCellReuseIdentifier:cellClass];
        self.cellClass = cellClass;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.currentPage = 0;
        self.isEnd = NO;
        
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        
        self.editable = editable;
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style cellClass:(NSString *)cellClass{
    return [self initWithFrame:frame style:style cellClass:cellClass editable:NO];
}

#pragma mark - sub method

- (void)tableViewDidTriggerHeaderRefresh
{
    __weak typeof(self) weakSelf = self;
    if (!self.enableNonHeaderResfreshData) {
        weakSelf.currentPage = 1;
        weakSelf.isEnd = NO;
        [weakSelf.dataArray removeAllObjects];
    }
    
    //清空底部tableview nomore data view and cancel footer hidden state
    if (self.showRefreshFooter) {
        
        [self.mj_footer setHidden:NO];
        [self.mj_footer resetNoMoreData];
    }
    
    if (weakSelf.tableViewDidTriggerRefresh) {
        BOOL stopLoading = weakSelf.tableViewDidTriggerRefresh(TableViewRefreshTypeHeader);
        
        if (stopLoading) {
            [weakSelf.mj_header endRefreshing];
        }
    }
}

- (void)tableViewDidTriggerFooterRefresh
{
    __weak typeof(self) weakSelf = self;
    if (!weakSelf.isEnd){//weakSelf.dataArray.count>=PerPageCount*weakSelf.currentPage) {
        weakSelf.currentPage++;
        if (weakSelf.tableViewDidTriggerRefresh) {
            BOOL stopLoading = weakSelf.tableViewDidTriggerRefresh(TableViewRefreshTypeFooter);
            if (stopLoading) {
                [weakSelf.mj_footer endRefreshing];
            }
        }
    }else{//修改样式 已经到底呀
        [weakSelf tableViewDidFinishTriggerHeader:NO reload:NO isRest:NO];
    }
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
//        cellClass = [BaseTableViewCell class];
//    }
    
    BaseTableViewCell *cell = [self dequeueReusableCellWithIdentifier:self.cellClass];
    
    //取数据源
    if (self.dataArray.count <= indexPath.section) {
        return cell;
    }
    
    NSArray *sectionArr = [self.dataArray objectAtIndex:indexPath.section];
    
    if (sectionArr.count <= indexPath.row) {
        return cell;
    }
    
    BaseModel *model = [sectionArr objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    __weak typeof(self) weakSelf = self;
    cell.callBack = ^(NSInteger event,BaseModel *model){
        if (weakSelf.tableViewCellEventCall) {
            weakSelf.tableViewCellEventCall(event,model);
        }
    };
    
    if (indexPath.row == sectionArr.count - 1) {
        [cell.sepView setHidden:YES];
    }else{
        [cell.sepView setHidden:NO];
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    Class cellClass = NSClassFromString(self.cellClass);
//    
//    if (cellClass == NULL) {
//        cellClass = [BaseTableViewCell class];
//    }
    BaseTableViewCell *cell = [self dequeueReusableCellWithIdentifier:self.cellClass];
    //取数据源
    if (self.dataArray.count <= indexPath.section) {
        return 0;
    }
    
    NSArray *sectionArr = [self.dataArray objectAtIndex:indexPath.section];
    
    if (sectionArr.count <= indexPath.row) {
        return 0;
    }
    
    BaseModel *model = [sectionArr objectAtIndex:indexPath.row];
    
    return [cell getCellHeightWithModel:model];
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
    
    BaseModel *model = [sectionArr objectAtIndex:indexPath.row];
    
    if (self.tableViewDidClicked) {
        self.tableViewDidClicked(model.infoID,model);
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
    
    //TODO: setion custom height
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.editable;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
{
    return  UITableViewCellEditingStyleDelete;  //返回此值时,Cell会做出响应显示Delete按键,点击Delete后会调用下面的函数,别给传递
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //取数据源
        if (self.dataArray.count <= indexPath.section) {
            return;
        }
        
        NSMutableArray *sectionArr = [self.dataArray objectAtIndex:indexPath.section];
        
        if (sectionArr.count <= indexPath.row) {
            return;
        }
        
        BaseModel *model = [sectionArr objectAtIndex:indexPath.row];
        
        
        if (self.tableViewDidDelete) {
            self.tableViewDidDelete(model.infoID);
        }
        
        [sectionArr removeObjectAtIndex:indexPath.row];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (sectionArr.count == 0) {
            [self.dataArray removeObject:sectionArr];
            [self showResult:ADD_RECORD_BY_RELOAD];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.tableViewDidScroll) {
        self.tableViewDidScroll(scrollView);
    }
    
//    CGFloat offsetY = scrollView.contentOffset.y;
//
//    if (self.lastOffset < offsetY) {
//        //向下
//        self.isDownward = YES;
//        NSLog(@"downward ");
//    }else{
//        //向上
//        self.isDownward = NO;
//        NSLog(@"upward ");
//    }
//
//    self.lastOffset = offsetY;
}

//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if (self.tableViewDidScroll) {
//        if (self.contentOffset.y == 0 && self.isDownward) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }
//    return YES;
//}

#pragma mark - data deal with

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload isRest:(BOOL)isRest
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (isHeader) {
            [weakSelf.mj_header endRefreshing];
        }
        else{
            [weakSelf.mj_footer endRefreshing];
            
            if (!isRest) {
                
                [self.mj_footer endRefreshingWithNoMoreData];
                
                if (CGRectGetMaxY(self.mj_footer.frame)<CGRectGetHeight(self.frame)) {
                    [self.mj_footer setHidden:YES];
                }
                
            }
        }
        
        if (reload) {
            [weakSelf reloadData];
        }
    });
}

- (void)showResult:(AddRecordType) type{
    __weak typeof(self) weakSelf = self;
    
    if (!weakSelf.dataArray || [weakSelf.dataArray count] == 0) {
        //展示空页面
        [self addSubview:self.emptyView];
    }else{
        [weakSelf.emptyView removeFromSuperview];
    }
    
    [weakSelf reloadData];
    if (type == ADD_RECORD_BY_INIT) {
        if (weakSelf.tableViewDidTriggerRefresh) {
            BOOL stopLoading = weakSelf.tableViewDidTriggerRefresh(TableViewRefreshTypeLoading);
            if (stopLoading) {
                //nothing
            }
        }
    }else if(type == ADD_RECORD_BY_INSERT){
        [weakSelf tableViewDidFinishTriggerHeader:NO reload:NO isRest:YES];
    }else{
        [weakSelf tableViewDidFinishTriggerHeader:YES reload:NO isRest:YES];
    }
}

#pragma mark - insert new data

/**
 *底部插入数据，更新TableView
 */
-(void)insertRowAtBottom:(NSArray *) appendArr{
    NSMutableArray *newDatas = [NSMutableArray arrayWithArray:appendArr];
    
    __weak typeof(self) weakSelf = self;
    if (newDatas.count == 0) {
        self.isEnd = YES;
        [self tableViewDidFinishTriggerHeader:NO reload:NO isRest:NO];
    }else{
        [self tableViewDidFinishTriggerHeader:NO reload:NO isRest:YES];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //取数据源
        if (weakSelf.dataArray.count == 0) {
            return ;
        }
        
        NSArray *sectionArr = [weakSelf.dataArray lastObject];
        NSInteger beginIndex = sectionArr.count;//计算首个要插入的位置
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:sectionArr];
        
        //获取要插入的位置IndexPath
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (int i=0; i<newDatas.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:beginIndex+i inSection:weakSelf.dataArray.count-1];
            [indexPaths addObject: indexPath];
            id tmpObj = [newDatas objectAtIndex:i];
            [tmpArr addObject:tmpObj];
        }
        [weakSelf beginUpdates];
        [weakSelf.dataArray replaceObjectAtIndex:weakSelf.dataArray.count - 1 withObject:tmpArr];
        [weakSelf insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        
        [weakSelf endUpdates];
    });
}

@end
