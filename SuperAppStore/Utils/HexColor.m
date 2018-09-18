//
//  HexColor.m
//  CardRefer
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Fly. All rights reserved.
//

#import "HexColor.h"

@implementation HexColor

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
