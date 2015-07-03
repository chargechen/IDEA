//
//  IPCategoryViewController.m
//  IdeaPlan
//
//  Created by chargechen on 14/12/24.
//  Copyright (c) 2014年 JUNBAO. All rights reserved.
//

#import "IPCategoryViewController.h"

@interface IPCategoryViewController ()

@end

@implementation IPCategoryViewController

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.title = @"分类";
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
    return @"tabbar2";
}

- (NSString *)tabTitle
{
    return self.title;
}
@end
