//
//  UIAlertView+Blocks.m
//  LizhiFM听手机人人主播网络音乐小说英语新闻广播大全学堂cs
//
//  Created by chargechen on 14-10-10.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

@implementation UIAlertView (Blocks)

- (id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(LZButtonItem *)inCancelButtonItem otherButtonItems:(LZButtonItem *)inOtherButtonItems, ...
{
    if((self = [self initWithTitle:inTitle message:inMessage delegate:self cancelButtonTitle:inCancelButtonItem.label otherButtonTitles:nil]))
    {
        NSMutableArray *buttonsArray = [self buttonItems];
        
        LZButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems)
        {
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);
            while((eachItem = va_arg(argumentList, LZButtonItem *)))
            {
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        for(LZButtonItem *item in buttonsArray)
        {
            [self addButtonWithTitle:item.label];
        }
        
        if(inCancelButtonItem)
            [buttonsArray insertObject:inCancelButtonItem atIndex:0];
        
        [self setDelegate:self];
    }
    return self;
}

- (NSInteger)addButtonItem:(LZButtonItem *)item
{
    NSInteger buttonIndex = [self addButtonWithTitle:item.label];
    [[self buttonItems] addObject:item];
    
    if (![self delegate])
    {
        [self setDelegate:self];
    }
    
    return buttonIndex;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //buttonIndex -1 表示dismissed
    if (buttonIndex >= 0)
    {
        NSArray *buttonsArray = objc_getAssociatedObject(self, (__bridge const void *)LZ_ALERT_BUTTON_ASS_KEY);
        LZButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
        if(item.action){
            item.action();
        }
        //ios5 action 这个block没有释放导致循环引用
        for (LZButtonItem *btn in buttonsArray) {
            btn.action = nil;
        }
    }
    
    objc_setAssociatedObject(self, (__bridge const void *)LZ_ALERT_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)buttonItems
{
    NSMutableArray *buttonItems = objc_getAssociatedObject(self, (__bridge const void *)LZ_ALERT_BUTTON_ASS_KEY);
    if (!buttonItems)
    {
        buttonItems = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)LZ_ALERT_BUTTON_ASS_KEY, buttonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return buttonItems;
}

- (void)dealloc
{
    self.delegate = nil;
}
@end
