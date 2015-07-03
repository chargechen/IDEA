//
//  FavoriteDao.m
//  GetAdMoney
//
//  Created by charge on 14-5-23.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "FavoriteDao.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FavoriteDao+DBInfoTable.h"
#import "FavoriteDao+list.h"

#define TASK_DB_FIELNAME   @"favorite.db"

static FavoriteDao *sharedInstance = nil;

@implementation FavoriteDao
{
    NSString * _deviceInfo;
}
+ (FavoriteDao*)sharedInstance
{
    if(sharedInstance == nil)
    {
        @synchronized(self)
        {
            if (sharedInstance == nil)
            {
                sharedInstance = [[FavoriteDao alloc] init];
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
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"FavoriteDao.%@", self] UTF8String], NULL);
//        _deviceInfo = 0;
    }
    return self;
}

-(void) initDBTable
{
    if(_deviceInfo != [Common getIFV])
    {
        [self createDBTable];
        _deviceInfo = [Common getIFV];
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
            NSLog(@"Failed to close database for favorite.");
        }
        
        if (![[NSFileManager defaultManager] removeItemAtPath:_dbFile error:nil])
        {
            NSLog(@"Failed to delete database file for favorite.");
        }
    }
}

- (NSArray*)getFavoriteList
{
    NSArray *favoriteList = nil;
    
    @synchronized(self)
    {
        favoriteList = [self queryFavoriteTable];
    }
    return favoriteList;
}

- (IPArticleModel *)getFavoriteInfoById:(long long)favoriteId
{
    IPArticleModel * favoriteInfo = nil;
    @synchronized(self)
    {
        favoriteInfo = [self queryFavoriteTableById:favoriteId];
    }
    return favoriteInfo;
}


- (void)setFavoriteList:(NSArray*)list
{
    dispatch_async(_queue, ^(void)
                   {
                       @synchronized(self)
                       {
                           [_database beginTransaction];
                           BOOL ret = YES;

                           for (IPArticleModel * favoriteInfo in list)
                           {
                               ret = [self updateFavoriteTable:favoriteInfo];
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

- (void)updateFavoriteInfo:(IPArticleModel *)favoriteInfo
{
    @synchronized(self)
    {
        [self updateFavoriteTable:favoriteInfo];
    }
}

- (void)clearFavoriteList
{
    dispatch_async(_queue, ^(void)
                   {
                       @synchronized(self)
                       {
                           [self deleteFavoriteTable];
                       }
                   });
}
-(void)deleteFavoriteInfo:(long long)favoriteId
{
    //    dispatch_async(_queue, ^(void){
    @synchronized(self)
    {
        [self deleteFavoriteTable:favoriteId];
    }
    //    });
}

@end
