//
//  PublicDefine.h
//  GetAdMoney
//
//  Created by Charge on 14-3-30.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//
#ifndef _PUBLIC_DEFINE_H_
#define _PUBLIC_DEFINE_H_
@interface QZDeviceSystem : NSObject
+ (BOOL) DeviceSystemIsIOS7;
+ (BOOL) DeviceSystemIsIOS5;
@end
#define isIOS7 ([QZDeviceSystem DeviceSystemIsIOS7])
#define isIOS5 ([QZDeviceSystem DeviceSystemIsIOS5])

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))

#endif //_PUBLIC_DEFINE_H_