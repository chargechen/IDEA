//
//  AMUIUtility.h
//  GetAdMoney
//
//  Created by Charge on 14-3-30.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//
//  一些全局的UI的统一设置接口，比如bar上button的大小及风格

#import <Foundation/Foundation.h>


@interface AMUIUtility : NSObject {
    
}
+(CGFloat) barBtnItemWidth:(NSString*)title;

// 创建普通的按钮，在iOS7主题上只显示文字
+ (UIButton *)createBarBtn:(NSString *)title target:(id)target selector:(SEL)sel;

// 创建普通的导航栏按钮，在iOS7主题上只显示文字
+(UIBarButtonItem*) createBarBtnItem:(NSString*)title Target:(id)target Sel:(SEL)sel;

// 创建返回按钮
+(UIBarButtonItem*) createBackBarBtnItem:(NSString*)title Target:(id)target Sel:(SEL)sel;

//可以传入文字，背景图片
+(UIBarButtonItem*)createBackBarBtnItem:(NSString*)title NormalImage:(UIImage *)normalImage HighlightImage:(UIImage *)highlightImage Target:(id)target Sel:(SEL)sel;

+(UIBarButtonItem*) createBackBarBtnItem:(NSString*)title NormalImage:(UIImage *)normalImage HighlightImage:(UIImage *)highlightImage titleEdgeInsets:(UIEdgeInsets)edgeInsets Target:(id)target Sel:(SEL)sel;

+(CGFloat) barBtnItemFontSize;
@end

