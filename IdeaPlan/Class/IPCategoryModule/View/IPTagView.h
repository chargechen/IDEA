//
//  LZSearchHotView.h
//  LizhiFM听手机人人主播网络音乐小说英语新闻广播大全学堂cs
//
//  Created by Chargechen on 14-9-23.
//  Copyright (c) 2014年 yibasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTagItemsSectionHeight 39 //每行高度
#define kTagItemHeight 25 //button高度
@protocol LZSearchHotViewDelegate <NSObject>
- (void)tagDidPress:(NSString *)tagName;
@end

@interface LZSearchHotView : UITableViewCell

@property (strong, nonatomic)NSArray *tagIds;
@property (assign, nonatomic)id<LZSearchHotViewDelegate>delegate;

@end

@interface LZSearchHotView (Layout)
+ (float)searchViewHeight:(NSArray *)tagNames;

@end