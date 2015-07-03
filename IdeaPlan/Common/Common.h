//
//  Common.h
//  GetAdMoney
//
//  Created by Charge on 14-4-22.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject
+ (NSString *)getDeviceName;
+ (NSString *)getDeviceInfo;
+ (NSString *)getDeviceInfoEx;

+ (NSString *)getSystemVersion;
+ (CGFloat)systemVersion;
+ (NSString *)systemVersionString;
+ (BOOL)iOS7;

+ (NSString *)getUserNick;
+ (NSString *)getUserId;

+ (id)getDefaultCacheForKey:(NSString *)key;
+ (void)setDefaultCache:(id)value forKey:(NSString *)key;
+ (void)setCustomCache:(id)value forKey:(NSString *)key;
+ (id)getCustomCacheForKey:(NSString *)key;

+ (NSString *)getRealString:(NSString *)text;
+ (NSUInteger)getStringLength:(NSString *)text;

+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validateMobile:(NSString *)mobile;
+ (BOOL) validateUserName:(NSString *)name;
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) validateNickname:(NSString *)nickname;


@end
