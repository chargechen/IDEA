//
//  AMTaskCache+TaskList.m
//  GetAdMoney
//
//  Created by Charge on 14-5-27.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "AMTaskCache+TaskList.h"
// 创建任务列表
static NSString *createTaskTableSql = @"create table if not exists taskList_%@( \
score                int,\
platform              int,\
taskId           long long,\
PRIMARY KEY(taskId))";

// 修改任务列表
static NSString *updateTaskTableSql = @"insert or replace into taskList_%@( \
score, \
platform, \
taskId)\
values( \
:score, \
:platform, \
:taskId)";

//查询任务
static NSString *queryTaskTableSql = @"select * from taskList_%@";
//查询一条任务
static NSString *queryOneTaskTableSql = @"select * from taskList_%@ where taskId = ?";
//删除任务表
static NSString *dropTaskTableSql = @"drop table if exists taskList_%@";
//删除所有任务记录
static NSString *deleteTaskTableAllSql =@"delete from taskList_%@";
// 删除某条任务记录
static NSString *deleteTaskTableSql = @"delete from taskList_%@ where taskId = ?";

@implementation AMTaskCache (TaskList)
#pragma mark - task table
// 创建任务表
- (void)createTaskTable
{
    NSString *deviceInfo = [Common getDeviceInfo];
    NSString *createSql = createTaskTableSql;
    
    if (![_database executeUpdate:[NSString stringWithFormat:createSql,deviceInfo]])
    {
        NSLog(@"Failed to create task table.");
    }
}

// 删除任务表
- (void)dropTaskTable
{
    NSString *deviceInfo = [Common getDeviceInfo];
    NSString *dropSql = dropTaskTableSql;
    if (![_database executeUpdate:[NSString stringWithFormat:dropSql,deviceInfo]])
    {
        NSLog(@"Failed to drop task table.");
    }
}

// 查询某条任务
- (AMTaskModel *)queryTaskTableById:(long long)taskId
{
    NSString* deviceInfo = [Common getDeviceInfo];
    FMResultSet *result = [_database executeQuery:[NSString stringWithFormat:queryOneTaskTableSql,deviceInfo], taskId];
    if (!result)
    {
        NSLog(@"Failed to query the table for my task.");
        return nil;
    }
    
    AMTaskModel *info = [[AMTaskModel alloc] init];
    while ([result next])
    {
        @try{
            
            info.platform = [result intForColumn:@"platform"];
            
            info.score = [result intForColumn:@"score"];
            
            info.taskId = [result longLongIntForColumn:@"taskId"];
            
        }
        @catch (NSException *exception)
        {
            NSLog(@"Failed to unarchive my task info.");
        }
    }
    
    [result close];
    return info;
}

// 查询任务列表
- (NSArray*)queryTaskTable
{
    NSString *deviceInfo = [Common getDeviceInfo];
    
    FMResultSet *result = [_database executeQuery:[NSString stringWithFormat:queryTaskTableSql, deviceInfo]];
    if (!result)
    {
        NSLog(@"Failed to query table for my task.");
        return nil;
    }
    
    NSMutableArray *taskList = [[NSMutableArray alloc]init];
    
    while ([result next])
    {
        @try{
            AMTaskModel *info = [[AMTaskModel alloc] init];
            
            info.taskId = [result longLongIntForColumn:@"taskId"];
            
            info.score = [result intForColumn:@"score"];
            
            info.platform = [result intForColumn:@"platform"];
            
            [taskList addObject:info];
        }
        @catch (NSException *exception)
        {
            NSLog(@"Failed to unarchive my task info.");
        }
    }
    
    [result close];
    return taskList;
}

// 更新任务表
- (BOOL)updateTaskTable:(AMTaskModel *)taskInfo
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSNumber *score = [NSNumber numberWithInt:taskInfo.score];
    NSNumber *platformType = [NSNumber numberWithInt:taskInfo.platform];
    NSNumber *taskId = [NSNumber numberWithLongLong:taskInfo.taskId];

    [parameters setObject:score ? score : @0 forKey:@"score"];
    [parameters setObject:platformType ? platformType : @1 forKey:@"platform"];
    [parameters setObject:taskId ? taskId : @0 forKey:@"taskId"];

    
    NSString* deviceInfo = [Common getDeviceInfo];
    BOOL ret = [_database executeUpdate:[NSString stringWithFormat:updateTaskTableSql, deviceInfo] withParameterDictionary:parameters];
    if (!ret)
    {
        NSLog(@"Failed to update my task table.");
    }
    return ret;
}

// 删除任务表中的所有记录
- (void)deleteTaskTable
{
    NSString *deleteSql = deleteTaskTableAllSql;
    
    NSString *deviceInfo = [Common getDeviceInfo];
    
    if (![_database executeUpdate:[NSString stringWithFormat:deleteSql,deviceInfo]])
    {
        NSLog(@"Failed to delete task table.");
    }
    
}
// 删除某条 我的任务表中的记录
- (void)deleteTaskTable:(long long)taskId
{
    NSString *deviceInfo = [Common getDeviceInfo];
    NSString *deleteSql = deleteTaskTableSql;
    
    if (![_database executeUpdate:[NSString stringWithFormat:deleteSql,deviceInfo],taskId])
    {
        NSLog(@"Failed to delete the task table.");
    }
    
}
@end
