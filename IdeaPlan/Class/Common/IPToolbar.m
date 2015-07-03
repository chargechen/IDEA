//
//  IPToolbar.m
//  GetAdMoney
//
//  Created by Charge on 14-5-2.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "IPToolbar.h"

@implementation IPToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        //self.translucent = YES;
        //self.tintColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
}


@end
