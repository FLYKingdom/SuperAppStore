//
//  RefreshActivity.h
//  ifly
//
//  Created by mac on 17/4/25.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ActivityHeight 33

@interface RefreshActivity : UIView

@property (assign, readonly, nonatomic) BOOL isAnimate;

-(id) initWithView:(UIView *) view;

-(void) show;

-(void) dismiss;

@end
