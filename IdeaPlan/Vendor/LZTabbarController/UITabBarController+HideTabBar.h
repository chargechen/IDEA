//
//  UITabBarController+HideTabBar.h
//  LizhiFM人人主播电台听中国网络音乐小说英语新闻广播大全
//
//  Created by Nicholas on 14-8-12.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^tabBarAnimatedComplete)();

@interface UITabBarController (HideTabBar)

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;
- (void)setTabBarHidden:(BOOL)hidden
               animated:(BOOL)animated
               complete:(tabBarAnimatedComplete)completed;
@end
