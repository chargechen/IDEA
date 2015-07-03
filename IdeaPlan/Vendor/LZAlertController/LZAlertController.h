//
//  LZAlertController.h
//  LizhiFM听手机人人主播网络音乐小说英语新闻广播大全学堂cs
//
//  Created by chargechen on 14-10-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZButtonItem.h"

typedef enum {
    LZButtonItemType_Cancel         = 1,
    LZButtonItemType_Destructive       ,
    LZButtonItemType_Other
}LZButtonItemType;
typedef enum {
    LZAlertControllerType_AlertView    = 1,
    LZAlertControllerType_ActionSheet
}LZAlertControllerType;

@interface LZAlertController : NSObject

@property (nonatomic, strong) NSString *textFieldPlaceholder;

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)inViewController;
- (void)addButton:(LZButtonItem *)button type:(LZButtonItemType)itemType;
- (UITextField *)getTextField;
//actionSheet
- (void)showInView:(UIView *)view;
//alertView
- (void)show;
@end
