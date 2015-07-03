//
//  IPWebViewController.m
//  GetAdMoney
//
//  Created by Charge on 14-5-2.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "IPWebViewController.h"
#import "IPToolbar.h"
@interface UIView (QZWeb)

- (UIView*)firstViewOfClass:(Class)cls;

@end

@implementation UIView(QZWeb)


- (UIView*)firstViewOfClass:(Class)cls
{
	if ([self isKindOfClass:cls])
		return self;
	
	for (UIView* child in self.subviews)
    {
		UIView* it = [child firstViewOfClass:cls];
		if (it)
			return it;
	}
	return nil;
}

@end
@interface IPWebViewController ()
{
    UIWebView* _webView;
	IPToolbar* _toolbar;
	UIView* _headerView;
	UIBarButtonItem* _backButton;
	UIBarButtonItem* _forwardButton;
	UIBarButtonItem* _refreshButton;
	UIBarButtonItem* _stopButton;
    UIBarButtonItem* _space;

}
@property (nonatomic, strong) NSString *urlPath;

@end

@implementation IPWebViewController

- (id)initWithUrlPath:(NSString *)urlPath
{
	self = [super init];
	if (self)
    {
        self.urlPath = urlPath;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	_webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	_webView.delegate = self;
	_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//	_webView.scalesPageToFit = YES;
	[self.view addSubview:_webView];
	
	if (_isNeedToolBar) {
        
        UIImage *backImage = [UIImage imageNamed:@"browser_button_back"];
        UIImage *backImageHigtlighted = [UIImage imageNamed:@"browser_button_back_pressed"];
        UIImage *backImageDisabled = [UIImage imageNamed:@"browser_button_back_disabled"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:backImage forState:UIControlStateNormal];
        [button setImage:backImageDisabled forState:UIControlStateDisabled];
        [button setImage:backImageHigtlighted forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        UIImage *forwardImage = [UIImage imageNamed:@"browser_button_forward"];
        UIImage *forwardImageHigtlighted = [UIImage imageNamed:@"browser_button_forward_pressed"];
        UIImage *forwardImageDisabled = [UIImage imageNamed:@"browser_button_forward_disabled"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:forwardImage forState:UIControlStateNormal];
        [button setImage:forwardImageHigtlighted forState:UIControlStateHighlighted];
        [button setImage:forwardImageDisabled forState:UIControlStateDisabled];
        button.frame = CGRectMake(0, 0, forwardImage.size.width, forwardImage.size.height);
        [button addTarget:self action:@selector(forwardAction) forControlEvents:UIControlEventTouchUpInside];
        _forwardButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        UIImage *refreshImage = [UIImage imageNamed:@"browser_button_refresh"];
        UIImage *refreshImageHigtlighted = [UIImage imageNamed:@"browser_button_refresh_pressed"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:refreshImage forState:UIControlStateNormal];
        [button setImage:refreshImageHigtlighted forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, refreshImage.size.width, refreshImage.size.height);
        [button addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
        _refreshButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        
        UIImage *stopImage = [UIImage imageNamed:@"browser_button_stop"];
        UIImage *stopImageHigtlighted = [UIImage imageNamed:@"browser_button_stop_pressed"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:stopImage forState:UIControlStateNormal];
        [button setImage:stopImageHigtlighted forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, refreshImage.size.width, refreshImage.size.height);
        [button addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
        _stopButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        _space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        _toolbar = [[IPToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        _toolbar.items = [NSArray arrayWithObjects:_backButton, _space, _forwardButton, _space, _refreshButton, nil];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_toolbar];
    }
   //
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
//    UIFont *font = [UIFont systemFontOfSize:15];
//    backButton.titleLabel.font = font;
//    
//    CGSize titleSize = [@"返回" sizeWithFont:font];
//    
//    CGRect frame = backButton.frame;
//    frame.size.width = titleSize.width+30;
//    backButton.frame = frame;
//    
//    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    
//    self.navigationItem.leftBarButtonItem = backBarButton;
    [self openURL:[NSURL URLWithString:self.urlPath]];
}

- (void)backAction
{
	[_webView goBack];
}

- (void)forwardAction
{
	[_webView goForward];
}

- (void)refreshAction
{
	[_webView reload];
}

- (void)stopAction
{
	[_webView stopLoading];
}

- (NSURL*)url
{
	return _webView.request.URL;
}

- (void)setHeaderView:(UIView*)headerView
{
	if (headerView != _headerView)
    {
		BOOL addingHeader = !_headerView && headerView;
		BOOL removingHeader = _headerView && !headerView;
		
		[_headerView removeFromSuperview];
		_headerView = nil;
		_headerView = headerView;
        
		
		_headerView.frame = CGRectMake(0, 0, _webView.frame.size.width, _headerView.frame.size.height);
		
		[self view];
		UIView* scroller = [_webView firstViewOfClass:NSClassFromString(@"UIScroller")];
		UIView* docView = [scroller firstViewOfClass:NSClassFromString(@"UIWebDocumentView")];
		[scroller addSubview:_headerView];
		
		CGRect rect = docView.frame;
		if (addingHeader)
        {
			rect.origin.y += headerView.frame.size.height;
			rect.size.height -= headerView.frame.size.height;
		}
        else if (removingHeader)
        {
			rect.origin.y -= headerView.frame.size.height;
			rect.size.height += headerView.frame.size.height;
		}
		docView.frame = rect;
	}
}

- (void)openURL:(NSURL*)url
{
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	[_webView loadRequest:request];
}

- (void)loadRequest:(NSMutableURLRequest *)request
{
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%s request %@", __PRETTY_FUNCTION__, request);
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView*)webView
{
	self.title = NSLocalizedString(@"加载中...", @"");
    if (_isNeedToolBar) {
        _toolbar.items = [NSArray arrayWithObjects:_backButton, _space, _forwardButton, _space, _stopButton, _space, nil];
    }
	_backButton.enabled = [_webView canGoBack];
	_forwardButton.enabled = [_webView canGoForward];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
	self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (_isNeedToolBar) {
        _toolbar.items = [NSArray arrayWithObjects:_backButton, _space, _forwardButton, _space, _refreshButton, _space, nil];
    }
	_backButton.enabled = [_webView canGoBack];
	_forwardButton.enabled = [_webView canGoForward];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
	[self webViewDidFinishLoad:webView];
    _backButton.enabled = [_webView canGoBack];
	_forwardButton.enabled = [_webView canGoForward];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	_headerView = nil;
    _webView.delegate = nil;
    _webView = nil;
}

@end
