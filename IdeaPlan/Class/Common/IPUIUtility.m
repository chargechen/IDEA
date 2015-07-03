//
//  IPUIUtility.m
//  GetAdMoney
//
//  Created by Charge on 14-3-30.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "IPUIUtility.h"
#import "PublicDefine.h"
#import "UIButton+Bootstrap.h"

@implementation IPUIUtility

// 根据title文字的个数，决定bar的宽度
+(CGFloat) barBtnItemWidth:(NSString*)title
{
	if (title.length == 3)
    {
		return 70.0f;
	}
	else if (title.length == 4)
    {
		return 80.0f;
	}
    else if (title.length > 4)
    {
        return 70.0f;
    }
	
	return 55.0f;
}

+(CGFloat) barBtnItemFontSize
{
    return 16;
//    if (!isIOS7)
//        return 17.0f;
//    else
//        return 12.0f;
}
+ (UIButton *)createBarBtn:(NSString *)title target:(id)target selector:(SEL)sel
{
    UIButton *btn = [[UIButton alloc] init];
	CGFloat width = [IPUIUtility barBtnItemWidth:title];
    btn.frame = CGRectMake(0.0F, 0.0F, width, 32);
    btn.titleLabel.font = [UIFont systemFontOfSize:[IPUIUtility barBtnItemFontSize]];
    if(!isIOS7)
    {
        [btn defaultStyle];
    }
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn setTitle:title forState: UIControlStateNormal];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
	
    return btn;
}

+(UIBarButtonItem*) createBarBtnItem:(NSString*)title Target:(id)target Sel:(SEL)sel
{
    UIButton *btn = [self createBarBtn:title target:target selector:sel];
	UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	
	return barBtnItem;
}

+(UIBarButtonItem*) createBackBarBtnItem:(NSString*)title Target:(id)target Sel:(SEL)sel
{
	UIButton *btn = [[UIButton alloc] init];
	CGFloat width = [IPUIUtility barBtnItemWidth:title];
    
    btn.frame = CGRectMake(0.0F, 0.0F, width + 5.0f, 32);
    btn.titleLabel.font = [UIFont systemFontOfSize:[IPUIUtility barBtnItemFontSize]];
    btn.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    [btn setTitle:title forState: UIControlStateNormal];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 5, 0, 0);
    if(!isIOS7)
    {
        [btn setBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Normal"] stretchableImageWithLeftCapWidth:10 topCapHeight:15]
                       forState:UIControlStateNormal];
        [btn setBackgroundImage:[[UIImage imageNamed:@"BarButtonItem_Pressed"] stretchableImageWithLeftCapWidth:10 topCapHeight:15]
                       forState:UIControlStateHighlighted];
    }
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:insets];
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
	return barBtnItem;
}

//可以传入文字，背景图片
+(UIBarButtonItem*) createBackBarBtnItem:(NSString*)title NormalImage:(UIImage *)normalImage HighlightImage:(UIImage *)highlightImage Target:(id)target Sel:(SEL)sel
{
    UIButton *btn = [[UIButton alloc] init];
    
	CGFloat width = [IPUIUtility barBtnItemWidth:title];
    btn.frame = CGRectMake(0.0F, 0.0F, width, 32);
    btn.titleLabel.font = [UIFont systemFontOfSize:[IPUIUtility barBtnItemFontSize]];
	UIImage *img = normalImage;
    UIImage *imgHl = highlightImage;
	UIImage *s_img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
	UIImage *s_imgHl = [imgHl stretchableImageWithLeftCapWidth:imgHl.size.width/2 topCapHeight:imgHl.size.height/2];
    [btn setTitle:title forState: UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if (!isIOS7) {
        [btn setBackgroundImage:s_img forState: UIControlStateNormal];
        [btn setBackgroundImage:s_img forState: UIControlStateDisabled];
        [btn setBackgroundImage:s_imgHl forState:UIControlStateHighlighted];
    }
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
	//btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    
	UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	
	return barBtnItem;
}

//可以传入文字、背景图片、title偏移
+(UIBarButtonItem*) createBackBarBtnItem:(NSString*)title NormalImage:(UIImage *)normalImage HighlightImage:(UIImage *)highlightImage titleEdgeInsets:(UIEdgeInsets)edgeInsets Target:(id)target Sel:(SEL)sel
{
    UIButton *btn = [[UIButton alloc] init];
    
	CGFloat width = [IPUIUtility barBtnItemWidth:title];
    btn.frame = CGRectMake(0.0F, 0.0F, width, 32);
    btn.titleLabel.font = [UIFont systemFontOfSize:[IPUIUtility barBtnItemFontSize]];
	UIImage *img = normalImage;
    UIImage *imgHl = highlightImage;
	UIImage *s_img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
	UIImage *s_imgHl = [imgHl stretchableImageWithLeftCapWidth:imgHl.size.width/2 topCapHeight:img.size.height/2];
    [btn setTitle:title forState: UIControlStateNormal];
    btn.titleEdgeInsets = edgeInsets;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if (!isIOS7) {
        [btn setBackgroundImage:s_img forState: UIControlStateNormal];
        [btn setBackgroundImage:s_img forState: UIControlStateDisabled];
        [btn setBackgroundImage:s_imgHl forState:UIControlStateHighlighted];
    }
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	
	return barBtnItem;
}
@end
