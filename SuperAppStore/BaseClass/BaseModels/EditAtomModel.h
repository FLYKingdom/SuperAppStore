//
//  EditAtomModel.h
//  ifly
//
//  Created by mac on 2017/7/6.
//  Copyright © 2017年 Eels. All rights reserved.
//

#import "BaseModel.h"

typedef enum : NSUInteger {
    ValueViewStyleLabel,//display
    ValueViewStyleTextField,//edit
    ValueViewStyleUnitField,//unit field
    ValueViewStyleNewPage,//new page
    ValueViewStyleCustom,//custom double btn/tail unit...
} ValueViewStyle;

@interface EditAtomModel : BaseModel

@property (nonatomic, copy) NSString *tipStr;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) NSString *pageVc;//vc class

@property (nonatomic, copy) NSString *unit;

@property (nonatomic, assign) ValueViewStyle style;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, assign) NSInteger keyboardType;

@end
