//
//  LZRefreshTableViewController.m
//  LizhiFM电台
//
//  Created by chargechen on 14/11/25.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "IPRefreshTableViewController.h"

@interface IPRefreshTableViewController ()<EGORefreshTableHeaderDelegate>
@end

@implementation IPRefreshTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  添加下拉刷新控件
 */
-(void)addRefreshControl
{
    _refreshTableViewHeaderView = [[EGORefreshTableHeaderView alloc]
                                      initWithFrame:CGRectMake(0, -kLocationHeight, screenWidth(), kLocationHeight)];
    [_refreshTableViewHeaderView setBackgroundColor:RGBColorC(0xe9e7e0)];
    _refreshTableViewHeaderView.delegate = self;
    [_tableView addSubview:_refreshTableViewHeaderView];
    [_refreshTableViewHeaderView refreshLastUpdatedDate];
    
//    _loadMoreFooterView = [[LZLoadMoreFooterView alloc]
//                            initWithFrame:CGRectMake(0, 0, CGRectWidth([self.view bounds]), 60)
//                            andGap:10];
//    [mTableView.tableFooterView addSubview:_loadMoreFooterView];
//    
//    _loadMoreFooterView.hidden = YES;
}
#pragma mark - 刷新控件
- (void)autoRefreshWithAnimation
{
    [self refreshWithAnimation];
}

- (void)refreshWithAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationsEnabled:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(refreshScrollViewDidEndDragging)];
    [_tableView setContentOffset:CGPointMake(0, -RefreshViewHight)];
    [UIView commitAnimations];
    
    [_refreshTableViewHeaderView egoRefreshScrollViewDidScroll:_tableView];
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableViewHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (_isRefreshing) {
        return;
    } else {
        [_refreshTableViewHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - RefreshTableView Method
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self requestForRefresh];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _isRefreshing;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    NSDate *date = [self lastRefreshDate];
    
    return date;
}

- (void)refreshScrollViewDidEndDragging
{
    [_refreshTableViewHeaderView egoRefreshScrollViewDidEndDragging:_tableView];
}

- (NSDate *)lastRefreshDate
{
    return [NSDate date];
}
#pragma mark - Data
- (void)requestForRefresh
{
    
}

#pragma mark - load more
//- (void)isShowFootView:(BOOL)is
//{
//    [_loadMoreFooterView setHidden:!is];
//    if (is) {
//        [mTableView setContentInset:(UIEdgeInsetsMake(0, 0, 0, 0))];
//    } else {
//        [mTableView setContentInset:(UIEdgeInsetsMake(0, 0, -50, 0))];
//    }
//}
@end
