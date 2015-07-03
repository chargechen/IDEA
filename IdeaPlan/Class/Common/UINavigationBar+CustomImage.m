//
//  UINavigationBar+CustomImage.m
//  GetAdMoney
//
//  Created by Charge on 14-4-27.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "UINavigationBar+CustomImage.h"

@implementation UINavigationBar (CustomImage)
//iOS5.0以下
-(void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"top_navigation_background.png"];
    UIImage *imageStretched = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [imageStretched drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end
