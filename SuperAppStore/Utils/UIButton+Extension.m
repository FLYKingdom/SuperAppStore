//
//  UIButton+Extension.m
//  ifly
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 Eels. All rights reserved.
//

#import "UIButton+Extension.h"
#import "HexColor.h"

@implementation UIButton (Extension)

+(instancetype)buttonWithName:(NSString *) name andFont:(CGFloat) font hexColor:(NSString *) hexString{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:name forState:UIControlStateNormal];
    UIColor *color = [HexColor colorWithHexString:hexString];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:font]];
   
    return btn;
}


+(instancetype)buttonWithName:(NSString *)name boldFont:(CGFloat)font hexColor:(NSString *)hexString{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:name forState:UIControlStateNormal];
    UIColor *color = [HexColor colorWithHexString:hexString];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:BoldFontName size:font]];
    
    return btn;
}

+(instancetype)buttonWithName:(NSString *)name andFont:(CGFloat)font hexColor:(NSString *)hexString cornerRadius:(CGFloat)cornerRadius{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:hexString] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:FontName size:font]];
    if (cornerRadius != 0) {
        CALayer *layer = btn.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:cornerRadius];
    }
    
    return btn;
}

+(instancetype)buttonWithName:(NSString *)name andFont:(CGFloat)font color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont fontWithName:FontName size:font]];
    if (cornerRadius != 0) {
        CALayer *layer = btn.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:cornerRadius];
    }
    
    return btn;
}


+(instancetype)buttonWithImage:(NSString *)imagePath disableImg:(NSString *)disablePath{
    UIButton *btn = [[UIButton alloc] init];
    UIImage *normalImg = [UIImage imageNamed:imagePath];
    UIImage *disableImg = [UIImage imageNamed:disablePath];
    
    [btn setImage:normalImg forState:UIControlStateNormal];
    [btn setImage:disableImg forState:UIControlStateDisabled];
    
    return btn;
    
}

+(instancetype)buttonWithImage:(NSString *)imagePath selectedImg:(NSString *)selectedPath{
    UIButton *btn = [[UIButton alloc] init];
    UIImage *normalImg = [UIImage imageNamed:imagePath];
    UIImage *disableImg = [UIImage imageNamed:selectedPath];
    
    [btn setImage:normalImg forState:UIControlStateNormal];
    [btn setImage:disableImg forState:UIControlStateSelected];
    
    return btn;
    
}

@end
