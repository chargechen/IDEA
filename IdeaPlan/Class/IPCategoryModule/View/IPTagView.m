//
//  LZSearchHotView.m
//  LizhiFM听手机人人主播网络音乐小说英语新闻广播大全学堂cs
//
//  Created by Chargechen on 14-9-23.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import "LZSearchHotView.h"

  
#import "LZColorMgr.h"
#import "LZRadioTagMgr.h"

#import "LizhiFM.pb.h"
#define kTagTipTitleFont ([LZFontMgr font20])

#define kMaxSelectTagCount 100



#define kTagRowMaxWidth 290 //=320 - 22 -22
#define kTagColummCount 7

#define kTagItem1_x 17

#define kTagValueShift 10000

@implementation LZSearchHotView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setTagIds:(NSArray *)tagIds
{
    _tagIds = tagIds;
    float origin_Y = 0;
    int row = 0;
    float btnWidth = 0;
    int leftOffset = 15;
    
    for (int i = 0; i < _tagIds.count; i++)
    {
        NSString *tagName = _tagIds[i];
        row ++;
        
        CGSize tagNameSize = [tagName sizeWithFont:[LZFontMgr font28]
                                 constrainedToSize:CGSizeMake(320, 25)];
        float tagNameWidth = tagNameSize.width + 30; // 扩展tag宽度
        
        //如果大于屏幕的一半
        if (tagNameWidth > screenWidth()/2) {
            tagNameWidth = screenWidth()/2;
        }
        
        //如果是第一个或超出屏幕
        if (btnWidth == 0 || btnWidth + tagNameWidth >= screenWidth()-15) {
            origin_Y += kTagItemsSectionHeight;
            row = 0;
            btnWidth = 0;
        }
        
        if (tagName.length == 0) {
            continue;
        }
        
        
        UIButton *tagTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [tagTitleButton setFrame:CGRectMake(leftOffset + btnWidth,
                                            origin_Y - kTagItemHeight,
                                            tagNameWidth,
                                            kTagItemHeight)];
        
        btnWidth += tagNameWidth + 10;  //加上间距
        
        [tagTitleButton setBackgroundColor:[UIColor clearColor]];
        
        UIImage *tagBg = [UIImage imageNamed:@"btn_hotword_n.png"];
        [tagTitleButton setBackgroundImage:[tagBg stretchableImageWithLeftCapWidth:tagBg.size.width/2 topCapHeight:tagBg.size.height/2] forState:UIControlStateNormal];
        [tagTitleButton setBackgroundImage:STRETCHABLE_IMAGE(@"btn_hotword_p.png", tagBg.size.width/2, tagBg.size.height/2) forState:UIControlStateHighlighted];
        [tagTitleButton setTitleColor:[LZColorMgr colorWithRBG_0x86_0x7f_6f]
                             forState:UIControlStateNormal];
        [tagTitleButton.titleLabel setFont:[LZFontMgr font26]];
        [tagTitleButton setTitle:tagName
                        forState:UIControlStateNormal];
        [tagTitleButton setTag:i];
        [tagTitleButton addTarget:self
                           action:@selector(tagDidTap:)
                 forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tagTitleButton];
        
    }

}

- (void)prepareForReuse
{
    for (UIView *tempView in self.contentView.subviews)
    {
        [tempView removeFromSuperview];
    }
    [super prepareForReuse];

}

- (void)tagDidTap:(UIButton *)tagBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidPress:)]) {
        NSString *tagName = [_tagIds objectAtIndex:tagBtn.tag];
        [self.delegate tagDidPress:tagName];
    }
}

- (void)dealloc
{

}

@end

@implementation LZSearchHotView (Layout)
+ (float)searchViewHeight:(NSArray *)tagNames
{
   float height = 0.f;
   
    float origin_Y = 0;
    int row = 0;
    float btnWidth = 0;
    
    for (int i = 0; i < tagNames.count; i++)
    {
        NSString *tagName = tagNames[i];
        row ++;
        
        CGSize tagNameSize = [tagName sizeWithFont:[LZFontMgr font28]
                                 constrainedToSize:CGSizeMake(320, 25)];
        float tagNameWidth = tagNameSize.width + 30; // 扩展tag宽度
        //如果大于屏幕的一半
        if (tagNameWidth > screenWidth()/2) {
            tagNameWidth = screenWidth()/2;
        }
        
        //如果是第一个或超出屏幕
        if (btnWidth == 0 || btnWidth + tagNameWidth >= screenWidth()-15) {
            origin_Y += kTagItemsSectionHeight;
            row = 0;
            btnWidth = 0;
        }
        
        if (tagName.length == 0) {
            continue;
        }
        
        btnWidth += tagNameWidth + 10;  //加上间距
        
    }

    height = origin_Y;
    
    return height;

}
@end