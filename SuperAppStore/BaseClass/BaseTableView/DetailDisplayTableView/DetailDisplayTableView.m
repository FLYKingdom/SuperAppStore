//
//  DetailDisplayTableView.m
//  ifly
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "DetailDisplayTableView.h"

@interface DetailDisplayTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) SepViewStyle sepStyle;

@property (nonatomic, copy) NSString *cellClass;

@end

@implementation DetailDisplayTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setTipModelArr:(NSArray *)tipModelArr{
    _tipModelArr = tipModelArr;
    
    [self reloadData];
}

-(void)setDetailInfoWithDict:(id)detailInfo{
    
    for (DisplayAtomModel *model in self.tipModelArr) {
        id value = [detailInfo valueForKey:model.key];
        
        if ([self isEmptyValue:value isNecessary:model.isNecessary]){
        }else{
            [self.detailDict setObject:value forKey:model.key];
        }
    }
    
    [self reloadData];
}

- (BOOL)isEmptyValue:(id) value isNecessary:(BOOL) isNecessary{
    if(isNecessary){
        return NO;
    }else  if (!value) {
        return YES;
    }else if([value isKindOfClass:[NSString class]] && [value isEqualToString:@""]){
        return YES;
    }
    
    return NO;
}

//-(void)setDetailDict:(NSMutableDictionary *)detailDict{
//    _detailDict = detailDict;
//    
//    [self reloadData];
//    
//}

#pragma mark - init method

-(instancetype)initWithFrame:(CGRect)frame tipModelArr:(NSArray *)tipModelArr sepViewStyle:(SepViewStyle)sepStyle{
    return [self initWithFrame:frame tipModelArr:tipModelArr cellClass:@"DetailDisplayCell" sepViewStyle:sepStyle];
}

-(instancetype)initWithFrame:(CGRect)frame tipModelArr:(NSArray *)tipModelArr cellClass:(NSString *)cellClass sepViewStyle:(SepViewStyle)sepStyle{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self setBackgroundColor:DefaultBGColor];
        self.cellClass = cellClass;
        _sepStyle = sepStyle;
        self.tipModelArr = tipModelArr;
        
        self.detailDict = [NSMutableDictionary dictionaryWithCapacity:tipModelArr.count];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

#pragma mark - datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        DetailDisplayTableView *tmpTableView = (DetailDisplayTableView *)tableView;
        return [self.displayDelegate numberOfSectionsInTableView:tmpTableView];
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        DetailDisplayTableView *tmpTableView = (DetailDisplayTableView *)tableView;
        return [self.displayDelegate numberOfSectionsInTableView:tmpTableView];
    }
    return self.detailDict?self.detailDict.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
        DetailDisplayTableView *tmpTableView = (DetailDisplayTableView *)tableView;
        return [self.displayDelegate tableView:tmpTableView cellForRowAtIndexPath:indexPath];
    }
    
    Class myClass = NSClassFromString(self.cellClass);
    
    if (indexPath.row >= self.tipModelArr.count) {
        return [UITableViewCell new];
    }
    DisplayAtomModel *atomModel = [self.tipModelArr objectAtIndex:indexPath.row];
    
    DetailDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:atomModel.key];
    if (!cell) {
        cell = [[myClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:atomModel.key];
    }
    
    //取value
    id valueStr;
    if (atomModel.key && self.detailDict) {
        valueStr = [self.detailDict objectForKey:atomModel.key];
    }else{
        valueStr = @"";
    }
    
    if (!valueStr) {
        valueStr = @"";
    }
    
//    if ([valueStr isKindOfClass:[NSArray class]]) {
//        NSArray *tmpArr = (NSArray *) valueStr;
//        NSString *tmpStr = @"";
//        for (NSDictionary *dict in tmpArr) {
//            tmpStr = [tmpStr stringByAppendingString:dict[@"goodsName"]];
//        }
//        valueStr = nil;
//        valueStr = tmpStr;
//    }

    [cell setTip:atomModel value:valueStr];
    
    if (indexPath.row == self.detailDict.count -1) {
        //最后一行 sep处理
        [cell setSepStyle:SepViewStyleFullLine];
    }else{
        //非最后一行
        [cell setSepStyle:self.sepStyle];
    }
    
    return cell;
}

#pragma mark - delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        DetailDisplayTableView *tmpTableView = (DetailDisplayTableView *)tableView;
        return [self.displayDelegate tableView:tmpTableView heightForRowAtIndexPath:indexPath];
    }
    Class myClass = NSClassFromString(self.cellClass);
    
    if (indexPath.row >= self.tipModelArr.count) {
        return 0.01;
    }
    DisplayAtomModel *atomModel = [self.tipModelArr objectAtIndex:indexPath.row];
    
    DetailDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:atomModel.key];
    if (!cell) {
        cell = [[myClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:atomModel.key];
    }
    
    //取value
    id valueStr;
    if (atomModel.key && self.detailDict) {
        valueStr = [self.detailDict objectForKey:atomModel.key];
    }else{
        valueStr = @"";
    }
    
    if (!valueStr) {
        valueStr = @"";
    }
    
//    if ([valueStr isKindOfClass:[NSArray class]]) {
//        NSArray *tmpArr = (NSArray *) valueStr;
//        NSString *tmpStr = @"";
//        for (NSDictionary *dict in tmpArr) {
//            tmpStr = [tmpStr stringByAppendingString:dict[@"goodsName"]];
//        }
//        valueStr = nil;
//        valueStr = tmpStr;
//    }

    if (indexPath.row == self.detailDict.count -1) {
        //最后一行 sep处理
        [cell setSepStyle:SepViewStyleFullLine];
    }else{
        //非最后一行
        [cell setSepStyle:self.sepStyle];
    }
    
    return [cell getCellHeight:atomModel value:valueStr];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        DetailDisplayTableView *tmpTableView = (DetailDisplayTableView *)tableView;
        return [self.displayDelegate tableView:tmpTableView heightForHeaderInSection:section];
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        DetailDisplayTableView *tmpTableView = (DetailDisplayTableView *)tableView;
        return [self.displayDelegate tableView:tmpTableView heightForFooterInSection:section];
    }
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        DetailDisplayTableView *tmpTableView = (DetailDisplayTableView *)tableView;
        return [self.displayDelegate tableView:tmpTableView viewForHeaderInSection:section];
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        DetailDisplayTableView *tmpTableView = (DetailDisplayTableView *)tableView;
        return [self.displayDelegate tableView:tmpTableView viewForFooterInSection:section];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        DetailDisplayTableView *tmpTableView = (DetailDisplayTableView *)tableView;
        return [self.displayDelegate tableView:tmpTableView didSelectRowAtIndexPath:indexPath];
    }
    
}

@end
