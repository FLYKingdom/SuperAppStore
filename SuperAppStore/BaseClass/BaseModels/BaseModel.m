//
//  BaseTableModel.m
//  ifly
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)encodeWithCoder:(NSCoder *)coder {
    
    NSArray *array = [self getProperties];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        NSString *key = obj;
        id value = [self valueForKey:key];
        if (value) {
            [coder encodeObject:[self valueForKey:key] forKey:key];
        }
    }];
    
}
- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        NSArray *array = [self getProperties];
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //
            NSString *key = obj;
            id value = [coder decodeObjectForKey:key];
            if (value) {
                [self setValue:value forKey:key];
            }
        }];
        
        
    }
    return self;
}
-(NSString *)description{
    
    NSArray *keys = [self getProperties];
    return [self dictionaryWithValuesForKeys:keys].description;
}

//字典转模型
+(instancetype)modelWithDictionary:(NSDictionary *)dict
{
    BaseModel *model = [[BaseModel  alloc] init];
    
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

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        NSArray *array = [self getProperties];
        
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *key = obj;
            id value = [dict objectForKey:key];
            if (value && ![value isKindOfClass:[NSNull class]]) {
                [self setValue:value forKey:key];
            }
        }];
        NSNumber *idNumerber = [dict objectForKey:@"id"];
        self.infoID = idNumerber?[idNumerber integerValue]:0;
    }
    
    return self;
}

//获取所有属性值
- (NSArray *)getProperties
{
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i =0; i< count ; i++) {
        
        objc_property_t pro = properties[i];
        
        const char *nameP = property_getName(pro);
        
        NSString *property = [[NSString alloc] initWithUTF8String:nameP];
        
        [array addObject:property];
    }
    free(properties);
    [array addObject:@"infoID"];
    return array;
}

-(NSMutableDictionary *)translateIntoDict{
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    
    NSArray *array = [self getProperties];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //
        NSString *key = obj;
        id value = [self valueForKey:key];
        if (value) {
            [infoDict setObject:value forKey:key];
        }
    }];
    
    return infoDict;
}

+(NSString *)formatImgUrl:(NSString *)imgUrl size:(CGSize)size{
    NSString *finalImgStr = imgUrl;
    if (![finalImgStr containsString:@"."]) {
        NSString *md5 = finalImgStr;
        CGFloat scale = [UIScreen mainScreen].scale;
        finalImgStr = [NSString stringWithFormat:@"%@%@_w%dh%d.jpg",ImageURLString,md5,(int)(scale*size.width),(int)(scale*size.height)];
    }
    
    return finalImgStr;
    
}

+(NSString *)formatTime:(NSInteger)timeValue{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateFormat:@"dd-hh-mm-ss"];
    
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeValue]];
    
}

@end
