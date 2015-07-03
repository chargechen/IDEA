//
//  IPImageCell.m
//  GetAdMoney
//
//  Created by Charge on 14-4-7.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "IPImageCell.h"
@interface IPImageCell ()
{
    UIImageView *_iconView;
}
@end

@implementation IPImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIcon:(UIImage *)icon
{
    if (_icon != icon) {
        _icon = icon;
        _iconView.image = _icon;
        _iconView.frame = CGRectMake(15, 5, icon.size.width, icon.size.height);
    }
}
@end
