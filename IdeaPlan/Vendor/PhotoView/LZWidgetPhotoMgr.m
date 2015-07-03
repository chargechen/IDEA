//
//  LZWidgetPhotoMgr.m
//  LizhiFM
//
//  Created by chargechen on 14/10/31.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "LZWidgetPhotoMgr.h"
#import "LZWidgetAsyncFetchPhoto.h"
#import "IPImageFileMgr.h"
#import "IPPhotoCacheMgr.h"
static NSInteger kMaxAsyncFetchCount = 8; //最大拉取数
static NSInteger kMaxAsyncRetryCount = 3;  //最大重发数
static NSMutableArray *s_synAryWaitingFileIDs;  // 等待队列
static NSMutableArray *s_synAryFetchingFileIDs; // 正在获取队列
static NSMutableArray *s_asyncAryCount;

@implementation LZWidgetPhotoMgr

@synthesize defaultMaleImage = mDefaultMaleImage;
@synthesize defaultFemaleImage = mDefaultFemaleImage;
@synthesize defaultGroupImage = mDefaultGroupImage;

+ (LZWidgetPhotoMgr *)sharedInstance {
    static dispatch_once_t once;
    static LZWidgetPhotoMgr *sharedInstance;
    dispatch_once(&once, ^ {
        sharedInstance = [[LZWidgetPhotoMgr alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        mDefaultMaleImage = [UIImage imageNamed:@"noimg_male.png"];
        mDefaultFemaleImage = [UIImage imageNamed:@"noimg_female.png"];
        mDefaultGroupImage = [UIImage imageNamed:@"noimg_group.png"];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)startFetch:(NSString *)fileID{
    if (nil == s_synAryWaitingFileIDs) {
        s_synAryWaitingFileIDs = [[NSMutableArray alloc] initWithCapacity:32];
    }
    
    if (nil == s_synAryFetchingFileIDs) {
        s_synAryFetchingFileIDs = [[NSMutableArray alloc] initWithCapacity:32];
    }
    
    if (nil == s_asyncAryCount) {
        s_asyncAryCount = [[NSMutableArray alloc] initWithCapacity:32];
    }
    
    for (NSString *theFielID in s_synAryWaitingFileIDs) {
        if ([fileID isEqualToString:theFielID]) {
            return;
        }
    }
    
    for (NSString *theFileID in s_synAryFetchingFileIDs) {
        if ([fileID isEqualToString:theFileID]) {
            return;
        }
    }
    
    [s_synAryWaitingFileIDs addObject:fileID];
    [self clear];
}

- (void)clear{
    for (NSInteger i = [s_asyncAryCount count] - 1; i >= 0; i--) {
        LZWidgetAsyncFetchPhoto *asyncFetchPhoto = (LZWidgetAsyncFetchPhoto *)[s_asyncAryCount objectAtIndex:i];
        if ([asyncFetchPhoto isFinished]) {
            NSString *fileID = [asyncFetchPhoto fileID];
            
            if ([asyncFetchPhoto isNeededRetry]) {
                if ([asyncFetchPhoto retryCount] < kMaxAsyncRetryCount) {
                    [asyncFetchPhoto retryConnect];
                } else {
                    [s_synAryFetchingFileIDs removeObject:fileID];
                    [s_asyncAryCount removeObjectAtIndex:i];
                }
            } else {
                [s_synAryFetchingFileIDs removeObject:fileID];
                [s_asyncAryCount removeObjectAtIndex:i];
            }
        }
    }
    
    if ([s_asyncAryCount count] < kMaxAsyncFetchCount) {
        [self tryFetch];
    }
}


- (UIImage *)getDefault:(NSInteger)gender{
    switch (gender) {
            //User_GenderFemale
        case 2:
            return mDefaultFemaleImage;
            break;
            //group
        case 3:
            return mDefaultGroupImage;
            break;
            //male
        default:
            return mDefaultMaleImage;
            break;
    }
}


- (void)tryFetch{
    NSString *fileID = nil;
    
    if ([s_synAryWaitingFileIDs count] > 0) {
        fileID = [s_synAryWaitingFileIDs lastObject];
        [s_synAryWaitingFileIDs removeLastObject];
    } else {
        return;
    }
    
    LZWidgetAsyncFetchPhoto *asyncFetchPhoto = [[LZWidgetAsyncFetchPhoto alloc] initWithURLString:fileID fileID:fileID];
    
    [s_asyncAryCount addObject:asyncFetchPhoto];
    
    asyncFetchPhoto = nil;
    fileID = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFetchOK:)
                                                 name:[self asyncFetchPhotoNotificationKey]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFetchFailed:) name:[self asyncFailedNotificationKey] object:nil];
}

//子线程调用
//从本地获取
- (void)onFetchOK:(UIImage *)image fileID:(NSString *)fileID{
    [[IPPhotoCacheMgr shareInstance] addBuffer:fileID photo:image];

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:image forKey:kImageFetched_image];
    [dictionary setValue:fileID forKey:kImageFetched_fileID];
    [dictionary setValue:[NSNumber numberWithBool:YES] forKey:kImageFetched_isFromLocal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[self notificatonKey:fileID]
                                                        object:dictionary];
}

//子线程调用
//从网络获取
- (void)onFetchOK:(NSNotification *)notif{
    
    NSDictionary *dict = (NSDictionary *)notif.object;
    NSData *data = [dict valueForKey:@"data"];
    NSString *fileID = [dict valueForKey:@"fileID"];
    
    UIImage *image = [UIImage imageWithData:data];
    [[IPPhotoCacheMgr shareInstance] addBuffer:fileID photo:image];
    [[IPImageFileMgr shareInstance] savePhoto:data fileID:fileID];
    

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:image forKey:kImageFetched_image];
    [dictionary setValue:fileID forKey:kImageFetched_fileID];
    [dictionary setValue:[NSNumber numberWithBool:NO] forKey:kImageFetched_isFromLocal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[self notificatonKey:fileID] object:dictionary];
    
    [self clear];
}

//子线程调用
- (void)onFetchFailed:(NSNotification *)notif{
    [[NSNotificationCenter defaultCenter] postNotificationName:[self failedNotificationKey: (NSString *)notif.object]
                                                        object:nil];
    [self clear];
}

#pragma mark - NotifycationKey
- (NSString *)asyncFetchPhotoNotificationKey{
    return @"kAsyncFetchPhoto";
}

- (NSString *)asyncFailedNotificationKey{
    return @"kAsyncFetchPhotoFailed";
}

- (NSString *)notificatonKey:(NSString *)fileID{
    return [NSString stringWithFormat:@"kPhotoFetch:%@", fileID];
}

- (NSString *)failedNotificationKey:(NSString *)fileID{
    return [NSString stringWithFormat:@"kPhotoFetchFailed:%@", fileID];
}



@end