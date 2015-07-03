//
//  LZAlertController.m
//  LizhiFM听手机人人主播网络音乐小说英语新闻广播大全学堂cs
//
//  Created by chargechen on 14-10-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "LZAlertController.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

#define LZBUTTONCANCEL             @"LZButtonItemType_Cancel"
#define LZBUTTONDESTRUCTIVE        @"LZButtonItemType_Destructive"
#define LZBUTTONOTHER              @"LZButtonItemType_Other"
@interface LZAlertController()
{
    UITextField *_textField;
}
@property (nonatomic, strong) NSString              *title;
@property (nonatomic, strong) NSString              *message;
@property (nonatomic, weak) UIViewController        *inViewController;
@property (nonatomic, strong) NSMutableDictionary   *buttonInfoDict;
@end

@implementation LZAlertController

- (id)initWithTitle:(NSString *)title message:(NSString *)message viewController:(UIViewController *)inViewController
{
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.inViewController = inViewController;
    }
    return self;
}

- (NSMutableDictionary *)buttonInfoDict
{
    if (_buttonInfoDict == nil) {
        _buttonInfoDict = [NSMutableDictionary dictionary];
    }
    return _buttonInfoDict;
}

- (void)addButton:(LZButtonItem *)button type:(LZButtonItemType)itemType
{
    if (button == nil || ![button isKindOfClass:[LZButtonItem class]]) {
        return;
    }
    switch (itemType) {
        case LZButtonItemType_Cancel:
        {
            [self.buttonInfoDict setObject:button forKey:LZBUTTONCANCEL];
        }
            break;
        case LZButtonItemType_Destructive:
        {
            [self.buttonInfoDict setObject:button forKey:LZBUTTONDESTRUCTIVE];
        }
            break;
        case LZButtonItemType_Other:
        {
            NSMutableArray *otherArray = self.buttonInfoDict[LZBUTTONOTHER];
            if (otherArray == nil) {
                otherArray = [NSMutableArray array];
            }
            [otherArray addObject:button];
            [self.buttonInfoDict setObject:otherArray forKey:LZBUTTONOTHER];
        }
            break;
        default:
            break;
    }
}

- (void)showInView:(UIView *)view
{
    if (isIpad) //ipad 需要设置弹出点，替换成ALERT弹出方式
    {
        [self show];
    }
    else
    {
        if (isIOS8)
        {
            [self showIOS8ViewWithType:LZAlertControllerType_ActionSheet];
        }
        else
        {
            [self ios7showInView:view];
        }
    }

}

- (void)show
{
    if (isIOS8) {
        [self showIOS8ViewWithType:LZAlertControllerType_AlertView];
    } else {
        [self ios7Show];
    }
}

- (void)showIOS8ViewWithType:(LZAlertControllerType)viewType
{
    if (self.inViewController == nil) {
        self.inViewController = [Common topViewController];
    }
    UIAlertController *alertController = nil;
    switch (viewType) {
        case LZAlertControllerType_AlertView:
        {
            alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleAlert];
            if (self.textFieldPlaceholder) {
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.text = self.textFieldPlaceholder;
                    _textField = textField;
                }];
            }
        }
            break;
        case LZAlertControllerType_ActionSheet:
        {
            alertController = [UIAlertController alertControllerWithTitle:self.title message:self.message preferredStyle:UIAlertControllerStyleActionSheet];
        }
            break;
        default:
            break;
    }
    LZButtonItem *cancelItem = self.buttonInfoDict[LZBUTTONCANCEL];
    if (cancelItem != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelItem.label style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (cancelItem.action) {
                cancelItem.action();
            }
        }];
        [alertController addAction:cancelAction];
    }
    
    NSArray *otherItems = self.buttonInfoDict[LZBUTTONOTHER];
    if (otherItems != nil && otherItems.count > 0) {
        for (LZButtonItem *buttonItem in otherItems) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:buttonItem.label style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (buttonItem.action) {
                    buttonItem.action();
                }
            }];
            [alertController addAction:otherAction];
        }
    }
    
    LZButtonItem *destructiveItem = self.buttonInfoDict[LZBUTTONDESTRUCTIVE];
    if (destructiveItem != nil) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveItem.label style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            if (destructiveItem.action) {
                destructiveItem.action();
            }
        }];
        [alertController addAction:destructiveAction];
    }
    
//    UIPopoverPresentationController *ppc = alertController.popoverPresentationController;
//    ppc.sourceView = self.inViewController.view;
//    
//    // 显示在中心位置
//    ppc.sourceRect = CGRectMake((CGRectGetWidth(ppc.sourceView.bounds)-2)*0.5f, (CGRectGetHeight(ppc.sourceView.bounds)-2)*0.5f, 2, 2);
    
    [self.inViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)ios7showInView:(UIView *)view
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:self.title cancelButtonItem:self.buttonInfoDict[LZBUTTONCANCEL] destructiveButtonItem:self.buttonInfoDict[LZBUTTONDESTRUCTIVE] otherButtonItems: self.buttonInfoDict[LZBUTTONOTHER]];
//    NSArray *otherItems = self.buttonInfoDict[LZBUTTONOTHER];
//    if (otherItems != nil && otherItems.count > 0) {
//        for (LZButtonItem *buttonItem in otherItems) {
//            [actionSheet addButtonItem:buttonItem];
//        }
//    }
    if (view.window) {
        [actionSheet showInView:view.window];
    }
    else
    {
        [actionSheet showInView:view];
    }
}

- (void)ios7Show
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title message:self.message cancelButtonItem:self.buttonInfoDict[LZBUTTONCANCEL] otherButtonItems:nil];
    if (self.textFieldPlaceholder) {
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.text = self.textFieldPlaceholder;
        if (!isIOS6) { //防止工程中文名带来的CRASH
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        }
        _textField = textField;
    }

    NSArray *otherItems = self.buttonInfoDict[LZBUTTONOTHER];
    if (otherItems != nil && otherItems.count > 0) {
        for (LZButtonItem *buttonItem in otherItems) {
            [alertView addButtonItem:buttonItem];
        }
    }
    LZButtonItem *destructiveItem = self.buttonInfoDict[LZBUTTONDESTRUCTIVE];
    if (destructiveItem != nil) {
        [alertView addButtonItem:destructiveItem];
    }
    
    [alertView show];
}

- (UITextField *)getTextField
{
    return _textField;
}

- (void)dealloc
{
    _inViewController = nil;
}
@end
