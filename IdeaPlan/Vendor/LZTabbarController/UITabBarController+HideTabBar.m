//
//  UITabBarController+HideTabBar.m
//  LizhiFM人人主播电台听中国网络音乐小说英语新闻广播大全
//
//  Created by Nicholas on 14-8-12.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "UITabBarController+HideTabBar.h"
#define kAnimationDuration .3

CGRect tmpRect;

@implementation UITabBarController (HideTabBar)

- (BOOL)isTabBarHidden {
    CGRect viewFrame = self.view.frame;
    CGRect tabBarFrame = self.tabBar.frame;
    return tabBarFrame.origin.y >= viewFrame.size.height;
}

- (void)setTabBarFrame
{
    CGRect tabBarFrame = self.tabBar.frame;
    tabBarFrame.origin.y = self.view.frame.size.height - tabBarFrame.size.height;
}


- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO complete:nil];
}

- (void)setTabBarHidden:(BOOL)hidden
               animated:(BOOL)animated
               complete:(tabBarAnimatedComplete)completed
{
    BOOL isHidden = self.tabBarHidden;
    UIView *transitionView = [self.view.subviews firstObject];
    
    //UIView *transitionView = [[[self.view.subviews reverseObjectEnumerator] allObjects] lastObject];
    
    if(hidden == isHidden){
        return;
    }
    
    if(transitionView == nil) { 
        return;
    }
    
    CGRect viewFrame = self.view.frame;
    CGRect tabBarFrame = self.tabBar.frame;
    CGRect containerFrame = transitionView.frame;
    
    tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    containerFrame.size.height = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
    tmpRect = containerFrame;
    
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             self.tabBar.frame = tabBarFrame;
                             transitionView.frame = containerFrame;
                         } completion:^(BOOL finished) {
                             completed();
                         }];
    } else {
        self.tabBar.frame = tabBarFrame;
        transitionView.frame = containerFrame;
        completed();
    }
}

@end
