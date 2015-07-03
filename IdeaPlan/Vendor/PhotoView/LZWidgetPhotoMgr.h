//
//  LZWidgetPhotoMgr.h
//  LizhiFM
//
//  Created by chargechen on 14/10/31.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#define kImageFetchedOK @"kImageFetchedOK"
#define kImageFetchedFailed @"kImageFetchedFailed"

#define kImageFetched_image @"kImageFetched_image"
#define kImageFetched_fileID @"kImageFetched_fileID"
#define kImageFetched_isFromLocal @"kImageFetched_isFromLocal"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LZWidgetPhotoMgr : NSObject{
    UIImage *mDefaultMaleImage;
    UIImage *mDefaultFemaleImage;
    UIImage *mDefaultGroupImage;
}

@property(nonatomic, readonly)UIImage *defaultMaleImage;
@property(nonatomic, readonly)UIImage *defaultFemaleImage;
@property(nonatomic, readonly)UIImage *defaultGroupImage;
+ (LZWidgetPhotoMgr *)sharedInstance;
- (void)startFetch:(NSString *)fileID;
- (void)clear; //清除多余线程

- (NSString *)asyncFetchPhotoNotificationKey;
- (NSString *)asyncFailedNotificationKey;
- (NSString *)notificatonKey:(NSString *)fileID;
- (NSString *)failedNotificationKey:(NSString *)fileID;

- (UIImage *)getDefault:(NSInteger)gender;

@end
