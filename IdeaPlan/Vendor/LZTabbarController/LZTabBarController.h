//
//  LZTabBarController.h
//  LizhiFM人人主播电台听中国网络音乐小说英语新闻广播大全
//
//  Created by Nicholas on 14-8-11.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarController+HideTabBar.h"

@interface LZTabBarController : UITabBarController 
+ (instancetype)shareInstance;
- (id)initWithConfig;
- (void)setHidden:(BOOL)isHidden;

- (void)defaultSelectedIndex:(NSUInteger)index;
//- (void)showMineBadge;

@end
