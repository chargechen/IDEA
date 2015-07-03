//
//  LZWidgetAsyncFetchPhoto.m
//  LizhiFM
//
//  Created by chargechen on 14/10/31.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "LZWidgetAsyncFetchPhoto.h"
#import "LZWidgetPhotoMgr.h"

@implementation LZWidgetAsyncFetchPhoto

@synthesize isFinished = mIsFinished;
@synthesize isNeededRetry = mIsNeededRetry;
@synthesize size = mSize;
@synthesize receivedSize = mReceivedSize;
@synthesize retryCount = mRetryCount;
@synthesize fileID = mFileID;

+ (NSString *)notificationKey:(NSString *)fileID{
    return [NSString stringWithFormat:@"asyncFetchReturnKey+%@", fileID];
}

+ (NSString *)notificationFailedKey:(NSString *)fileID{
    return [NSString stringWithFormat:@"asyncFetchFailedKey+%@", fileID];
}

- (void)dealloc{
}

- (id)initWithURLString:(NSString *)urlString fileID:(NSString *)fileID{
    self = [super init];
    if (self) {
        mUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mFileID  = fileID;
        mIsFinished = NO;
        mIsNeededRetry = NO;
        mRetryCount = 1;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:mUrlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        [request setHTTPMethod:@"GET"];
        
        
        mReceivedData = [[NSMutableData alloc] initWithData:nil];
        mConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    return self;
}

- (void)retryConnect{
    mReceivedData = nil;
    mConnection = nil;
    mIsFinished = NO;
    mIsNeededRetry = NO;
    mRetryCount++;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:mUrlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [request setHTTPMethod:@"GET"];
    mReceivedData = [[NSMutableData alloc] initWithData:nil];
    mConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *httpHeader = [httpResponse allHeaderFields];
        mSize = [[httpHeader valueForKey:@"Content-Length"] intValue];
        
        NSMutableDictionary *processDictionary = [[NSMutableDictionary alloc] init];
        
        [processDictionary setValue:[NSNumber numberWithInt:mSize] forKey:@"size"];
        [processDictionary setValue:[NSNumber numberWithInt:mReceivedSize] forKey:@"receivedSize"];
        [processDictionary setValue:mFileID forKey:@"fileID"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[LZWidgetAsyncFetchPhoto notificationKey:mFileID] object:processDictionary];
        
        processDictionary = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [mReceivedData appendData:data];
    mReceivedSize = [mReceivedData length];
    
    NSMutableDictionary *processDictionary = [[NSMutableDictionary alloc] init];
    
    [processDictionary setValue:[NSNumber numberWithInt:mSize] forKey:@"size"];
    [processDictionary setValue:[NSNumber numberWithInt:mReceivedSize] forKey:@"receivedSize"];
    [processDictionary setValue:mFileID forKey:@"fileID"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[LZWidgetAsyncFetchPhoto notificationKey:mFileID] object:processDictionary];

    processDictionary = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    mIsNeededRetry = YES;
    mIsFinished = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[[LZWidgetPhotoMgr sharedInstance] asyncFailedNotificationKey] object:mFileID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[LZWidgetAsyncFetchPhoto notificationFailedKey:mFileID] object:mFileID];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    mIsFinished = YES;
    UIImage *image =  [UIImage imageWithData:mReceivedData];
    
    if (!image) {
        mIsNeededRetry = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[[LZWidgetPhotoMgr sharedInstance] asyncFailedNotificationKey] object:mFileID];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[LZWidgetAsyncFetchPhoto notificationFailedKey:mFileID] object:mFileID];
        return;
    }
    
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setValue:mReceivedData forKey:@"data"];
    [dataDictionary setValue:mFileID forKey:@"fileID"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[[LZWidgetPhotoMgr sharedInstance] asyncFetchPhotoNotificationKey] object:dataDictionary];
    
    dataDictionary = nil;
    
    NSMutableDictionary *processDictionary = [[NSMutableDictionary alloc] init];
    [processDictionary setValue:[NSNumber numberWithInt:mSize] forKey:@"size"];
    [processDictionary setValue:[NSNumber numberWithInt:mReceivedSize] forKey:@"receivedSize"];
    [processDictionary setValue:mFileID forKey:@"fileID"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[LZWidgetAsyncFetchPhoto notificationKey:mFileID] object:processDictionary];

    processDictionary = nil;
}

@end
