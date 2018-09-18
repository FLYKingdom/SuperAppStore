//
//  UILabel+Extension.h
//  ifly
//
//  Created by mac on 15/12/30.
//  Copyright © 2015年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+(UILabel *)labelWithName:(NSString *)name textColor:(UIColor *) textcolor
          backGroundColor:(UIColor *)backColor;
+(UILabel *)labelWithName:(NSString *)name
                 fontSize:(CGFloat) font
                fontColor:(UIColor *) color;

+(UILabel *)labelWithName:(NSString *)name
                 fontSize:(CGFloat) font
                fontHexColor:(NSString *) hexStr;

+(UILabel *)labelWithName:(NSString *)name
                 boldSize:(CGFloat) font
             fontHexColor:(NSString *) hexStr;

+(UILabel *)labelWithName:(NSString *)name
                 fontSize:(CGFloat) fontSize
                textColor:(UIColor *) textcolor
          backGroundColor:(UIColor *)backColor;
-(void) setTextAddSizeToFit:(NSString *) textName;

+(UILabel *)labelWithName:(NSString *)name
                 fontSize:(CGFloat) fontSize
                 fontName:(NSString *) fontName
                fontColor:(UIColor *) color;

+(UILabel *)labelWithName:(NSString *)name
                 fontSize:(CGFloat) font
             fontHexColor:(NSString *) hexStr paragraphSep:(CGFloat) sep lineSep:(CGFloat) lineSep;


+(NSMutableAttributedString *)getAttributedString:(NSString *)string font:(CGFloat)stringFont color:(UIColor *)color andUnderline:(BOOL)isUnderline;

@end
