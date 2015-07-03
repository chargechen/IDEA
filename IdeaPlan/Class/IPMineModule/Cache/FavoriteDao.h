//
//  AMTaskCache.h
//  GetAdMoney
//
//  Created by charge on 14-5-23.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "AMTaskModel.h"
#import "Common.h"

@interface AMTaskCache : NSObject
{
    dispatch_queue_t    _queue;
    NSString            *_dbFile;
    FMDatabase          *_database;
}
+ (AMTaskCache *)sharedInstance;
-(void)initDBTable;
//获取任务列表
- (NSArray*)getTaskList;
//获取某个任务数据
- (id)getTaskInfoById:(long long)taskId;
//更新任务列表
- (void)setTaskList:(NSArray*)list;
//更新(删除后从队尾插入)某个任务数据
- (void)updateTaskInfo:(AMTaskModel *)taskInfo;

-(void)clearTaskList;
-(void)deleteTaskInfo:(long long)taskId;

- (void)clear;
@end
