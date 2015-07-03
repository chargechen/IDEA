//
//  IPPhotoCacheMgr.h
//  IdeaPlan
//
//  Created by chargechen on 15/1/2.
//  Copyright (c) 2015年 JUNBAO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPPhotoCacheMgr : NSObject
+ (instancetype)shareInstance;
- (UIImage *)getPhotoFromBuffer:(NSString *)fileID;
- (void)addBuffer:(NSString *)fileID photo:(UIImage *)photo;
- (void)removeFromBuffer:(NSString *)fileID;
- (void)clearBuffer;

@end
