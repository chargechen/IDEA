//
//  LZLazyScrollView.m
//  DMLazyScrollViewExample
//
//  Created by Nicholas on 14-3-28.
//  Copyright (c) 2014年 daniele. All rights reserved.
//

#import "LZBannerScrollView.h"

#import "LZColorMgr.h"
  

#import "DDPageControl.h"
#import "DMLazyScrollView.h"
#import "LZBasePhotoView.h"
#import "LayoutImage.h"

#import "WidgetBanner.h"
#import "WidgetImage.h"

#define ARC4RANDOM_MAX	0x100000000

@interface LZBannerScrollView () <DMLazyScrollViewDelegate, WidgetImageDelegate>
{
    NSMutableArray *_viewControllerArray;
    DDPageControl *_pageControl;
}

@property (nonatomic, retain)DMLazyScrollView *lazyScrollView;
@property (nonatomic, retain)UIImageView *bgImageView;

@end

@implementation LZBannerScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewControllerArray = [[NSMutableArray alloc] init];
        
        //        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-2)];
        //        [_bgImageView setImage:[UIImage imageNamed:@"cover_large"]];
        //        [_bgImageView setClipsToBounds:YES];
        //
        //        [_bgImageView setContentMode:UIViewContentModeCenter];
        //        [self addSubview:_bgImageView];
        
        UIImageView *bannerBottomLine = [[UIImageView alloc] init];
        [bannerBottomLine setFrame:CGRectMake(0, frame.size.height-2, frame.size.width, 2)];
        [bannerBottomLine setImage:[UIImage imageNamed:@"line.png"]];
        [self addSubview:bannerBottomLine];
        RELEASE_SAFELY(bannerBottomLine);
    }
    return self;
}

- (void)reloadScrollView
{
    NSUInteger numberOfPages = self.bannerItem.items.count;
    
    if (_viewControllerArray.count) {
        [_viewControllerArray removeAllObjects];
    }
    
    for (NSUInteger k = 0; k < numberOfPages; ++k) {
        [_viewControllerArray addObject:[NSNull null]];
    }
    
    if (!_lazyScrollView) {
        _lazyScrollView = [[DMLazyScrollView alloc] init];
        [_lazyScrollView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-2)];
        [_lazyScrollView setEnableCircularScroll:YES];
        [_lazyScrollView setAutoPlay:YES];
        if (self.bannerItem.interval) {
            [_lazyScrollView setAutoPlayTime:self.bannerItem.interval];
        }
        
        _lazyScrollView.dataSource = ^(NSUInteger index) {
            return [self controllerAtIndex:index];
        };
        _lazyScrollView.controlDelegate = self;
        [self addSubview:_lazyScrollView];
    }
    
    _lazyScrollView.numberOfPages = numberOfPages;
    _lazyScrollView.isAccessibilityElement = YES;
    _lazyScrollView.accessibilityLabel = LS(@"VO_GROUP_SPECIAL");

    if (!_pageControl) {
        _pageControl = [[DDPageControl alloc] init];
        [_pageControl setCenter:CGPointMake(self.center.x,
                                            self.frame.size.height-14)] ;
        [_pageControl addTarget:self
                         action:@selector(pageControlAction:)
               forControlEvents:UIControlEventValueChanged];
        [_pageControl setOnColor:RGBColor(240, 191, 88)];
        [_pageControl setOffColor:RGBColor(224, 220, 209)];
        [_pageControl setCurrentPage:0];
        [_pageControl setHidesForSinglePage:YES];
        [_pageControl setIndicatorDiameter:4.5f] ;
        [self addSubview:_pageControl];
    }
    
    [_pageControl setNumberOfPages:numberOfPages];
}


- (void)pageControlAction:(id)sender
{
    [_lazyScrollView setPage:_pageControl.currentPage
                    animated:YES];
}

- (void)autoPlayResume
{
    [_lazyScrollView autoPlayResume];
}

- (void)autoPlayPause
{
    [_lazyScrollView autoPlayPause];
} 

- (UIViewController *)controllerAtIndex:(NSInteger) index {
    
    if (index > _viewControllerArray.count || index < 0) return nil;
    
    id result = [_viewControllerArray objectAtIndex:index];
    
    if (result == [NSNull null]) {
        UIViewController *controller = [[[UIViewController alloc] init] autorelease];
        
        WidgetImage *theItem = self.bannerItem.items[index];
        
        CGRect layoutImageFrame = CGRectMake(theItem.marginLeft, theItem.marginTop, CGRectWidth(self.frame) - theItem.marginLeft - theItem.marginRight, CGRectHeight(self.frame) - theItem.marginTop - theItem.marginBottom);
        
        LayoutImage *layoutImage = [[LayoutImage alloc] initWithFrame:layoutImageFrame];
        [layoutImage setWidgetImage:theItem];
        [layoutImage setDelegate:self];
        [controller.view addSubview:layoutImage];
        RELEASE_SAFELY(layoutImage);
        
        [_viewControllerArray replaceObjectAtIndex:index
                                        withObject:controller];
        return controller;
    }
    return result;
}

#pragma mark - 图片 委托

- (void)widgetImageDidClick:(WidgetImage *)widgetImage
{
    if (_delegate && [_delegate respondsToSelector:@selector(banner:widgetImage:)]) {
        [self.delegate banner:self widgetImage:widgetImage];
    }
}

#pragma mark - 横幅 委托

- (void)lazyScrollView:(DMLazyScrollView *)pagingView
    currentPageChanged:(NSInteger)currentPageIndex
{
    [_pageControl setCurrentPage:currentPageIndex];
}

#pragma mark - System
- (void)dealloc
{
    RELEASE_SAFELY(_bgImageView);
    RELEASE_SAFELY(_viewControllerArray);
    RELEASE_SAFELY(_bannerItem);
    RELEASE_SAFELY(_pageControl);
    RELEASE_SAFELY(_lazyScrollView);
    
    [super dealloc];
}


@end
