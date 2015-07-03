//
//  AMTableViewController.m
//  GetAdMoney
//
//  Created by Charge on 14-4-6.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "AMTableViewController.h"

@interface AMTableViewController ()
{
    UITableViewStyle _tableViewStyle;
}
@end

@implementation AMTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _tableViewStyle = style;
    }
    return self;
}

- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    if (_tableViewStyle != UITableViewStylePlain) {
        tableView.backgroundView = [[UIView alloc] init];
    }
    tableView.dataSource = self;
    tableView.delegate = self;
    _tableView = tableView;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
    }
}
- (void)viewDidUnload
{
    _tableView = nil;
    [super viewDidUnload];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_tableViewStyle != UITableViewStylePlain) {
        return 10;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_tableViewStyle != UITableViewStylePlain) {
        return 5;
    }
    return 0;
}

@end
