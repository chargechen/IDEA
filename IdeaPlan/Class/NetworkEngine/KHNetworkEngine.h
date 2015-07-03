//
//  KHNetworkEngine.h
//  LizhiFM
//
//  Created by Chargechen on 14-7-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

#define KHServerBase @"tingapi.ting.baidu.com"
//#define KHServerBase @"ting.baidu.com"
#define kHAppErrorDomain @"应用错误"
#define kHErrorParse @"解析数据出错"

@interface KHError : NSError
@property (nonatomic,copy) NSString *reason;
-(id)initWithMKNetworkOperation:(MKNetworkOperation *)op error:(NSError *)error;
@end

@interface KHNetworkEngine : MKNetworkEngine {
}

typedef void (^CommonResponseBlock)(BOOL changed);
typedef void (^ListResponseBlock)(NSMutableArray *array);

@property (nonatomic,assign) BOOL showError;
-(void)showPrompt:(NSString *)msg;
-(BOOL)checkError:(id)resp;
@end
