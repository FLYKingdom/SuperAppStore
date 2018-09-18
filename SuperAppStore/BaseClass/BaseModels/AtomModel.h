//
//  AtomModel.h
//  ifly
//
//  Created by mac on 17/5/19.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface AtomModel : BaseModel

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) NSString *displayKey;

@property (nonatomic, copy) NSString *displayValue;

@property (nonatomic, copy) NSString *cellClass;//展示cell的calss 暂未使用

//+(instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
