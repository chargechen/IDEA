//
//  AMTableViewController.h
//  GetAdMoney
//
//  Created by Charge on 14-4-6.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "AMViewController.h"

@interface AMTableViewController : AMViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView  *_tableView;
}
- (id)initWithStyle:(UITableViewStyle)style;
@end
