//
//  FavoriteDao+FavoriteList.m
//  GetAdMoney
//
//  Created by Charge on 14-5-27.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "FavoriteDao+list.h"
// 创建任务列表
static NSString *createFavoriteTableSql = @"create table if not exists favoriteList_%@( \
fid                long long,\
title           varchar(255),\
subTitle           varchar(255),\
thumbUrl            varchar(255),\
PRIMARY KEY(fid))";

// 修改任务列表
static NSString *updateFavoriteTableSql = @"insert or replace into favoriteList_%@( \
fid, \
title, \
subTitle, \
thumbUrl)\
values( \
:fid, \
:title, \
:subTitle, \
:thumbUrl)";

//查询任务
static NSString *queryFavoriteTableSql = @"select * from favoriteList_%@";
//查询一条任务
static NSString *queryOneFavoriteTableSql = @"select * from favoriteList_%@ where fid = ?";
//删除任务表
static NSString *dropFavoriteTableSql = @"drop table if exists favoriteList_%@";
//删除所有任务记录
static NSString *deleteFavoriteTableAllSql =@"delete from favoriteList_%@";
// 删除某条任务记录
static NSString *deleteFavoriteTableSql = @"delete from favoriteList_%@ where fid = ?";

@implementation FavoriteDao (FavoriteList)
#pragma mark - favorite table
// 创建任务表
- (void)createFavoriteTable
{
    NSString *deviceInfo = [Common getIFV];
    NSString *createSql = createFavoriteTableSql;
    
    if (![_database executeUpdate:[NSString stringWithFormat:createSql,deviceInfo]])
    {
        NSLog(@"Failed to create favorite table.");
    }
}

// 删除任务表
- (void)dropFavoriteTable
{
    NSString *deviceInfo = [Common getIFV];
    NSString *dropSql = dropFavoriteTableSql;
    if (![_database executeUpdate:[NSString stringWithFormat:dropSql,deviceInfo]])
    {
        NSLog(@"Failed to drop favorite table.");
    }
}

// 查询某条任务
- (IPArticleModel *)queryFavoriteTableById:(long long)favoriteId
{
    NSString* deviceInfo = [Common getIFV];
    FMResultSet *result = [_database executeQuery:[NSString stringWithFormat:queryOneFavoriteTableSql,deviceInfo], [NSNumber numberWithLongLong:favoriteId]];
    if (!result)
    {
        NSLog(@"Failed to query the table for my favorite.");
        return nil;
    }
    IPArticleModel *info = nil;
    while ([result next])
    {
        @try{
            info = [[IPArticleModel alloc] init];

            info.articleId = [result longLongIntForColumn:@"fid"];
            
            info.title = [result stringForColumn:@"title"];
            
            info.subTitle = [result stringForColumn:@"subTitle"];

            info.thumbUrl = [result stringForColumn:@"thumbUrl"];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"Failed to unarchive my favorite info.");
        }
    }
    
    [result close];
    return info;
}

// 查询任务列表
- (NSArray*)queryFavoriteTable
{
    NSString *deviceInfo = [Common getIFV];
    
    FMResultSet *result = [_database executeQuery:[NSString stringWithFormat:queryFavoriteTableSql, deviceInfo]];
    if (!result)
    {
        NSLog(@"Failed to query table for my favorite.");
        return nil;
    }
    
    NSMutableArray *favoriteList = [[NSMutableArray alloc]init];
    
    while ([result next])
    {
        @try{
            IPArticleModel *info = [[IPArticleModel alloc] init];
            
            info.articleId = [result longLongIntForColumn:@"fid"];
            
            info.title = [result stringForColumn:@"title"];
            info.subTitle = [result stringForColumn:@"subTitle"];
            info.thumbUrl = [result stringForColumn:@"thumbUrl"];

            [favoriteList addObject:info];
        }
        @catch (NSException *exception)
        {
            NSLog(@"Failed to unarchive my favorite info.");
        }
    }
    
    [result close];
    return favoriteList;
}

// 更新任务表
- (BOOL)updateFavoriteTable:(IPArticleModel *)favoriteInfo
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSNumber *fid = [NSNumber numberWithLongLong:favoriteInfo.articleId];
    NSString *title = favoriteInfo.title;
    NSString *subTitle = favoriteInfo.subTitle;
    NSString *thumbUrl = favoriteInfo.thumbUrl;

    [parameters setObject:fid ? fid : @0 forKey:@"fid"];
    [parameters setObject:title ? title : @"" forKey:@"title"];
    [parameters setObject:subTitle ? subTitle : @"" forKey:@"subTitle"];
    [parameters setObject:thumbUrl ? thumbUrl : @"" forKey:@"thumbUrl"];

    
    NSString* deviceInfo = [Common getIFV];
    BOOL ret = [_database executeUpdate:[NSString stringWithFormat:updateFavoriteTableSql, deviceInfo] withParameterDictionary:parameters];
    if (!ret)
    {
        NSLog(@"Failed to update my favorite table.");
    }
    return ret;
}

// 删除任务表中的所有记录
- (void)deleteFavoriteTable
{
    NSString *deleteSql = deleteFavoriteTableAllSql;
    
    NSString *deviceInfo = [Common getIFV];
    
    if (![_database executeUpdate:[NSString stringWithFormat:deleteSql,deviceInfo]])
    {
        NSLog(@"Failed to delete favorite table.");
    }
    
}
// 删除某条 我的任务表中的记录
- (void)deleteFavoriteTable:(long long)favoriteId
{
    NSString *deviceInfo = [Common getIFV];
    NSString *deleteSql = deleteFavoriteTableSql;
    
    if (![_database executeUpdate:[NSString stringWithFormat:deleteSql,deviceInfo],
          [NSNumber numberWithLongLong:favoriteId]])
    {
        NSLog(@"Failed to delete the favorite table.");
    }
    
}
@end
