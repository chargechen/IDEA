//
//  IPTableViewController.h
//  GetAdMoney
//
//  Created by Charge on 14-4-6.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "IPViewController.h"

@interface IPTableViewController : IPViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView  *_tableView;
}
- (id)initWithStyle:(UITableViewStyle)style;
@end
