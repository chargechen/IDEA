//
//  IPTableViewController.h
//  GetAdMoney
//
//  Created by Charge on 14-4-6.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "IPTableViewController.h"
#import "UIView+Toast.h"

@interface IPPullingTableViewController : IPTableViewController<EGORefreshTableHeaderDelegate>
{
	EGORefreshTableHeaderView *_refreshHeaderView;
	//  Reloading var should really be your tableviews datasource
	BOOL _reloading;
}
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

//ASIRequest
-(void)didRequestSucceed:(NSDictionary *)response;
-(void)didRequestFailed:(NSError *)error;
-(void)refreshRequest;
-(void)refreshRequest:(NSURL *)url params:(NSMutableDictionary *)params;
@end
