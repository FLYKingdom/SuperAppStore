//
//  CustomDisplayView.h
//  ifly
//
//  Created by mac on 2017/7/16.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayAtomModel.h"

@interface CustomDisplayView : UIView

@property (nonatomic, strong) DisplayAtomModel *displayModel;

//to inherit or rewrite method
- (void)setUpUIWithAlignment:(NSTextAlignment) alignment;

-(void) setDisplay:(DisplayAtomModel *) displayModel value:(id) value;

-(CGFloat) getViewMaxHeight:(DisplayAtomModel *) displayModel value:(id) value;

- (instancetype)initWithFrame:(CGRect)frame alignment:(NSTextAlignment) alignment;

@end
