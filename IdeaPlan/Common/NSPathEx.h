//
//  NSPathEx.h
//  GetAdMoney
//
//  Created by Charge on 14-5-18.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSPathEx : NSObject
{
}

+(NSString*)HomePath;
+(NSString*)TempPath;
+(NSString*)DocPath;
+(NSString*)AppPath;
+(NSString*)LibPath;

+(void)RemovePath:(NSString *)path;

// 将文件从srcPath移到destPath
+(void) moveFile:(NSString*)srcPath To:(NSString*)destPath;

// 将文件从srcPath拷贝到destPath
+(void) copyFile:(NSString*)srcPath To:(NSString*)destPath;

// 指定目录的文件是否存在
+(BOOL) isFileExist:(NSString*)path;

@end

