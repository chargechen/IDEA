//
//  IPMineViewController.m
//  IdeaPlan
//
//  Created by chargechen on 14/12/24.
//  Copyright (c) 2014年 JUNBAO. All rights reserved.
//

#import "IPMineViewController.h"

@interface IPMineViewController ()

@end

@implementation IPMineViewController

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.title = @"我";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tabImageName
{
    return @"tabbar3";
}

- (NSString *)tabTitle
{
    return self.title;
}
@end
