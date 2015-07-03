//
//  LZWidgetAsyncFetchPhoto.h
//  LizhiFM
//
//  Created by chargechen on 14/10/31.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LZWidgetAsyncFetchPhoto : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData *mReceivedData;
    NSURLConnection *mConnection;
    UInt32 mSize;
    UInt32 mReceivedSize;
    UInt8 mRetryCount;
    BOOL mIsFinished;
    BOOL mIsNeededRetry;
    NSString *mFileID;
    NSString *mUrlString;
}

@property(nonatomic, assign)BOOL isFinished;
@property(nonatomic, assign)BOOL isNeededRetry;
@property(nonatomic, assign)UInt32 size;
@property(nonatomic, assign)UInt32 receivedSize;
@property(nonatomic, assign)UInt8 retryCount;
@property(nonatomic, strong)NSString *fileID;

+ (NSString *)notificationKey:(NSString *)fileID;
+ (NSString *)notificationFailedKey:(NSString *)fileID;

- (id)initWithURLString:(NSString *)urlString fileID:(NSString *)fileID;
- (void)retryConnect;
@end

