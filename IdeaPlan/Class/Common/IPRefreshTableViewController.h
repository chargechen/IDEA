//
//  LZRefreshTableViewController.h
//  LizhiFM电台
//
//  Created by chargechen on 14/11/25.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "LZTableViewController.h"
#import "EGORefreshTableHeaderView.h"
//#import "LZLoadMoreFooterView.h"
@interface LZRefreshTableViewController : LZTableViewController
{
    BOOL _isRefreshing;
    EGORefreshTableHeaderView *_refreshTableViewHeaderView;
//    LZLoadMoreFooterView *_loadMoreFooterView;
}

- (void)refreshWithAnimation;
- (void)requestForRefresh;
- (NSDate *)lastRefreshDate;
//- (void)isShowFootView:(BOOL)is;
@end
