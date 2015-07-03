//
//  IPPhotoCacheMgr.m
//  IdeaPlan
//
//  Created by chargechen on 15/1/2.
//  Copyright (c) 2015年 JUNBAO. All rights reserved.
//

#import "IPPhotoCacheMgr.h"
#import "NSString+MD5.h"

@interface IPPhotoCacheMgr ()
{
    NSMutableDictionary *mSynDicCache;
}

@end
@implementation IPPhotoCacheMgr

+ (instancetype)shareInstance
{
    static IPPhotoCacheMgr *kPhotoCacheMgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kPhotoCacheMgr = [[IPPhotoCacheMgr alloc] init];
    });
    return kPhotoCacheMgr;
}

- (id)init{
    self = [super init];
    if (self) {
        mSynDicCache = [[NSMutableDictionary alloc] initWithCapacity:32];
    }
    return self;
}

- (void)dealloc{
    RELEASE_SAFELY(mSynDicCache);
    [super dealloc];
}

- (UIImage *)getPhotoFromBuffer:(NSString *)fileID{
    CHECKP(fileID);
    CHECKP([fileID length] > 0);
    
    @synchronized(mSynDicCache){
        return [mSynDicCache valueForKey:[fileID md5String]];
    }
}

- (void)addBuffer:(NSString *)fileID photo:(UIImage *)photo{
    CHECK(fileID);
    CHECK([fileID length] > 0);
    CHECK(photo);
    
    @synchronized(mSynDicCache){
        CGSize size = [photo size];
        int64_t pixelCount = ((int64_t)size.width) * ((int64_t)size.height);
        if (pixelCount < 150*150) {
            //[mSynDicCache setValue:photo forKey:[fileID md5String]];
        }
    }
}

- (void)removeFromBuffer:(NSString *)fileID{
    CHECK(fileID);
    CHECK([fileID length] > 0);
    @synchronized(mSynDicCache){
        [mSynDicCache setValue:nil forKey:fileID];
    }
}

- (void)clearBuffer{
    @synchronized(mSynDicCache){
        [mSynDicCache removeAllObjects];
    }
}
@end
