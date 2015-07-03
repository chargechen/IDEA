//
//  Common.m
//  GetAdMoney
//
//  Created by Charge on 14-4-22.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "Common.h"
#import "AMPofileModel.h"
#import <AdSupport/AdSupport.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
@implementation Common
#pragma mark - Device & System Info

+ (NSDictionary *)infoDictionary
{
    static NSDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSBundle mainBundle] infoDictionary];
    }
    return dictionary;
}

+ (NSString *)getDeviceName
{
   	static NSString *platform;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = (char*)malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        if (machine == NULL) {
            platform = @"i386";
        } else {
            platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        }
        free(machine);
    });
	return platform;
}

+ (NSString *)getDeviceInfo
{
    static NSString *kCommonDeviceInfo = nil;
    
    if (kCommonDeviceInfo == nil) {
        //手机唯一标示
        NSString *ifa = [Common getIFA];
        if (!ifa || [ifa length] == 0) {
            ifa = [[self class] getMacAddress];
        }
       kCommonDeviceInfo = [ifa stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    return kCommonDeviceInfo;
}


+ (NSString *)getIFV
{
    NSString *ifv = @"";
    CGFloat ver = [self systemVersion];
    if (ver >= 6.0) {
        ifv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    return ifv;
}

+ (NSString *)getIFA
{
    NSString *ifa = @"";
    CGFloat ver = [self systemVersion];
    if (ver >= 6.0 && [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        ifa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    
    return ifa;
}

+ (NSString *)getDeviceInfoEx
{
    static NSString *kCommonDeviceInfoEx = nil;
    
    if (kCommonDeviceInfoEx == nil) {
        CGFloat scale = 1.0;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            scale = [[UIScreen mainScreen] scale];
        }
        
        kCommonDeviceInfoEx = [NSString stringWithFormat:@"model=%@&os=%@&display=%.f*%.f&ifv=%@&ifa=%@",
                               [self getDeviceName],
                               [self getSystemVersion],
                               [UIScreen mainScreen].bounds.size.width * scale,
                               [UIScreen mainScreen].bounds.size.height * scale,
                               [self getIFV],
                               [self getIFA]];
    }
    
    return kCommonDeviceInfoEx;
}

#pragma mark -System Version

+ (NSString *)getSystemVersion
{
	return [NSString stringWithFormat:@"iOS/%@", [self systemVersionString]];
}

+ (BOOL)iOS7
{
    static BOOL iOS7 = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iOS7 = [self systemVersion] - 7 > -DBL_EPSILON;
    });
    return iOS7;
}

+ (CGFloat)systemVersion
{
    static CGFloat systemVersion = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[UIDevice currentDevice] systemVersion].floatValue;
    });
    return systemVersion;
}

+ (NSString *)systemVersionString
{
    static NSString *systemVersionString;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersionString = [[UIDevice currentDevice] systemVersion];
    });
    return systemVersionString;
}
+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = (char *)malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) {
                    errorFlag = @"sysctl msgBuffer failure";
                    free(msgBuffer);
                    msgBuffer = NULL;
                }
                
                
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

+ (NSString *)getUserId
{
    static NSString *kUserId = nil;
    
    if (kUserId == nil) {
        AMPofileModel *profile = [Common getCustomCacheForKey:@"profile"];
        if (profile) {
            kUserId = profile.userId;
        }
//        else
//        {
//            kUserId = @"";
//        }
    }
    
    return kUserId;
}

+ (NSString *)getUserNick
{
    static NSString *kUserNick = nil;
    
    if (kUserNick == nil) {
        AMPofileModel *profile = [Common getCustomCacheForKey:@"profile"];
        if (profile) {
            kUserNick = profile.userNick;
        }
//        else
//        {
//            kUserNick = @"";
//        }
    }
    
    return kUserNick;
}
#pragma mark - 本地缓存
//小数据存储
+ (void)setDefaultCache:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (id)getDefaultCacheForKey:(NSString *)key
{
    id cache = nil;
    @try {
        cache = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@">>>getDefaultCacheForKey error");
    }
    
    return cache;
}

//自定义类别
+ (void)setCustomCache:(id)value forKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];

    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (id)getCustomCacheForKey:(NSString *)key
{
    id cache = nil;
    @try {
        cache = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (cache) {
            cache = [NSKeyedUnarchiver unarchiveObjectWithData:cache];
        }
    }
    @catch (NSException *exception) {
        NSLog(@">>>getCustomCacheForKey error");
    }
    
    return cache;
}

#pragma mark - 字符串
+ (NSUInteger)getStringLength:(NSString *)text
{
    if (!text) {
        return 0;
    }
    __block NSUInteger count = 0;
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        count ++;
    }];
    return count;
}

+ (NSString *)getRealString:(NSString *)text
{
    if (!text) {
        return @"";
    }
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
#pragma mark - 正则
//邮箱正则
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}
//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}
@end
