//
//  IPMineViewController.m
//  IdeaPlan
//
//  Created by chargechen on 14/12/24.
//  Copyright (c) 2014年 JUNBAO. All rights reserved.
//

#import "IPMineViewController.h"
#import "IPWebViewController.h"
@interface IPMineViewController ()
{
    NSInteger _levelValue;
    NSInteger _yuanbaoValue;
    AMPofileModel* _profile;
}
@end
@interface IPMineViewController ()

@end

@implementation IPMineViewController

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = @"我";
        AMPofileModel *profile = [[AMPofileModel alloc] init];
        profile.userId = @"10000";
        profile.userNick = @"点子达人";
        profile.level = @1;
        profile.levelRight = @"可收藏10篇文章";
        _profile = profile;
        
        [Common setCustomCache:_profile forKey:@"profile"];
        

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    //先从本地读取
    _profile = [Common getCustomCacheForKey:@"profile"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return 2;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return [self configueAccountCell:tableView atIndexPath:indexPath];
    }
    //    else if(indexPath.section == 1)
    //    {
    //        return [self configueZhifubaoCell:tableView atIndexPath:indexPath];
    //    }
    else
    {
        return [self configueSettingCell:tableView atIndexPath:indexPath];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1)
    {
        
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            
        }
        else
        {
           
        }
        
    }
    else if(indexPath.section == 3)
    {
        
    }

}

#pragma mark - configue table cell
-(UITableViewCell *)configueAccountCell:(UITableView*)tableView atIndexPath:(NSIndexPath *)indexPath
{
    AMProfileCell *cell = [[AMProfileCell alloc] initWithModel:_profile];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
    
    if (indexPath.section ==0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    UIImage *icon = [UIImage imageNamed:@"bg_profile_empty.png"];
    cell.imageView.image = icon;
    return cell;
    
}

-(UITableViewCell *)configueSettingCell:(UITableView*)tableView atIndexPath:(NSIndexPath*)indexPath
{
    static NSString *identifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    UIImage *icon = nil;
    NSString *titleText = @"";
    
    if(indexPath.section == 1)
    {
        icon  =[UIImage imageNamed:@"ic_favorite.png"];
        titleText = @"我的收藏";
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            icon  =[UIImage imageNamed:@"ic_good.png"];
            titleText = @"赏个好评";
        }
        else
        {
            icon  =[UIImage imageNamed:@"ic_advice.png"];
            titleText = @"意见反馈";
        }

    }
    else if(indexPath.section == 3)
    {
        icon  =[UIImage imageNamed:@"ic_about.png"];
        titleText = @"关于";
    }
    
    cell.imageView.image = icon;
    
    cell.textLabel.text = titleText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark -
-(CGAffineTransform)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    float sw=size.width/image.size.width;
    float sh=size.height/image.size.height;
    return CGAffineTransformMakeScale(sw,sh);
}

#pragma mark -

#pragma mark -

@end
