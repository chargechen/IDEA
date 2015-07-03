//
//  LZImageFileMgr.m
//  Italk
//
//  Created by wzsam on 13-3-15.
//  Copyright (c) 2013年 yibasan. All rights reserved.
//

#import "IPImageFileMgr.h"
#import "NSString+MD5.h"

@interface IPImageFileMgr (PrivateMethod)
- (void)checkCreateDirectionary;
- (NSString *)getPhotoPathWithFileID:(NSString *)fileID;
@end

@implementation IPImageFileMgr
+ (instancetype)shareInstance
{
    static IPImageFileMgr *kImageFileMgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kImageFileMgr = [[IPImageFileMgr alloc] init];
    });
    return kImageFileMgr;
}

- (void)savePhoto:(NSData *)fileData fileID:(NSString *)fileID{
    CHECK(fileData);
    CHECK([fileData length] > 0);
    CHECK(fileID);
    CHECK([fileID length] > 0);
    
    [self checkCreateDirectionary];
    
    if (![self isPhotoExist:fileID]) {
        CHECK([fileData writeToFile:[self getPhotoPathWithFileID:fileID] atomically:YES]);
    }
}

- (void)movePhoto:(NSString *)oldFileID newFileID:(NSString *)newFileID{
    CHECK(oldFileID);
    CHECK([oldFileID length] > 0);
    CHECK(newFileID);
    CHECK([newFileID length] > 0);
    
    if (![self isPhotoExist:oldFileID]) {
    }
    
    CHECK([[NSFileManager defaultManager] moveItemAtPath:[self getPhotoPathWithFileID:oldFileID] toPath:[self getPhotoPathWithFileID:newFileID] error:nil]);
}

- (BOOL)isPhotoExist:(NSString *)fileID{
    CHECKB(fileID);
    CHECKB([fileID length] > 0);
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self getPhotoPathWithFileID:fileID]];
}

- (UIImage *)getPhoto:(NSString *)fileID{
    CHECKP(fileID);
    CHECKP([fileID length] > 0);
    
    if (![self isPhotoExist:fileID]) {
        return nil;
    }
    
    UIImage *image = [[[UIImage alloc] initWithContentsOfFile:[self getPhotoPathWithFileID:fileID]] autorelease];
    
    return image;
}

- (void)checkCreateDirectionary {
    NSMutableArray *arrPath = [NSMutableArray arrayWithObjects:kPhotoPath, nil];
    
    for (NSString *path in arrPath) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *directoryPath = [NSHomeDirectory() stringByAppendingString:path];
        BOOL isDirectory = NO;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory] || !isDirectory) {
            CHECK([[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil]);
        }
        
        [pool drain];
    }
}

- (NSString *)getPhotoPathWithFileID:(NSString *)fileID  {
    CHECKP(fileID);
    CHECKP([fileID length] > 0);
    
    return [[NSHomeDirectory() stringByAppendingString:kPhotoPath] stringByAppendingString:[fileID md5String]];
}

@end
