//
//  FMSongListModel.m
//  LizhiFM
//
//  Created by Chargechen on 14-7-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "FMSongListModel.h"

@implementation FMSongListModel
//表名
+(NSString *)getTableName
{
    return @"FMSongListTable";
}
//表版本
+(int)getTableVersion
{
    return 1;
}
+(NSString *)getPrimaryKey
{
    return @"song_id";
}
@end

@implementation FMSongList
-(id)init
{
    if (self = [super init]) {
        self.songLists = [NSMutableArray new];
    }
    return self;
}
@end
