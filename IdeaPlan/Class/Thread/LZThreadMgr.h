//
//  LZThreadMgr.h
//  LizhiFM
//
//  Created by wzsam on 3/17/14.
//  Copyright (c) 2014 yibasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZThreadMgr : NSObject

//全局通用线程
+ (NSThread *)threadForGlobal;

//网络发送线程
+ (NSThread *)threadForSceneQueue;

@end
