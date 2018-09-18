//
//  TabListView.h
//  ifly
//
//  Created by mac on 17/5/18.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabListView : UIView

-(instancetype)initSubListArr:(NSArray *)subListArr tiltles:(NSArray *)titles frame:(CGRect) frame;

-(void) updateTitle:(NSString *) title tag:(NSInteger) tag;

@end
