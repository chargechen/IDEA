//
//  FavoriteDao+list.h
//  GetAdMoney
//
//  Created by Charge on 14-5-27.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "FavoriteDao.h"

@interface FavoriteDao (FavoriteList)
- (void)createFavoriteTable;
- (void)dropFavoriteTable;
//查询所有
- (NSArray *)queryFavoriteTable;
//查询1条
- (IPArticleModel *)queryFavoriteTableById:(long long)favoriteId;
//更新(删除后插入)
- (BOOL)updateFavoriteTable:(IPArticleModel *)favoriteInfo;
//删除所有
- (void)deleteFavoriteTable;
//删除1条
- (void)deleteFavoriteTable:(long long)favoriteId;
@end
