//
//  UIActionSheet+Blocks.m
//  LizhiFM听手机人人主播网络音乐小说英语新闻广播大全学堂cs
//
//  Created by chargechen on 14-10-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "UIActionSheet+Blocks.h"
#import <objc/runtime.h>

@implementation UIActionSheet (Blocks)

-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(LZButtonItem *)inCancelButtonItem destructiveButtonItem:(LZButtonItem *)inDestructiveItem otherButtonItems:(NSMutableArray *)inOtherButtonItems
{
    if((self = [self initWithTitle:inTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]))
    {
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        objc_setAssociatedObject(self, (__bridge const void *)LZ_SHEET_BUTTON_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (inOtherButtonItems != nil && inOtherButtonItems.count > 0) {
            for (LZButtonItem *buttonItem in inOtherButtonItems) {
                [self addButtonItem:buttonItem];
            }
        }
        
        //        LZButtonItem *eachItem;
        //        va_list argumentList;
//        if (inOtherButtonItems)
//        {
//            [buttonsArray addObject: inOtherButtonItems];
//            va_start(argumentList, inOtherButtonItems);
//            while((eachItem = va_arg(argumentList, LZButtonItem *)))
//            {
//                [buttonsArray addObject: eachItem];
//            }
//            va_end(argumentList);
//        }
        
//        for(LZButtonItem *item in buttonsArray)
//        {
//            [self addButtonWithTitle:item.label];
//        }
        
        if(inDestructiveItem)
        {
            [buttonsArray addObject:inDestructiveItem];
            NSInteger destIndex = [self addButtonWithTitle:inDestructiveItem.label];
            [self setDestructiveButtonIndex:destIndex];
        }
        if(inCancelButtonItem)
        {
            [buttonsArray addObject:inCancelButtonItem];
            NSInteger cancelIndex = [self addButtonWithTitle:inCancelButtonItem.label];
            [self setCancelButtonIndex:cancelIndex];
        }
   
    }
    return self;
}

- (NSInteger)addButtonItem:(LZButtonItem *)item
{	
    NSMutableArray *buttonsArray = objc_getAssociatedObject(self, (__bridge const void *)LZ_SHEET_BUTTON_ASS_KEY);
	
	NSInteger buttonIndex = [self addButtonWithTitle:item.label];
	[buttonsArray addObject:item];
	
	return buttonIndex;
}

- (void)setDismissalAction:(void(^)())dismissalAction
{
    objc_setAssociatedObject(self, (__bridge const void *)LZ_SHEET_DISMISSAL_ACTION_KEY, nil, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, (__bridge const void *)LZ_SHEET_DISMISSAL_ACTION_KEY, dismissalAction, OBJC_ASSOCIATION_COPY);
}

- (void(^)())dismissalAction
{
    return objc_getAssociatedObject(self, (__bridge const void *)LZ_SHEET_DISMISSAL_ACTION_KEY);
}
#pragma mark - actionsheetdelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0)
    {
        NSArray *buttonsArray = objc_getAssociatedObject(actionSheet, (__bridge const void *)LZ_SHEET_BUTTON_ASS_KEY);
        LZButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
        if(item.action) {
            item.action();
        }
        //ios5 action 这个block没有释放导致循环引用
        for (LZButtonItem *btn in buttonsArray) {
            btn.action = nil;
        }
    }
    
    if (actionSheet.dismissalAction) {
        actionSheet.dismissalAction();
        actionSheet.dismissalAction = nil;
    }
    
    objc_setAssociatedObject(actionSheet, (__bridge const void *)LZ_SHEET_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(actionSheet, (__bridge const void *)LZ_SHEET_DISMISSAL_ACTION_KEY, nil, OBJC_ASSOCIATION_COPY);
}

@end

