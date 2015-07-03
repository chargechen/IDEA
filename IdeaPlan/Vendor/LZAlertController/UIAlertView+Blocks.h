//
//  UIAlertView+Blocks.h
//  LizhiFM听手机人人主播网络音乐小说英语新闻广播大全学堂cs
//
//  Created by chargechen on 14-10-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZButtonItem.h"
static NSString *LZ_ALERT_BUTTON_ASS_KEY = @"ALERT_BUTTONS";

@interface UIAlertView (Blocks)

-(id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(LZButtonItem *)inCancelButtonItem otherButtonItems:(LZButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonItem:(LZButtonItem *)item;

@end
