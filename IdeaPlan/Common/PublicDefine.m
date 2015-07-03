//
//  PublicDefine.m
//  GetAdMoney
//
//  Created by Charge on 14-3-30.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//
#include <stdio.h>
#import "PublicDefine.h"

@implementation QZDeviceSystem

+ (BOOL) DeviceSystemIsIOS7
{
    static BOOL __ios7__ = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.9999 ) {
            __ios7__ = YES;
        }
    });
    return __ios7__;
}


+ (BOOL) DeviceSystemIsIOS5
{
    static BOOL __ios5__ = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9999 ) {
            __ios5__ = YES;
        }
    });
    return __ios5__;
}

@end
