//
//  TabListView.m
//  ifly
//
//  Created by mac on 17/5/18.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "TabListView.h"
#import "Masonry.h"

@interface TabListView ()<UIScrollViewDelegate>

//data
@property (nonatomic, strong) NSMutableArray *subListViews;

@property (nonatomic, strong) NSMutableArray *subTitleViews;

@property (nonatomic, assign) NSInteger currentTag;

@property (nonatomic, assign) CGFloat tmpOffsetX;

//view
@property (nonatomic, strong) UIScrollView *titleView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIScrollView *mainView;

@end

@implementation TabListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setCurrentTag:(NSInteger)currentTag{
    if (_currentTag == currentTag) {
        return;
    }
    _currentTag = currentTag;
    
    if (self.subTitleViews.count <= currentTag) {
        return;
    }
    //set style
    int index = 0;
    for (UILabel *titleLab in self.subTitleViews) {
        if (titleLab && [titleLab isKindOfClass:[UILabel class]]) {
            BOOL isSelected = index == currentTag;
            NSString *title = titleLab.attributedText.string;
            titleLab.attributedText = [self formatDiplayStr:title isSelected:isSelected];
        }
        index ++;
    }

}

#pragma mark - lazy load

-(NSMutableArray *)subTitleViews{
    if (!_subTitleViews) {
        _subTitleViews = [NSMutableArray array];
    }
    return _subTitleViews;
}

-(NSMutableArray *)subListViews{
    if (!_subListViews) {
        _subListViews = [NSMutableArray array];
    }
    return _subListViews;
}

#pragma mark -  initial method and ui

-(instancetype)initSubListArr:(NSArray *)subListArr tiltles:(NSArray *)titles frame:(CGRect) frame{
//    CGRect frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight -64);
    self = [super initWithFrame:frame];
    if (self) {
        self.currentTag = 0;

        [self setupUI:subListArr tiltles:titles];
    }
    return self;
}

- (void)setupUI:(NSArray *)subListArr tiltles:(NSArray *)titles {
    
    CGFloat titleH = 52.5;
    CGFloat tabW = CGRectGetWidth(self.frame);
    CGFloat tabH = CGRectGetHeight(self.frame);
    CGFloat titleW = tabW/(titles.count);
    
    UIScrollView *titleView = [[UIScrollView alloc] init];
    self.titleView = titleView;
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:titleView];
    [titleView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(titleH);
    }];
    CGFloat indicatorWidth=titleW/2;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((titleW-indicatorWidth)/2, titleH - 3, indicatorWidth, 3)];
    self.lineView = lineView;
    [lineView setBackgroundColor:DefaultMainColor];
    [self addSubview:lineView];
    
    UIScrollView *mainView = [[UIScrollView alloc] init];
    self.mainView = mainView;
    mainView.delegate = self;
    mainView.scrollEnabled = YES;
    mainView.pagingEnabled = YES;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    [mainView setContentSize:CGSizeMake(tabW * titles.count, 0)];
    [self addSubview:mainView];
    [mainView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(titleView.bottom).offset(7);
    }];
    
    if (subListArr.count <= 0 || titles.count <= 0) {
        return;
    }
    
    int index = 0;
    CGFloat startX = 0;
    for (UIView *subList in subListArr) {
        NSString *title = [titles objectAtIndex:index];
        
        // add title label
        UILabel *titleLab = [[UILabel alloc] init];
        [titleLab setTextAlignment:NSTextAlignmentCenter];
        [titleLab setTag:index];
        [titleLab setNumberOfLines:0];
        BOOL isSelected = self.currentTag == index;
        titleLab.attributedText = [self formatDiplayStr:title isSelected:isSelected];
        [self.titleView addSubview:titleLab];
        [self.subTitleViews addObject:titleLab];
        [titleLab setFrame:CGRectMake(startX, 0, titleW, 54)];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        gesture.accessibilityFrame = CGRectMake(startX, 0, titleW, titleH);
        [titleLab setUserInteractionEnabled:YES];
        [titleLab addGestureRecognizer:gesture];
        
        
        // add main view
        [self.mainView addSubview:subList];
        [subList setFrame:CGRectMake(index * tabW, 0, tabW, tabH - titleH -7 )];
//        [subList makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mainView.top);
//            make.bottom.equalTo(self.mainView.bottom);
//        }];
        
        [self.subListViews addObject:subList];
        
        startX += titleW;
        index ++;
    }
    
}

#pragma mark - event

- (void)viewTapped:(UITapGestureRecognizer *) gesture {
    NSInteger tag = gesture.view.tag;
    
    // scroll to tag view
    CGFloat tabW = CGRectGetWidth(self.frame);
    [self.mainView setContentOffset:CGPointMake(tag * tabW, 0) animated:YES];
    
//    CGFloat titleW = tabW/self.subTitleViews.count;
//    CGFloat offset = (tag - self.currentTag)*titleW;
    
//    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
//        [UIView animateWithDuration:0.5
//                              delay:0.0f
//             usingSpringWithDamping:2.3
//              initialSpringVelocity:4
//                            options:UIViewAnimationOptionAllowAnimatedContent
//                         animations:^{
//                            self.lineView.transform = CGAffineTransformTranslate(self.lineView.transform, 0, 0);
//                         }
//                         completion:^(BOOL finished) {
//                             self.currentTag = tag;
//                         }];
//    }else{
//        [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
//           self.lineView.transform = CGAffineTransformTranslate(self.lineView.transform, 0, 0);
//        } completion:^(BOOL finished) {
//            self.currentTag = tag;
//        }];
//    }
    self.lineView.transform = CGAffineTransformTranslate(self.lineView.transform, 0, 0);
}

#pragma mark - Scroll View Delegate Methods
#pragma mark -
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat tabW = CGRectGetWidth(self.frame);
    NSInteger currentIndex = scrollView.contentOffset.x / tabW;
    // select target index
    self.currentTag = currentIndex;
    
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat offset = offsetX - self.tmpOffsetX;
    
    CGFloat tabW = CGRectGetWidth(self.frame);
    CGFloat titleW = tabW/self.subTitleViews.count;
    
    CGFloat lineOffset = titleW / kDeviceWidth  * offset;
    
//    CGRect tmpFrame = self.lineView.frame;
//    [self.lineView setFrame:CGRectMake(CGRectGetMinX(tmpFrame) + lineOffset, CGRectGetMinY(tmpFrame), CGRectGetWidth(tmpFrame), CGRectGetHeight(tmpFrame))];
    self.lineView.transform = CGAffineTransformTranslate(self.lineView.transform, lineOffset, 0);
    self.tmpOffsetX = offsetX;
}

#pragma mark - sub method

- (NSAttributedString *) formatDiplayStr:(NSString *) title isSelected:(BOOL) isSelected{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSRange firstR;
    NSRange secondR;
    
    if(title.length>2){
        firstR=NSMakeRange(0, title.length-2);
        secondR=NSMakeRange(title.length-2,2);
    }else{
        firstR=NSMakeRange(0, title.length);
        secondR=NSMakeRange(0, title.length);
    }

    
    
    UIColor *textColor = isSelected?DefaultMainColor:LightFontColor;
    NSDictionary *attributDict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:PrompFontSize],NSFontAttributeName, textColor,NSForegroundColorAttributeName,nil];
    [attributedStr addAttributes:attributDict1 range:secondR];
    
    NSDictionary *attributDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:TitleFontSize],NSFontAttributeName,textColor,NSForegroundColorAttributeName,nil];
    [attributedStr addAttributes:attributDict range:firstR];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.paragraphSpacing = 3.5;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributedStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:paragraph,NSParagraphStyleAttributeName, nil] range:NSMakeRange(0, title.length)];
    
    return attributedStr.copy;
}

#pragma mark - public method

-(void)updateTitle:(NSString *)title tag:(NSInteger)tag{
    
    if (self.subTitleViews.count <= tag) {
        return;
    }
    
    UILabel *titleLab = [self.subTitleViews objectAtIndex:tag];
    if (titleLab && [titleLab isKindOfClass:[UILabel class]]) {
        BOOL isSelected = self.currentTag == tag;
        titleLab.attributedText = [self formatDiplayStr:title isSelected:isSelected];
    }
}

@end
