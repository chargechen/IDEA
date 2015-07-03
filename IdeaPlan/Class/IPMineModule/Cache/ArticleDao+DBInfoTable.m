//
//  FavoriteDao+DBInfoTable.m
//  GetAdMoney
//
//  Created by charge on 14-5-23.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "FavoriteDao+DBInfoTable.h"
#import "FavoriteDao+list.h"

//创建DB信息表
static NSString *createDBInfoTableSql = @"CREATE TABLE IF NOT EXISTS db_info_%@(info_key int, version int, PRIMARY KEY(info_key))";

//查询DB信息表
static NSString *queryDBInfoTableSql = @"SELECT version FROM db_info_%@ where info_key = ?";

//更新DB信息表
static NSString *updateDBInfoTableSql = @"REPLACE INTO db_info_%@(info_key, version) VALUES (?, ?)";

#define TASKLISTVERSION        1       // 任务列表数据库版本
#define TASKDBINFOKEY_PPLISTVERSION        0       // 任务列表数据库信息在dbinfo表中的key

@implementation FavoriteDao (DBInfoTable)
-(void)createDBTable
{
    @synchronized(self)
    {
        if (![_database open])
        {
            NSLog(@"Failed to open database for favorite.");
        }
        
        [self createDBInfoTable];
        
        [self createFavoriteTable];    // 创建新表
    }
}

#pragma mark - db version
// 创建数据库版本信息表
- (void)createDBInfoTable
{
    NSString * deviceInfo = [Common getIFV];
    
    if (![_database executeUpdate:[NSString stringWithFormat:createDBInfoTableSql, deviceInfo]])
    {
        NSLog(@"Failed to create favorite dbinfo table");
    }
}

// 设置数据库版本信息
- (void)setDbVersion:(NSInteger)dbVersion key:(NSInteger)dbVersionKey
{
    NSString * deviceInfo = [Common getIFV];
    
    if (![_database executeUpdate:[NSString stringWithFormat:updateDBInfoTableSql, deviceInfo], [NSNumber numberWithInt:dbVersionKey], [NSNumber numberWithInt:dbVersion]])
    {
        NSLog(@"Failed to update db version for favorite.");
    }
}

// 获取数据库版本信息
- (NSInteger)dbVersion:(NSInteger)dbVersionKey
{
    NSString * deviceInfo = [Common getIFV];
    
    FMResultSet *resultSet = [_database executeQuery:[NSString stringWithFormat:queryDBInfoTableSql, deviceInfo], [NSNumber numberWithInt:dbVersionKey]];
    if (!resultSet)
    {
        NSLog(@"Failed to query db version for favorite.");
        return 0;
    }
    
    NSInteger dbVersion = 0;
    while ([resultSet next])
    {
        dbVersion = [resultSet intForColumn:@"version"];
    }
    return dbVersion;
}


@end

