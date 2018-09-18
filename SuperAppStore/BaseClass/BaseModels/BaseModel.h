//
//  BaseModel.h
//  ifly
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

@interface BaseModel : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger infoID;//使用BaseModel时 必须设置 infoID

//sub class 可以重写的 mehtod

+(instancetype) modelWithDictionary:(NSDictionary *) dict;//public method

+(NSString *) formatImgUrl:(NSString *) imgUrl size:(CGSize) size;//url format

+(NSString *) formatTime:(NSInteger) timeValue;//url format

-(instancetype) initWithDictionary:(NSDictionary *) dict;//public method

- (NSArray *)getProperties;//sub class可以调用

-(NSMutableDictionary *) translateIntoDict;


@end
