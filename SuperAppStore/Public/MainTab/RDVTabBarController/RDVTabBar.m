// RDVTabBar.m
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

#import "RDVTabBar.h"
#import "RDVTabBarItem.h"
#import "RDVTabBarCenterItem.h"
@interface RDVTabBar ()

@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic,assign) BOOL hasCenterButton;
@end

@implementation RDVTabBar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    _backgroundView = [[UIView alloc] init];
    [self addSubview:_backgroundView];
    
    [self setTranslucent:NO];
}


- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = [self minimumContentHeight];
    
    [[self backgroundView] setFrame:CGRectMake(0, frameSize.height - minimumContentHeight,
                                               frameSize.width, frameSize.height)];
    
    // Layout items
    UIView *seperatorView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frameSize.width, 0.75f)];
    seperatorView.backgroundColor=SeperatorColor;
    [self insertSubview:seperatorView atIndex:1];
    NSInteger index = 0;
    
    if (self.hasCenterButton) {
        int centerButtonWidth=frameSize.width/5-11;
        if (IPHONE_6_OR_LARGER) {
            centerButtonWidth-=14;
        }
        //设置每个tab的宽度
        [self setItemWidth:roundf(((frameSize.width - [self contentEdgeInsets].left -
                                    [self contentEdgeInsets].right)-centerButtonWidth) / [[self items] count])];
        
        
        //NSArray *colors=@[[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor blackColor]];
        for (RDVTabBarItem *item in [self items]) {
            CGFloat itemHeight = [item itemHeight];
            if (!itemHeight) {
                itemHeight = frameSize.height;
            }
            
            float offsexX=0.0f;
            if (index>=self.items.count/2) {
                offsexX=centerButtonWidth;
            }
            
            [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth)+offsexX,
                                      roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top,
                                      self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
            
            //item.backgroundColor=[colors objectAtIndex:index];
            [item setNeedsDisplay];
            index++;
        }
        //设置中间按钮
        CGRect centerButtonRect=CGRectMake((frameSize.width- [self contentEdgeInsets].left -
                                            [self contentEdgeInsets].right-centerButtonWidth)/2, frameSize.height-self.contentEdgeInsets.bottom-centerButtonWidth-4, centerButtonWidth, centerButtonWidth);
        [self.centerItem setFrame:centerButtonRect];
        CALayer *layer= [self.centerItem layer];
        [layer setShadowOffset:CGSizeMake(0, 1)];
        [layer setShadowRadius:2.4];
        [layer setShadowOpacity:0.4];
        [layer setShadowColor:[UIColor colorWithWhite:0.1f alpha:0.7f].CGColor];
        
        
        self.centerItem.backgroundColor=[UIColor clearColor];
        [self.centerItem setNeedsDisplay];
        
        
    }else{
        //设置每个tab的宽度
        [self setItemWidth:roundf((frameSize.width - [self contentEdgeInsets].left -
                                   [self contentEdgeInsets].right) / [[self items] count])];
        
        for (RDVTabBarItem *item in [self items]) {
            CGFloat itemHeight = [item itemHeight];
            
            if (!itemHeight) {
                itemHeight = frameSize.height;
            }
            
            [item setFrame:CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth),
                                      roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top,
                                      self.itemWidth, itemHeight - self.contentEdgeInsets.bottom)];
            [item setNeedsDisplay];
            
            index++;
        }
        
    }
}

#pragma mark - Configuration

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    for (RDVTabBarItem *item in items) {
        [item removeFromSuperview];
    }
    
    _items = [items copy];
    for (RDVTabBarItem *item in items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}


-(void) addCenterButton : (RDVTabBarCenterItem *) centerItem{
    self.hasCenterButton=YES;
    if (self.centerItem) {
        [self.centerItem removeFromSuperview];
    }
    
    self.centerItem=centerItem;
    [self.centerItem addTarget:self action:@selector(tabBarCenterWasTaped) forControlEvents:UIControlEventTouchDown];
    [self insertSubview:self.centerItem atIndex:1000];
    
}


- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame), height)];
}

- (CGFloat)minimumContentHeight {
    CGFloat minimumTabBarContentHeight = CGRectGetHeight([self frame]);
    
    for (RDVTabBarItem *item in [self items]) {
        CGFloat itemHeight = [item itemHeight];
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            minimumTabBarContentHeight = itemHeight;
        }
    }
    
    return minimumTabBarContentHeight;
}

#pragma mark - Item selection

- (void)tabBarItemWasSelected:(id)sender {
    if ([[self delegate] respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![[self delegate] tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    [self setSelectedItem:sender];
    
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [[self delegate] tabBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(RDVTabBarItem *)selectedItem {
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

-(void) tabBarCenterWasTaped{
    if ([[self delegate] respondsToSelector:@selector(tapCenterButton)]) {
        [[self delegate] tapCenterButton];
    }
    [self.centerItem setSelected:YES];
}



#pragma mark - Translucency

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    //CGFloat alpha = (translucent ? 0.95 : 1.0);
    //设置底大杠颜色
    [_backgroundView setBackgroundColor:DefaultBGColor];
    
}

@end
