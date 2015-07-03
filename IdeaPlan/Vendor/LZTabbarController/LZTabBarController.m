//
//  LZTabBarController.m
//  LizhiFM人人主播电台听中国网络音乐小说英语新闻广播大全
//
//  Created by Nicholas on 14-8-11.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "LZTabBarController.h"
#import "IPNavigationViewController.h"
#import "IPMineViewController.h"
#import "IPHotViewController.h"
#import "IPCategoryViewController.h"

#import "PublicDefine.h"
#define kTabbarTagShift 1000000

typedef NS_ENUM(NSUInteger, kTabbarTag) {
    kTabbarTagFind = 0 + kTabbarTagShift,
    kTabbarTagMine,
    kTabbarTagRecord
};

@interface LZTabBarController () <UITabBarControllerDelegate>
{
//    BOOL isAdaptation;
    UIImageView *_tabbarBgView;
}
@property(nonatomic, retain)NSMutableArray *tabButtons;
//@property(nonatomic, retain)UIImageView *mineBadge;
@end

@implementation LZTabBarController
+ (instancetype)shareInstance
{
    static LZTabBarController *kTabbarController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kTabbarController = [[LZTabBarController alloc] initWithConfig];
    });
    return kTabbarController;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (id)initWithConfig
{
    self = [self init];
    if (self) {
        _tabButtons = [[NSMutableArray alloc] initWithCapacity:3];
        NSArray *controllers = [self tabbarViewControllers];
        
        [self setViewControllers:controllers];
        
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor clearColor]];
        
        [self initTabbarButton];
        
        [self setDelegate:self];
        
        //[self.tabBar setHidden:YES];

    }
    return self;
}

#pragma mark - 视图初始化

- (void)initTabbarButton
{
    CGRect tabbarBgViewFrame = CGRectMake(0, 0, screenWidth(), self.tabBar.frame.size.height);
    _tabbarBgView = [[UIImageView alloc] initWithFrame:tabbarBgViewFrame];
    [_tabbarBgView setUserInteractionEnabled:YES];
    [_tabbarBgView setBackgroundColor:RGBColorC(0xf9f9f9)];
    [self.tabBar addSubview:_tabbarBgView];
    
    UIImage* hotImage            = [UIImage imageNamed:@"tabbar1_n.png"];
    UIImage* hotSelectedImage    = [UIImage imageNamed:@"tabbar1_p.png"];
    UIImage* cateImage           = [UIImage imageNamed:@"tabbar2_n.png"];
    UIImage* cateSelectedImage   = [UIImage imageNamed:@"tabbar2_p.png"];
    UIImage* mineImage           = [UIImage imageNamed:@"tabbar3_n.png"];
    UIImage* mineSelectedImage   = [UIImage imageNamed:@"tabbar3_p.png"];
    
    // 发现按钮
    CGRect layoutButtonFrame = CGRectMake((CGRectWidth(tabbarBgViewFrame)/3)*0, 0, CGRectWidth(tabbarBgViewFrame)/3, CGRectHeight(tabbarBgViewFrame));
    UIButton *_layoutButton = [self buttonWithTitle:@"推荐"
                                               icon:hotImage
                                      highlightIcon:hotImage
                                       selectedIcon:hotSelectedImage
                                              frame:layoutButtonFrame
                                                tag:kTabbarTagFind];
    [_tabbarBgView addSubview:_layoutButton];
    
    // 我的按钮
    CGRect mineButtonFrame = CGRectMake((CGRectWidth(tabbarBgViewFrame)/3)*1, 0, CGRectWidth(tabbarBgViewFrame)/3, CGRectHeight(tabbarBgViewFrame));
    UIButton *_mineButton = [self buttonWithTitle:@"分类"
                                             icon:cateImage
                                    highlightIcon:cateSelectedImage
                                     selectedIcon:cateSelectedImage
                                            frame:mineButtonFrame
                                              tag:kTabbarTagMine];
    [_tabbarBgView addSubview:_mineButton];
    
    // 录音按钮
    CGRect recordButtonFrame = CGRectMake((CGRectWidth(tabbarBgViewFrame)/3)*2, 0, CGRectWidth(tabbarBgViewFrame)/3, CGRectHeight(tabbarBgViewFrame));
    
    UIButton *_recordButton = [self buttonWithTitle:@"我"
                                               icon:mineImage
                                      highlightIcon:mineImage
                                       selectedIcon:mineSelectedImage
                                              frame:recordButtonFrame
                                                tag:kTabbarTagRecord];
    [_tabbarBgView addSubview:_recordButton];
}

- (UIButton *)buttonWithTitle:(NSString *)title
                         icon:(UIImage *)icon
                highlightIcon:(UIImage *)highlightIcon
                 selectedIcon:(UIImage *)selectedIcon
                        frame:(CGRect)frame
                          tag:(int)tag
{
    UIFont *buttonFont = [UIFont systemFontOfSize:12];
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTag:tag];
    [button.titleLabel setFont:buttonFont];
    [button setImage:icon forState:UIControlStateNormal];
    [button setImage:highlightIcon forState:UIControlStateHighlighted];
    [button setImage:selectedIcon forState:UIControlStateSelected];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(6, icon.size.width, CGRectHeight(frame)-icon.size.height-6, 0)];
//    [button setBackgroundImage:STRETCHABLE_IMAGE(@"bg_tabbar.png", 10, 10)
//                      forState:UIControlStateNormal];
//    [button setBackgroundImage:STRETCHABLE_IMAGE(@"bg_tabbar_press.png", 10, 10)
//                      forState:UIControlStateHighlighted];
//    [button setBackgroundImage:STRETCHABLE_IMAGE(@"bg_tabbar_press.png", 10, 10)
//                      forState:UIControlStateSelected];
    
    UIColor *normalTextColor = RGBColorC(0x8f897a);
    UIColor *selectedTextColor = [UIColor colorWithRed:255/255.f green:104/255.f blue:4/255.f alpha:1.0];
    [button setTitleColor:normalTextColor forState:UIControlStateNormal];
    [button setTitleColor:selectedTextColor forState:UIControlStateSelected];

    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(icon.size.height, -icon.size.width, 0, 0)];
    [button addTarget:self
               action:@selector(onTabbarButtonClick:)
     forControlEvents:UIControlEventTouchUpInside];

    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageSize.height + titleSize.height + 3);
    
    button.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);

    
    return button;
}

- (NSArray *)tabbarViewControllers
{
    NSMutableArray *controllers = [NSMutableArray array];
    
    IPHotViewController *layoutVC = [[IPHotViewController alloc] init];
    IPNavigationController *layoutNav = [[IPNavigationController alloc] initWithRootViewController:layoutVC];
    UITabBarItem *layoutItem = [[UITabBarItem alloc] init];
    [layoutItem setTag:kTabbarTagFind];
    layoutNav.tabBarItem = layoutItem;
    //为了voiceover
    layoutItem.title = @"推荐";
    [layoutItem setTitlePositionAdjustment:UIOffsetMake(0, 30)];
    
    [controllers addObject:layoutNav];
    
    IPCategoryViewController *cateVC = [[IPCategoryViewController alloc] init];
    IPNavigationController *cateNav = [[IPNavigationController alloc] initWithRootViewController:cateVC];
    UITabBarItem *cateItem = [[UITabBarItem alloc] init];
    [cateItem setTag:kTabbarTagMine];
    cateNav.tabBarItem = cateItem;
    [controllers addObject:cateNav];
    
    //为了voiceover
    cateItem.title = @"分类";
    [cateItem setTitlePositionAdjustment:UIOffsetMake(0, 30)];
    
    IPMineViewController *mineVC = [[IPMineViewController alloc] init];
    IPNavigationController *mineNav = [[IPNavigationController alloc] initWithRootViewController:mineVC];
    UITabBarItem *mineItem = [[UITabBarItem alloc] init];
    [mineItem setTag:kTabbarTagMine];
    mineNav.tabBarItem = mineItem;
    [controllers addObject:mineNav];
    
    //为了voiceover
    mineItem.title = @"分类";
    [mineItem setTitlePositionAdjustment:UIOffsetMake(0, 30)];
    
    return controllers;
}

#pragma mark - 按钮事件

- (void)onTabbarButtonClick:(UIButton *)button
{
    NSInteger index = ([button tag]-kTabbarTagShift);
    
//    if ([self selectedIndex] != index) {
//        [g_pKeyValueStoreMgr setDoneByKey:kKvsFMRadioMineBtnBadge];
//        [self hiddenMineBadge];
//    }
    
    [self onTabbarButtonSeclected:index];
}

- (void)onTabbarButtonSeclected:(NSInteger)index
{
    [self setSelectedIndex:index];
    
    // 按钮 高亮方法
  
    for (int i=0; i<[[_tabbarBgView subviews] count]; i++)
    {
        UIButton *tabbarButton = [_tabbarBgView subviews][i];
        if ([tabbarButton isKindOfClass:[UIButton class]]) {
            [tabbarButton setSelected:(index==i)];
        }
    }
    
}

#pragma mark - 选项栏方法

- (void)defaultSelectedIndex:(NSUInteger)index
{
    [self onTabbarButtonSeclected:index];
    
//    if (index != 1) {
//        if ([g_pSessionMgr hasSession] &&
//            [g_pKeyValueStoreMgr isDoByKeyDefaultNO:kKvsFMRadioMineBtnBadge]) {
//            [self showMineBadge];
//        }
//    }
}

- (void)setHidden:(BOOL)isHidden
{
    [self setHidden:isHidden animated:YES];
}

- (void)setHidden:(BOOL)isHidden
         animated:(BOOL)animated
{
//    self.tabBar.translucent = !isHidden;

    @synchronized (self) {
        [self setTabBarHidden:isHidden
                     animated:animated
                     complete:^{
//                         if (!isHidden) {
//                             if ([g_pSessionMgr hasSession] &&
//                                 [g_pKeyValueStoreMgr isDoByKeyDefaultNO:kKvsFMRadioMineBtnBadge]) {
//                                 [self showMineBadge];
//                             } else {
//                                 [self hiddenMineBadge];
//                             }
//                         }
                     }];
    }
}

#pragma mark - 选项栏 红点提示 方法

//- (void)showMineBadge
//{
//    if (_mineBadge == nil) {
//        CGRect mineBadgeFrame = CGRectMake(screenWidth()/3 + screenWidth()/3/2+10,6, 15, 15);
//        _mineBadge = [[UIImageView alloc] initWithFrame:mineBadgeFrame];
//        [_mineBadge setImage:[UIImage imageNamed:@"chat_badge_new"]];
//        [_tabbarBgView addSubview:_mineBadge];
//    }
//    
//    [_mineBadge setHidden:NO];
//}
//
//- (void)hiddenMineBadge
//{
//    if (_mineBadge && !_mineBadge.hidden) {
//        [_mineBadge setHidden:YES];
//    }
//}

#pragma mark - 选项栏 委托

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
//    if ([viewController isKindOfClass:[LZNavigationController class]]) {
//        LZNavigationController *nav = (LZNavigationController *)viewController;
//        if ([nav.delegateArray count] > 1) {
//            [nav popToMyRootViewController];
//        }
//    }
}


#pragma mark - 生命周期

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
