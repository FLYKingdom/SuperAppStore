//
//  KeyAtomModel.m
//  ifly
//
//  Created by mac on 17/5/19.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "KeyAtomModel.h"

@implementation KeyAtomModel

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (!self) {
        return self;
    }
    
    NSDictionary *titleDict = [self getTitleDict];
    NSDictionary *classDict = [self getClassDict];
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    
    for (int i =0; i< count ; i++) {
        
        objc_property_t pro = properties[i];
        
        const char *nameP = property_getName(pro);
        
        NSString *property = [[NSString alloc] initWithUTF8String:nameP];
        
        //
        NSString *key = property;
        id value = [dict objectForKey:key];
        if (value) {
            
            const char *classP = property_getAttributes(pro);
            NSString *propertyClass = [[NSString alloc] initWithUTF8String:classP];
            //TODO: 需要直接取 类型 以防包涵AtomModel属性名的可能
//            NSLog(@"class = %@",propertyClass);
            if ([propertyClass containsString:@"T@\"AtomModel\""]) {
                AtomModel *model = [[AtomModel alloc] init];
                model.key = key;
                if ([value isKindOfClass:[NSString class]]) {
                    model.displayValue = value;
                }
                if (titleDict && [titleDict objectForKey:key]) {
                    model.displayKey = [titleDict objectForKey:key];
                }
                if (classDict && [classDict objectForKey:key]) {
                    model.cellClass = [classDict objectForKey:key];
                }
                
                self.atomCount ++;
                [self setValue:model forKey:key];
            }else{
                [self setValue:value forKey:key];
            }
        }
    }
    free(properties);
    return self;
}


- (NSDictionary *)getTitleDict {
    return nil;
}

- (NSDictionary *)getClassDict {
    return nil;
}

+(NSArray *)fetchDisplayKeyArr{
    return nil;
}

@end
