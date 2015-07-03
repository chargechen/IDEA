//
//  UIActionSheet+Blocks.h
//  LizhiFM听手机人人主播网络音乐小说英语新闻广播大全学堂cs
//
//  Created by chargechen on 14-10-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZButtonItem.h"

static NSString *LZ_SHEET_BUTTON_ASS_KEY = @"LZ_SHEET_BUTTONS";
static NSString *LZ_SHEET_DISMISSAL_ACTION_KEY = @"LZ_SHEET_DISMISSAL_ACTION";

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(LZButtonItem *)inCancelButtonItem destructiveButtonItem:(LZButtonItem *)inDestructiveItem otherButtonItems:(NSMutableArray *)inOtherButtonItems;

- (NSInteger)addButtonItem:(LZButtonItem *)item;


//dismiss时执行
@property (copy, nonatomic) void(^dismissalAction)();

@end
