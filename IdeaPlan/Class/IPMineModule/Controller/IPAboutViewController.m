//
//  AboutViewController.m
//  LizhiFM
//
//  Created by wzsam on 13-7-15.
//  Copyright (c) 2013年 yibasan. All rights reserved.
//

#import "AboutViewController.h"
#import "RewardsViewController.h"

#import "LZGlobalMgr.h"
#import "LZColorMgr.h"
#import "FunctionGuideView.h"

@interface AboutViewController () <GuidanceViewDelegate>{
    FunctionGuideView *_newGuideView;
    BOOL isHideStateBar;
}

@end


@implementation AboutViewController


- (id)init {
    self = [super init];
    if (self) {
        UILabel *titleLabel = createNavigationbarTitleLabel(LS(@"ABOUT_TITLE"));
        self.navigationItem.titleView = titleLabel;
    }
    return self;
}

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth() - 60)/2, 27, 60, 60)];
    imgView.image = [UIImage imageNamed:@"about_icon.png"];
    [mContentView addSubview:imgView];
    
    UILabel *sloganLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth()-280)/2, CGRectBottom([imgView frame]) + 15, 280, 20)];
    [sloganLabel setBackgroundColor:[UIColor clearColor]];
    [sloganLabel setText:LS(@"ABOUT_SLOGAN_TITLE")];
    [sloganLabel setTextColor:RGBColor(0x86, 0x7f, 0x6f)];
    [sloganLabel setTextAlignment:NSTextAlignmentCenter];
    [sloganLabel setFont:[LZFontMgr boldFont36]];
    [mContentView addSubview:sloganLabel];
    
    UILabel *copyRightLable = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth()-280)/2, CGRectBottom([sloganLabel frame]) + 10, 280, 30)];
    [copyRightLable setBackgroundColor:[UIColor clearColor]];
    [copyRightLable setText:[NSString stringWithFormat:LS(@"ABOUT_COPYRIGHT_TITLE"), getShortVersionString(), getBuildVersion()]];
    [copyRightLable setTextColor:RGBColor(0xa7, 0xa2, 0x96)];
    [copyRightLable setTextAlignment:NSTextAlignmentCenter];
    [copyRightLable setFont:[LZFontMgr boldFont22]];
    [copyRightLable setNumberOfLines:0];
    [mContentView addSubview:copyRightLable];
    
    UIButton *newFunctionButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth()- 170)/2, CGRectBottom([copyRightLable frame]) + 30, 170, 37)];
    [newFunctionButton setBackgroundImage:STRETCHABLE_IMAGE(@"btn_rewards_n.png", 7.5, 10) forState:UIControlStateNormal];
    [newFunctionButton setBackgroundImage:STRETCHABLE_IMAGE(@"btn_rewards_p.png", 7.5, 10) forState:UIControlStateHighlighted];
    [newFunctionButton setTitle:@"查看新版本特性" forState:UIControlStateNormal];
    [newFunctionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newFunctionButton.titleLabel setFont:[LZFontMgr boldFont28]];
    [newFunctionButton.titleLabel setShadowColor:[LZColorMgr colorWithRBG_0x93_0x1a_0x24]];
    [newFunctionButton.titleLabel setShadowOffset:CGSizeMake(0, 0.5)];
    [newFunctionButton addTarget:self action:@selector(onNewFunctionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mContentView addSubview:newFunctionButton];
    
    if ([g_pGlobalMgr hasLogin]) {
        UIButton *rewardDevelopButton = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth()- 170)/2, CGRectBottom([newFunctionButton frame]) + 15, 170, 37)];
        [rewardDevelopButton setBackgroundImage:STRETCHABLE_IMAGE(@"btn_rewards_n.png", 7.5, 10) forState:UIControlStateNormal];
        [rewardDevelopButton setBackgroundImage:STRETCHABLE_IMAGE(@"btn_rewards_p.png", 7.5, 10) forState:UIControlStateHighlighted];
        [rewardDevelopButton setTitle:LS(@"REWARD_DEVELOPER") forState:UIControlStateNormal];
        [rewardDevelopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rewardDevelopButton.titleLabel setFont:[LZFontMgr boldFont28]];
        [rewardDevelopButton.titleLabel setShadowColor:[LZColorMgr colorWithRBG_0x93_0x1a_0x24]];
        [rewardDevelopButton.titleLabel setShadowOffset:CGSizeMake(0, 0.5)];
        [rewardDevelopButton addTarget:self action:@selector(onRewardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [mContentView addSubview:rewardDevelopButton];
    }
    
    [self showGuideView];
}

#pragma mark - actions
- (void)onRewardButtonPressed:(UIButton *)button {
    RewardsViewController *vc = [[RewardsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)onNewFunctionButtonPressed:(UIButton *)button {
    [self toggleGuidanceView];
}


#pragma mark - 新功能引导
- (void)showGuideView
{
    // 教程页面
    _newGuideView = [[FunctionGuideView alloc] initWithController:self];
    [_newGuideView setDelegate:self];
    [_newGuideView showDoneButton:NO];
    [self.view addSubview:_newGuideView];
}

- (void)toggleGuidanceView
{
    if (_newGuideView.alpha > 0) {
        [_newGuideView dismissWithRecoverView];
    } else {
        [_newGuideView showWithAnimation:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self hideStatusBarIO7AndLater];
    }
}

- (void)guidanceViewDidDismiss
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self showStatusBarIO7AndLater];
}

#pragma mark StatusBar状态栏

- (BOOL)prefersStatusBarHidden {
    return isHideStateBar;
}

- (void)showStatusBarIO7AndLater  {
    if (iOS7AndLater) {
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            isHideStateBar = NO;
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }
}

- (void)hideStatusBarIO7AndLater {
    if (iOS7AndLater) {
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            isHideStateBar = YES;
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }
    }
}

@end
