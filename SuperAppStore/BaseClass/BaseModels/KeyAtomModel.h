//
//  KeyAtomModel.h
//  ifly
//
//  Created by mac on 17/5/19.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseModel.h"
#import "AtomModel.h"

//AtomModel value type 

@interface KeyAtomModel : BaseModel

@property (nonatomic, assign) NSInteger atomCount;//原子model 属性个数

-(instancetype)initWithDictionary:(NSDictionary *)dict;

#pragma mark - sub method inherit method
- (NSDictionary *)getTitleDict;

- (NSDictionary *)getClassDict;

//获取要展示key数组
+(NSArray *) fetchDisplayKeyArr;

@end
