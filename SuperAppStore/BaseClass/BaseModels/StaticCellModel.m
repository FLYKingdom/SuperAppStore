//
//  StaticCellModel.m
//  ifly
//
//  Created by mac on 2017/7/3.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "StaticCellModel.h"

@implementation StaticCellModel

//字典转模型
+(instancetype)modelWithDictionary:(NSDictionary *)dict
{
    StaticCellModel *model = [[StaticCellModel  alloc] init];
    
    NSArray *array = [model getProperties];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        NSString *key = obj;
        id value = [dict objectForKey:key];
        if (value) {
            [model setValue:value forKey:key];
        }
    }];
    
    return model;
}

+(instancetype)modelWithTipStr:(NSString *)tipStr iconPath:(NSString *)iconPath{
    NSDictionary *tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:tipStr,@"tipStr",iconPath,@"iconPath", nil];
    return [self modelWithDictionary:tmpDict];
}

@end
