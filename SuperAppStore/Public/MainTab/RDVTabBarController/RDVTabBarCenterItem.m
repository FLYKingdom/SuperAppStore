// RDVTabBarItem.h
// RDVTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVTabBarCenterItem.h"
//#import "UIView+AnimationExtensions.h"
@interface RDVTabBarCenterItem ()

@property UIColor *unselectedBackgroundColor;
@property UIColor *selectedBackgroundColor;
@property UIImage *unselectedImage;
@property UIImage *selectedImage;

@end

@implementation RDVTabBarCenterItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //[self commonInitialization];
    }
    return self;
}



- (id)init {
    return [self initWithFrame:CGRectZero];
}



- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    
    UIImage *image = nil;
    UIColor *backgroundColor = nil;
    
    //  CGFloat imageStartingY = 0.0f;
    
    if ([self isSelected]) {
        image = [self selectedImage];
        backgroundColor=[self selectedBackgroundColor];
    } else {
        image = [self unselectedImage];
        backgroundColor=[self unselectedBackgroundColor];
    }
    
    [self drawCircle:self.frame];//填充背景
    
    imageSize = [image size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (image) {
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) ,
                                     roundf(frameSize.height / 2 - imageSize.height / 2),
                                     imageSize.width, imageSize.height)];
    }
    
    
    CGContextRestoreGState(context);
}

-(void) drawCircle:(CGRect) rect {
    CGFloat width = rect.size.width;
    
    CGFloat height = rect.size.height;
    
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    
    CGFloat radius = width/2;
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    // 移动到初始点
    
    CGContextMoveToPoint(context, radius, 0);
    
    // 绘制第1个1/4圆弧和第1条线,左上圆弧
    
    CGContextAddArc(context, radius, radius, radius,1.5 *M_PI, M_PI,1);
    
    CGContextAddLineToPoint(context, 0, height - radius);
    
    // 绘制第2个1/4圆弧和第2条线，左下圆弧
    
    CGContextAddArc(context, radius, height - radius, radius,M_PI,0.5 * M_PI,1);
    
    CGContextAddLineToPoint(context, width - radius, height);
    
    // 绘制第3个1/4圆弧和第3条线，右下圆弧
    
    CGContextAddArc(context, width - radius, height - radius, radius,0.5 *M_PI, 0,1);
    
    CGContextAddLineToPoint(context, width,height - radius);
    
    
    // 绘制第4个1/4圆弧和第4条线,右上圆弧
    
    CGContextAddArc(context, width - radius, radius, radius,0, -0.5 *M_PI,1);
    
    CGContextAddLineToPoint(context, radius,0);
    
    // 闭合路径
    
    CGContextClosePath(context);
    
    // 填充半透明红色
    
    CGContextSetRGBFillColor(context,245.0f/255,0.0f/255,23.0f/255,1.0f);
    CGContextDrawPath(context,kCGPathFill);
    
    
}

- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && (selectedImage != [self selectedImage])) {
        [self setSelectedImage:selectedImage];
    }
    
    if (unselectedImage && (unselectedImage != [self unselectedImage])) {
        [self setUnselectedImage:unselectedImage];
    }
}

- (void) setBackgroundSelectedColor:(UIColor *) selectedColor andUnselectedColor:(UIColor *)unselectedColor {
    [self setSelectedBackgroundColor:selectedColor];
    [self setUnselectedBackgroundColor:unselectedColor];
    
}
-(void) setHighlighted:(BOOL)highlighted{
    
    if (highlighted) {
        
        CGRect originalFrame= self.frame;
        CGRect newFrame=CGRectInset(originalFrame, 2, 2);
        self.frame=newFrame;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame=originalFrame;
        }];
        
        
    }
}
@end
