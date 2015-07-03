//
//  AMTaskCache.m
//  GetAdMoney
//
//  Created by charge on 14-5-23.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "AMTaskCache.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "AMTaskCache+DBInfoTable.h"
#import "AMTaskCache+TaskList.h"

#define TASK_DB_FIELNAME   @"task.db"

static AMTaskCache *sharedInstance = nil;

@implementation AMTaskCache
{
    NSString * _deviceInfo;
}
+ (AMTaskCache*)sharedInstance
{
    if(sharedInstance == nil)
    {
        @synchronized(self)
        {
            if (sharedInstance == nil)
            {
                sharedInstance = [[AMTaskCache alloc] init];
            }
        }
    }
    [sharedInstance initDBTable];
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
		_dbFile = [path stringByAppendingPathComponent:TASK_DB_FIELNAME];
        
        _database = [FMDatabase databaseWithPath:_dbFile];
		[_database setLogsErrors:YES];
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"AMTaskCache.%@", self] UTF8String], NULL);
//        _deviceInfo = 0;
    }
    return self;
}

-(void) initDBTable
{
    if(_deviceInfo != [Common getDeviceInfo])
    {
        [self createDBTable];
        _deviceInfo = [Common getDeviceInfo];
    }
}

- (void)dealloc
{
    @synchronized(self)
    {
        [_database close];
        _database = nil;
        _dbFile = nil;
    }
    dispatch_release(_queue);
    _deviceInfo = nil;
    _queue = 0x00;
}

#pragma mark Public

- (void)clear
{
    @synchronized(self)
    {
        _deviceInfo = nil;
        if (![_database close])
        {
            NSLog(@"Failed to close database for task.");
        }
        
        if (![[NSFileManager defaultManager] removeItemAtPath:_dbFile error:nil])
        {
            NSLog(@"Failed to delete database file for task.");
        }
    }
}

- (NSArray*)getTaskList
{
    NSArray *taskList = nil;
    
    @synchronized(self)
    {
        taskList = [self queryTaskTable];
    }
    return taskList;
}

- (AMTaskModel *)getTaskInfoById:(long long)taskId
{
    AMTaskModel * taskInfo = nil;
    @synchronized(self)
    {
        taskInfo = [self queryTaskTableById:taskId];
    }
    return taskInfo;
}


- (void)setTaskList:(NSArray*)list
{
    dispatch_async(_queue, ^(void)
                   {
                       @synchronized(self)
                       {
                           [_database beginTransaction];
                           BOOL ret = YES;

                           for (AMTaskModel * taskInfo in list)
                           {
                               ret = [self updateTaskTable:taskInfo];
                               if(!ret)
                               {
                                   break;
                               }
                           }
                           
                           if(ret)
                           {
                               [_database commit];
                           }
                           else
                           {
                               [_database rollback];
                           }
                       }
                   });
}

- (void)updateTaskInfo:(AMTaskModel *)taskInfo
{
    @synchronized(self)
    {
        [self updateTaskTable:taskInfo];
    }
}

- (void)clearTaskList
{
    dispatch_async(_queue, ^(void)
                   {
                       @synchronized(self)
                       {
                           [self deleteTaskTable];
                       }
                   });
}
-(void)deleteTaskInfo:(long long)taskId
{
    //    dispatch_async(_queue, ^(void){
    @synchronized(self)
    {
        [self deleteTaskTable:taskId];
    }
    //    });
}

@end
