//
//  DisplayAtomModel.h
//  ifly
//
//  Created by mac on 2017/7/13.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseModel.h"

typedef enum : NSUInteger {
    DisplayStyleCommonLab,
    DisplayStyleErrorLab,
    DisplayStyleCustomView,
} DisplayStyle;

@interface DisplayAtomModel : BaseModel

@property (nonatomic, copy) NSString *tipStr;

@property (nonatomic, copy) NSString *key;

/**
 展示方式
 */
@property (nonatomic, assign) DisplayStyle style;

/**
 是否 必须展示
 */
@property (nonatomic, assign) BOOL isNecessary;

/**
 alignment
 */
@property (nonatomic, assign) NSTextAlignment valueAlignment;

@property (nonatomic, copy) NSString *valueViewClass;

@end
