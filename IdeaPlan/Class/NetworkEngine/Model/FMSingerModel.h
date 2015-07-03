//
//  FMSingerModel.h
//  LizhiFM
//
//  Created by Chargechen on 14-7-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSingerModel : NSObject
@property (nonatomic,assign) long long  ting_uid;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * firstchar;
@property (nonatomic,assign) int gender;
@property (nonatomic,assign) int area;
@property (nonatomic,strong) NSString * country;
@property (nonatomic,strong) NSString * avatar_big;
@property (nonatomic,strong) NSString * avatar_middle;
@property (nonatomic,strong) NSString * avatar_small;
@property (nonatomic,strong) NSString * avatar_mini;
@property (nonatomic,strong) NSString * constellation;
@property (nonatomic,assign) float stature;
@property (nonatomic,assign) float weight;
@property (nonatomic,strong) NSString * bloodtype;
@property (nonatomic,strong) NSString * company;
@property (nonatomic,strong) NSString * intro;
@property (nonatomic,assign) int albums_total;
@property (nonatomic,assign) int songs_total;
@property (nonatomic,assign) NSDate * birth;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,assign) int artist_id;
@property (nonatomic,strong) NSString * avatar_s180;
@property (nonatomic,strong) NSString * avatar_s500;
@property (nonatomic,strong) NSString * avatar_s1000;
@property (nonatomic,assign) int piao_id;

-(NSMutableArray *)itemWith:(NSString *)name;
-(NSMutableArray *)itemTop100;
@end
