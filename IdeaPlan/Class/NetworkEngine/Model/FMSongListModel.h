//
//  FMSongListModel.h
//  LizhiFM
//
//  Created by Chargechen on 14-7-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSongListModel : NSObject
@property (nonatomic,assign) int artist_id;
@property (nonatomic,assign) int all_artist_ting_uid;
@property (nonatomic,assign) int all_artist_id;
@property (nonatomic,strong) NSString * language;
@property (nonatomic,strong) NSString * publishtime;
@property (nonatomic,assign) int album_no;
@property (nonatomic,strong) NSString * pic_big;
@property (nonatomic,strong) NSString * pic_small;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,assign) int  area;
@property (nonatomic,strong) NSString *lrclink;
@property (nonatomic,assign) int hot;
@property (nonatomic,assign) int file_duration;
@property (nonatomic,assign) int del_status;
@property (nonatomic,assign) int resource_type;
@property (nonatomic,assign) int copy_type;
@property (nonatomic,assign) int relate_status;
@property (nonatomic,assign) int all_rate;
@property (nonatomic,assign) int has_mv_mobile;
@property (nonatomic,assign) long long toneid;
@property (nonatomic,assign) long long song_id;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,assign) long long ting_uid;
@property (nonatomic,strong) NSString * author;
@property (nonatomic,assign) long long album_id;
@property (nonatomic,strong) NSString * album_title;
@property (nonatomic,assign) int  is_first_publish;
@property (nonatomic,assign) int  havehigh;
@property (nonatomic,assign) int charge;
@property (nonatomic,assign) int  has_mv;
@property (nonatomic,assign) int  learn;
@property (nonatomic,assign) int  piao_id;
@property (nonatomic,assign) long long listen_total;

@end

@interface FMSongList : NSObject
@property (nonatomic,assign) int songnums;
@property (nonatomic,assign) BOOL havemore;
@property (nonatomic,assign) int error_code;
@property (nonatomic,strong) NSMutableArray * songLists;
@end
