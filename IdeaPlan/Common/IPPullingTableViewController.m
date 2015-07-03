//
//  AMTableViewController.m
//  GetAdMoney
//
//  Created by Charge on 14-4-6.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "AMPullingTableViewController.h"
#import "UINavigationBar+CustomImage.h"
#import "AMPofileModel.h"
@interface AMPullingTableViewController ()

@end

@implementation AMPullingTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height)];
		view.delegate = self;
		[_tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	[self refreshRequest];
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}
//判断刷新状态情况，正在刷新或者是没刷新
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

- (void)dealloc {
	_refreshHeaderView = nil;
}

#pragma mark - 子类方法
-(void)didRequestSucceed:(NSDictionary *)response
{
    [_tableView reloadData];
}

-(void)didRequestFailed:(NSError *)error
{
    [_tableView reloadData];
}

-(void)refreshRequest
{

}
-(void)refreshRequest:(NSURL *)url params:(NSMutableDictionary *)params
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    NSString *userId = [Common getUserId];
    NSString *userNick = [Common getUserNick];
    //header
    NSDictionary *header = @{@"appVer":@1.0,@"os":@"ios",@"imei":[Common getDeviceInfo],@"userNick":userNick?userNick:@""};
    NSMutableDictionary *headerDic = [NSMutableDictionary dictionaryWithDictionary:header];
    if (userId) {
        [headerDic setObject:userId forKey:@"userId"];
    }
    NSString *headJson = [headerDic JSONString];
    //body
    NSString *bodyJson = [[params objectForKey:@"body"] JSONString];
    [request addPostValue:headJson forKey:@"header"];
    [request addPostValue:[params objectForKey:@"reqCode"] forKey:@"reqCode"];
    [request addPostValue:bodyJson forKey:@"body"];
    
//    for (id key in params){
//        [request addPostValue:[params objectForKey:key] forKey:key];
//    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    NSLog(@"<<<<发送请求%@",[NSDate date]);

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    //todo 上线前干掉
    if (responseString.length>1000) {
        [self.view makeToast:@"DEBUG:网络错误~" duration:2 position:kActivityDefaultPosition];
    }
    NSLog(@">>>>收到回包%@",[NSDate date]);
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    NSDictionary *jason = [responseData objectFromJSONData];
    NSString *errorCode = [jason objectForKey:@"errCode"];
    if ([errorCode intValue] != 0) {
        [self.view makeToast:[jason objectForKey:@"errMsg"] duration:2 position:kActivityDefaultPosition];
        return ;
    }
    NSDictionary *myInfo = [jason objectForKey:@"myInfo"];
    if (myInfo) {
        AMPofileModel *profile = [[AMPofileModel alloc] init];
        profile.userId = [myInfo objectForKey:@"userId"];
        profile.userNick = [myInfo objectForKey:@"nickName"];
        profile.level = [myInfo objectForKey:@"level"];
        profile.levelRight = [myInfo objectForKey:@"levelRight"];
        
        [Common setCustomCache:profile forKey:@"profile"];
    }
    
    [self didRequestSucceed:jason];
    [self doneLoadingTableViewData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.view makeToast:@"亲~网络有问题，刷新一下" duration:2 position:kActivityDefaultPosition];
    NSError *error = [request error];
    NSLog(@">>>>网络错误：%@",error);
    [self didRequestFailed:error];
    [self doneLoadingTableViewData];
}

@end