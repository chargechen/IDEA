//
//  FMSongModel.h
//  LizhiFM
//
//  Created by Chargechen on 14-7-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FMSongModel : NSObject
@property (nonatomic,assign) long long  queryId;
@property (nonatomic,assign) long long  songId;
@property (nonatomic,strong) NSString * songName;
@property (nonatomic,assign) long long  artistId;
@property (nonatomic,strong) NSString * artistName;
@property (nonatomic,assign) long long  albumId;
@property (nonatomic,strong) NSString * albumName;
@property (nonatomic,strong) NSString * songPicSmall;
@property (nonatomic,strong) NSString * songPicBig;
@property (nonatomic,strong) NSString * songPicRadio;
@property (nonatomic,strong) NSString * lrcLink;
@property (nonatomic,strong) NSString * version;
@property (nonatomic,assign) int copyType;
@property (nonatomic,assign) int time;
@property (nonatomic,assign) int linkCode;
@property (nonatomic,strong) NSString * songLink;
@property (nonatomic,strong) NSString * showLink;
@property (nonatomic,strong) NSString * format;
@property (nonatomic,assign) int rate;
@property (nonatomic,assign) long long  size;
@end
