//
//  FavoriteDao+TaskList.h
//  GetAdMoney
//
//  Created by Charge on 14-5-27.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "FavoriteDao.h"

@interface FavoriteDao (TaskList)
- (void)createTaskTable;
- (void)dropTaskTable;
//查询所有
- (NSArray *)queryTaskTable;
//查询1条
//- (AMTaskModel *)queryTaskTableById:(long long)taskId;
//更新(删除后插入)
//- (BOOL)updateTaskTable:(AMTaskModel *)taskInfo;
//删除所有
- (void)deleteTaskTable;
//删除1条
- (void)deleteTaskTable:(long long)taskId;
@end
