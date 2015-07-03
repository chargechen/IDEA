//
//  IPWebViewController.h
//  GetAdMoney
//
//  Created by Charge on 14-5-2.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "IPViewController.h"

@interface IPWebViewController : IPViewController<UIWebViewDelegate>
@property(nonatomic, readonly)  NSURL *url;
@property(nonatomic, strong)    UIView *headerView;
@property(nonatomic, assign)    BOOL isNeedToolBar;
- (id)initWithUrlPath:(NSString *)urlPath;
- (void)openURL:(NSURL*)url;
- (void)loadRequest:(NSURLRequest *)request;
@end
