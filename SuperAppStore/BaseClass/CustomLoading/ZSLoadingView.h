//
//  ZSLoadingView.h
//  ifly
//
//  Created by mac on 17/4/21.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSLoadingView : UIView

@property (assign, readonly, nonatomic) BOOL isAnimate;

-(id) initWithView:(UIView *) view;

-(void) show;

//-(void) showWhileExecutingBlock:(dispatch_block_t) block;
//
//-(void) showWhileExecutingBlock:(dispatch_block_t)block completion:(dispatch_block_t) completion;
//
//-(void) showWhileExecutingSelector:(SEL) selector onTarget:(id) target withObject:(id) object;
//
//-(void) showWhileExecutingSelector:(SEL)selector onTarget:(id)target withObject:(id)object completion:(dispatch_block_t) completion;

-(void) dismiss;

-(void) remakePosition:(CGPoint) position;

@end
