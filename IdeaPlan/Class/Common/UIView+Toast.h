//
//  UIView+Toast.h
//  GetAdMoney
//
//  Created by Charge on 14-1-12.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMaxWidth                   0.8
#define kMaxHeight                  0.8

#define kHorizontalPadding          10.0
#define kVerticalPadding            10.0
#define kCornerRadius               10.0
#define kOpacity                    0.5
#define kFontSize                   16.0
#define kMaxTitleLines              999
#define kMaxMessageLines            999
#define kFadeDuration               0.2
#define kDisplayShadow              YES

#define kDefaultLength              3.0
#define kDefaultPosition            @"bottom"

#define kImageWidth                 80.0
#define kImageHeight                80.0

#define kActivityWidth              100.0
#define kActivityHeight             100.0
#define kActivityDefaultPosition    @"center"
#define kActivityTag                91325
@interface UIView (Toast)
// each makeToast method creates a view and displays it as toast
- (void)makeToast:(NSString *)message;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image;

// displays toast with an activity spinner
- (void)makeToastActivity;
- (void)makeToastActivity:(id)position;
- (void)hideToastActivity;

// the showToast methods display any view as toast
- (void)showToast:(UIView *)toast;
- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point;

@end
