//
//  LZLazyScrollView.h
//  DMLazyScrollViewExample
//
//  Created by Nicholas on 14-3-28.
//  Copyright (c) 2014年 daniele. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMLazyScrollView;
@class LZBannerScrollView;
@class WidgetBanner;
@class WidgetImage;

@protocol LZBannerScrollViewDelegate <NSObject>
- (void)banner:(LZBannerScrollView *)view
   widgetImage:(WidgetImage *)theItem;
@end

@interface LZBannerScrollView : UIView

@property (nonatomic, assign)id<LZBannerScrollViewDelegate>delegate;


@property (nonatomic, retain)WidgetBanner *bannerItem;

- (void)reloadScrollView;

- (void)autoPlayResume;
- (void)autoPlayPause;

@end
