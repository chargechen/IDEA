//
//  NSPathEx.m
//  GetAdMoney
//
//  Created by Charge on 14-5-18.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "NSPathEx.h"
//#import <CommonCrypto/CommonDigest.h>

void DeleteFile(const char *path)
{
	if(path == NULL) return;
	[NSPathEx RemovePath: [NSString stringWithFormat:@"%s", path]];
}

@implementation NSPathEx

+(NSString *) HomePath
{
	return NSHomeDirectory();
}

+(NSString *) TempPath
{
	NSString *path = [NSTemporaryDirectory() stringByStandardizingPath];
	return path;
}

+(NSString *) DocPath
{
    static NSString *documentsDirectory = nil;
    if (documentsDirectory) {
        return documentsDirectory;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

+(NSString *) AppPath
{
    return [[NSBundle mainBundle] bundlePath];
}

+(NSString*)LibPath
{
    static NSString *libraryDirectory = nil;
    if (libraryDirectory) {
        return libraryDirectory;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    libraryDirectory = [paths objectAtIndex:0];
	return libraryDirectory;
}

+(void)RemovePath:(NSString *)path
{
	if (path == nil) 	return;
	NSFileManager * FM = [NSFileManager defaultManager];
	[FM removeItemAtPath: path error: NULL];
	return;
}

+(void) moveFile:(NSString*)srcPath To:(NSString*)destPath
{
	if (srcPath == nil) {
		return;
	}
	
	if (destPath == nil) {
		[NSPathEx RemovePath:srcPath];
		return;
	}
	
	[NSPathEx RemovePath:destPath];
	
	//
	NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err = nil;
	[fm moveItemAtPath:srcPath toPath:destPath error:&err];
    //移动位置出错
    if (err) {
        NSLog(@"move file from %@ to %@, error:%@",srcPath,destPath,err);
    }
}

+(void) copyFile:(NSString*)srcPath To:(NSString*)destPath
{
    if (srcPath == nil) {
		return;
	}
	
	if (destPath == nil) {
		[NSPathEx RemovePath:srcPath];
		return;
	}
	
	[NSPathEx RemovePath:destPath];
	
	//
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm copyItemAtPath:srcPath toPath:destPath error:nil];
}

+(BOOL) isFileExist:(NSString*)path
{
    if (path.length == 0)
        return NO;
    
	NSFileManager *fm = [NSFileManager defaultManager];
	return [fm fileExistsAtPath:path];
}

@end

const char* getCachePath()
{
	return [[NSPathEx DocPath] UTF8String];
}