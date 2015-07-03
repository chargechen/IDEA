//
//  LZRefreshTableViewController.h
//  LizhiFM电台
//
//  Created by chargechen on 14/11/25.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "IPTableViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface IPRefreshTableViewController : IPTableViewController
{
    BOOL _isRefreshing;
    EGORefreshTableHeaderView *_refreshTableViewHeaderView;
}

- (void)refreshWithAnimation;
- (void)requestForRefresh;
- (NSDate *)lastRefreshDate;
@end
