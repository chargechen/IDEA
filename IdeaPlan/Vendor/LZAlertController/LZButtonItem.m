//
//  LZButtonItem.m
//  LizhiFM听手机人人主播网络音乐小说英语新闻广播大全学堂cs
//
//  Created by chargechen on 14-10-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "LZButtonItem.h"
#if !__has_feature(objc_arc)
#error This file must be compiled with ARC.
#endif
@implementation LZButtonItem
+(id)item
{
    return [[self alloc] init];
}

+(id)itemWithLabel:(NSString *)inLabel
{
    LZButtonItem *newItem = [self item];
    [newItem setLabel:inLabel];
    [newItem setAction:nil];
    return newItem;
}

+(id)itemWithLabel:(NSString *)inLabel action:(void(^)(void))action
{
  LZButtonItem *newItem = [self itemWithLabel:inLabel];
  [newItem setAction:action];
  return newItem;
}

- (void)dealloc
{
    
}
@end

