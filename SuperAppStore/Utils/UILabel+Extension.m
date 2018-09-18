//
//  UILabel+Extension.m
//  ifly
//
//  Created by mac on 15/12/30.
//  Copyright © 2015年 Eels. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)


+(UILabel *)labelWithName:(NSString *)name textColor:(UIColor *) textcolor
          backGroundColor:(UIColor *)backColor{
    UILabel *lab = [UILabel new];
    [lab setText:name];
    [lab setTextColor:textcolor];
    [lab setBackgroundColor:backColor];
    [lab sizeToFit];
    
    return lab;
}

+(UILabel *)labelWithName:(NSString *)name
                 fontSize:(CGFloat) fontSize
                textColor:(UIColor *) textcolor
          backGroundColor:(UIColor *)backColor{
    UILabel *lab = [UILabel new];
    [lab setText:name];
    [lab setFont:[UIFont systemFontOfSize:fontSize]];
    [lab setTextColor:textcolor];
    [lab setBackgroundColor:backColor];
    [lab sizeToFit];
    
    return lab;
}

+(UILabel *)labelWithName:(NSString *)name fontSize:(CGFloat)font fontColor:(UIColor *)color{
    UILabel *lab = [UILabel new] ;
    if (name == nil) {
        name = @"";
    }
    [lab setText:name];
    [lab setTextColor:color];
    [lab setFont:[UIFont systemFontOfSize:font]];
    [lab sizeToFit];
    
    return lab;
}

+(UILabel *)labelWithName:(NSString *)name
                 fontSize:(CGFloat) font
             fontHexColor:(NSString *) hexStr{
    UILabel *lab = [UILabel new] ;
    if (name == nil) {
        name = @"";
    }
    [lab setText:name];
    UIColor *fontColor = [self colorWithHexString:hexStr];
    [lab setTextColor:fontColor];
    [lab setFont:[UIFont systemFontOfSize:font]];
    [lab sizeToFit];
    
    return lab;
}

+(UILabel *)labelWithName:(NSString *)name
                 boldSize:(CGFloat) font
             fontHexColor:(NSString *) hexStr{
    UILabel *lab = [UILabel new] ;
    if (name == nil) {
        name = @"";
    }
    [lab setText:name];
    UIColor *fontColor = [self colorWithHexString:hexStr];
    [lab setTextColor:fontColor];
    [lab setFont:[UIFont fontWithName:BoldFontName size:font]];
    [lab sizeToFit];
    
    return lab;
}

+(UILabel *)labelWithName:(NSString *)name fontSize:(CGFloat)fontSize fontName:(NSString *)fontName fontColor:(UIColor *)color{
    UILabel *lab = [UILabel new] ;
    if (name == nil) {
        name = @"";
    }
    [lab setText:name];
    [lab setTextColor:color];
    [lab setFont:[UIFont fontWithName:fontName size:fontSize]];
    [lab sizeToFit];
    
    return lab;
}


-(void)setTextAddSizeToFit:(NSString *)textName{
    textName = textName&&![textName isEqualToString:@""] ?textName:@"暂无信息";
    [self setText:textName];
    [self sizeToFit];
}

+(UILabel *)labelWithName:(NSString *)name
                 fontSize:(CGFloat) font
                fontColor:(UIColor *) color paragraphSep:(CGFloat) sep{
    UILabel *lab = [UILabel new] ;
    if (name == nil) {
        name = @"";
    }
    NSMutableAttributedString *attributedStr = [self getAttributedString:name font:font color:color andUnderline:NO];
    NSMutableParagraphStyle *pragraphStyle = [[NSMutableParagraphStyle alloc] init];
    pragraphStyle.paragraphSpacing = sep;
    NSRange range = NSMakeRange(0, name.length);
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:pragraphStyle range:range];
    lab.attributedText = attributedStr;
    
    [lab sizeToFit];
    
    return lab;
}

+(UILabel *)labelWithName:(NSString *)name
                 fontSize:(CGFloat) font
             fontHexColor:(NSString *) hexStr paragraphSep:(CGFloat) sep lineSep:(CGFloat)lineSep{
    UILabel *lab = [UILabel new] ;
    if (name == nil) {
        name = @"";
    }
    UIColor *fontColor = [self colorWithHexString:hexStr];
    NSMutableAttributedString *attributedStr = [self getAttributedString:name font:font color:fontColor andUnderline:NO];
     NSMutableParagraphStyle *pragraphStyle = [[NSMutableParagraphStyle alloc] init];
     pragraphStyle.paragraphSpacing = sep;
    pragraphStyle.lineSpacing = lineSep;
     NSRange range = NSMakeRange(0, name.length);
     [attributedStr addAttribute:NSParagraphStyleAttributeName value:pragraphStyle range:range];
     lab.attributedText = attributedStr;
    
    return lab;
}

#pragma mark - attributed string

//获取指定格式的attributedString
+(NSMutableAttributedString *)getAttributedString:(NSString *)string font:(CGFloat)stringFont color:(UIColor *)color andUnderline:(BOOL)isUnderline{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange strRange = NSMakeRange(0, attributedStr.length);
    if (isUnderline) {
        [attributedStr addAttribute:NSUnderlineStyleAttributeName value:@1 range:strRange];
    }
    [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:strRange];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:stringFont] range:strRange];
    
    return attributedStr;
}

+(NSAttributedString *)getAttributedString:(NSString *)string1 dictionary:(NSDictionary *)dictionary string2:(NSString *)string2 dictionary2:(NSDictionary *)dictionary2{
    NSString *finalStr = [string1 stringByAppendingString:string2];
    
    NSRange range1 = NSMakeRange(0, string1.length);
    NSRange range2 = NSMakeRange(string1.length, string2.length);
    //    NSRange totalRange = NSMakeRange(0, finalStr.length);
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:finalStr];
    
    [attributedStr addAttributes:dictionary range:range1];
    [attributedStr addAttributes:dictionary2 range:range2];
    
    return attributedStr.copy;
}

#pragma mark - sub method

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    NSInteger r = (hex >> 16) & 0xFF;
    NSInteger g = (hex >> 8) & 0xFF;
    NSInteger b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

@end
