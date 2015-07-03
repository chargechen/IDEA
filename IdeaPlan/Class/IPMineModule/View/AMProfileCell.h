//
//  AMProfileCell.h
//  GetAdMoney
//
//  Created by Charge on 14-4-6.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMPofileModel.h"
@protocol AMProfileCellDelegate <NSObject>
@optional
-(void)didLevelRightClick;
@end

@interface AMProfileCell : UITableViewCell

@property (nonatomic,strong) AMPofileModel *profileModel;
@property (nonatomic,assign) id<AMProfileCellDelegate>delegate;
-(id)initWithModel:(AMPofileModel *)model;

@end
