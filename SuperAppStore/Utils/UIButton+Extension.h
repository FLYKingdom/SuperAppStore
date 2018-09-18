//
//  UIButton+Extension.h
//  ifly
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

+(instancetype)buttonWithName:(NSString *) name andFont:(CGFloat) font color:(UIColor *) color cornerRadius:(CGFloat) cornerRadius;

+(instancetype)buttonWithName:(NSString *) name andFont:(CGFloat) font hexColor:(NSString *) hexString cornerRadius:(CGFloat) cornerRadius;

+(instancetype)buttonWithName:(NSString *) name andFont:(CGFloat) font hexColor:(NSString *) hexString;

+(instancetype)buttonWithName:(NSString *) name boldFont:(CGFloat) font hexColor:(NSString *) hexString;

+(instancetype)buttonWithImage:(NSString *) imagePath disableImg:(NSString *) disablePath;

+(instancetype)buttonWithImage:(NSString *)imagePath selectedImg:(NSString *)selectedPath;

@end
