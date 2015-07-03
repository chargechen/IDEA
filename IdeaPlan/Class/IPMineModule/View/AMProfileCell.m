//
//  AMProfileCell.m
//  GetAdMoney
//
//  Created by Charge on 14-4-6.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "AMProfileCell.h"
#define CELL_LEFT_MARGIN (15 + 60 + 10)

@implementation AMProfileCell
{
    UILabel *_nickView;      //昵称
    UIView *_levelRightView; //等级特权
    UIButton *_levelView;      //等级
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithModel:(AMPofileModel *)model
{
    self = [super init];
    if (self) {
        _profileModel = model;
        [self initNickView];
        [self initLevelView];
        [self initLevelRightView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initNickView
{
    NSString *nick = (_profileModel.userNick&&_profileModel.userNick.length>0)?_profileModel.userNick:@"赚钱达人";
    _nickView = [[UILabel alloc] initWithFrame:CGRectMake(CELL_LEFT_MARGIN,30, 100, 25)];
    _nickView.text = nick;
    _nickView.backgroundColor = [UIColor clearColor];
    _nickView.textAlignment = NSTextAlignmentLeft;
    _nickView.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;;
    _nickView.font = [UIFont boldSystemFontOfSize:16];
    _nickView.numberOfLines = 1;
    [_nickView sizeToFit];
    [self.contentView addSubview:_nickView];
}

-(void)initLevelView
{
    NSNumber *level = _profileModel.level ? _profileModel.level : @0;
    _levelView =[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *s = [NSString stringWithFormat:@"Lv: %@",level];
    UIFont *font = [UIFont systemFontOfSize:9];
    CGSize size = CGSizeMake(100,14);
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [_levelView setTitle:s forState:UIControlStateNormal];
    [_levelView setFrame:CGRectMake(_nickView.frame.origin.x + _nickView.frame.size.width + 5, _nickView.frame.origin.y - 5,labelsize.width + 6, labelsize.height + 4)];
    _levelView.titleLabel.font =[UIFont systemFontOfSize:9];
    [_levelView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:@"am_profile_vip_bg.png"];
    UIImage *backImg = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    [_levelView setBackgroundImage:backImg forState:UIControlStateNormal];
    
    [self.contentView addSubview:_levelView];
    
}

-(void)initLevelRightView
{
    CGFloat levelViewHeight = 25.0f;
    CGFloat levelViewPadding = 10.0f;
    CGFloat currentViewWidth = 0;
    
    _levelRightView = [[UIView alloc] init];
    _levelRightView.backgroundColor = [UIColor clearColor];
    
    //右对齐
    //添加分数label
    UILabel *levelValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    levelValueLabel.text = _profileModel.levelRight;
    levelValueLabel.textColor = [UIColor whiteColor];
    levelValueLabel.backgroundColor = [UIColor clearColor];
    levelValueLabel.textAlignment = NSTextAlignmentLeft;
    levelValueLabel.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;;
    levelValueLabel.font = [UIFont boldSystemFontOfSize:12];
    levelValueLabel.numberOfLines = 1;
    [levelValueLabel sizeToFit];
    [_levelRightView addSubview:levelValueLabel];
    
    currentViewWidth += levelValueLabel.frame.size.width + levelViewPadding;
    
    //添加图标
    UIImage *icon =  [UIImage imageNamed:@"am_profile_levelRight.png"];
    UIImageView *levelIcon = [[UIImageView alloc] initWithImage:icon];
    [_levelRightView addSubview:levelIcon];
    
    currentViewWidth += icon.size.width + 3 + levelViewPadding;
    
    //添加点击按钮
    UIButton* button = [[UIButton alloc] init];
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    button.exclusiveTouch = YES;
   
    UIImage *backgroundImage = [UIImage imageNamed:@"am_profile_levelRight_bg.png"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:backgroundImage.size.height/2];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    UIImage *backgroundImageClick = [UIImage imageNamed:@"am_profile_levelRight_click_bg.png"];
    backgroundImageClick = [backgroundImageClick stretchableImageWithLeftCapWidth:20 topCapHeight:backgroundImage.size.height/2];
    [button setBackgroundImage:backgroundImageClick forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(didPrivilegeClick) forControlEvents:UIControlEventTouchUpInside];

    [_levelRightView insertSubview:button atIndex:0];
    
    //ui布局
    _levelRightView.frame = CGRectMake(_nickView.frame.origin.x , _nickView.frame.origin.y +_nickView.frame.size.height + 5, currentViewWidth, levelViewHeight);
    
    levelValueLabel.frame =CGRectMake(currentViewWidth - levelViewPadding - levelValueLabel.frame.size.width, 0, levelValueLabel.frame.size.width, levelViewHeight);
    
    levelIcon.frame = CGRectMake(levelValueLabel.frame.origin.x - 3 - icon.size.width, (levelViewHeight - icon.size.height)/2, icon.size.width, icon.size.height);
    button.frame = _levelRightView.bounds;
    _levelRightView.userInteractionEnabled = YES;
    [self.contentView addSubview:_levelRightView];
}

-(void)dealloc
{
    self.delegate = nil;
}

-(void)didPrivilegeClick
{
    if ([self.delegate respondsToSelector:@selector(didLevelRightClick)]) {
        [self.delegate didLevelRightClick];
    }
}
@end
