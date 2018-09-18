//
//  StaticCellModel.h
//  ifly
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface StaticCellModel : BaseModel

@property (nonatomic, copy) NSString *iconPath;

@property (nonatomic, copy) NSString *tipStr;

+(instancetype) modelWithTipStr:(NSString *)tipStr iconPath:(NSString *) iconPath;

@end
