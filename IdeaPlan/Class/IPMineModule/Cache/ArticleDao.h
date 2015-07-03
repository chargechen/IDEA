//
//  FavoriteDao.h
//  GetAdMoney
//
//  Created by charge on 14-5-23.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "IPArticleModel.h"
@interface FavoriteDao : NSObject
{
    dispatch_queue_t    _queue;
    NSString            *_dbFile;
    FMDatabase          *_database;
}
+ (FavoriteDao *)sharedInstance;
-(void)initDBTable;
//获取收藏列表
- (NSArray*)getFavoriteList;
//获取某个收藏文章
- (id)getFavoriteInfoById:(long long)favoriteId;
//更新任务列表
- (void)setFavoriteList:(NSArray*)list;
//更新(删除后从队尾插入)某个任务数据
- (void)updateFavoriteInfo:(IPArticleModel *)favoriteInfo;

-(void)clearFavoriteList;
-(void)deleteFavoriteInfo:(long long)favoriteId;

- (void)clear;
@end
