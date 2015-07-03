//
//  AMAdviceViewController.m
//  GetAdMoney
//
//  Created by Charge on 14-4-7.
//  Copyright (c) 2014年 LoveJun. All rights reserved.
//

#import "AMAdviceViewController.h"
#import "UIButton+Bootstrap.h"
#import "Common.h"
#import "UIView+Toast.h"
#define ADVICETEXT 10000
#define ADVICETEXT_LENGTH_MAX 500
@interface AMAdviceViewController ()
{
    UIControl *_gestureCtl;
    UIGestureRecognizer *_atapGr;
}
@end

@implementation AMAdviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"反馈意见";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITextField *adviceField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 10 * 2, 100)];
    adviceField.delegate = self;
    adviceField.font = [UIFont systemFontOfSize:16];
    adviceField.borderStyle = UITextBorderStyleRoundedRect;
    adviceField.placeholder = @"亲!请提意见^^，我们会做得更好~";
    adviceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    adviceField.tag = ADVICETEXT;
    [self.view addSubview:adviceField];

    UIButton* adviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [adviceButton setTitle:@"提交" forState:UIControlStateNormal];
    adviceButton.frame = CGRectMake(10, 20 +100 +20,self.view.frame.size.width - 10*2, 40);
    [adviceButton primaryStyle];
    [adviceButton addTarget:self action:@selector(didFeedBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:adviceButton];
    
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self.view viewWithTag:ADVICETEXT] becomeFirstResponder];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//todo
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [self initGesture];
}

#pragma mark - 
-(void)initGesture{
    if (!_gestureCtl) {
        _gestureCtl = [[UIControl alloc] initWithFrame:self.view.window.bounds];
        [self.view.window addSubview:_gestureCtl];
    }
    
    if (!_atapGr) {
        _atapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandle:)];
        [_gestureCtl addGestureRecognizer:_atapGr];
    }
}

-(void)gestureHandle:(UITapGestureRecognizer*)tapGr
{
    if (tapGr == _atapGr) {
        [(UITextField *)[self.view viewWithTag:ADVICETEXT] resignFirstResponder];
        [_gestureCtl removeGestureRecognizer:_atapGr];
        _atapGr = nil;
    }
    [_gestureCtl removeFromSuperview];
    _gestureCtl = nil;
}

-(void)didFeedBackBtnClick
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:ADVICETEXT];
    NSString *adviceStr = textField.text;
    if ([Common getStringLength:adviceStr] > ADVICETEXT_LENGTH_MAX) {
        [self.view makeToast:[NSString stringWithFormat:@"亲，建议不能超出%d个字~",ADVICETEXT_LENGTH_MAX] duration:2 position:kActivityDefaultPosition];
        return;
    }
    if ([Common getStringLength:adviceStr] == 0) {
        [self.view makeToast:@"亲，建议不能为空哦~" duration:2 position:kActivityDefaultPosition];
        return;
    }
    NSURL *url = [NSURL URLWithString:@"http://zuanqianmm.com/api/jsonReq"];
    NSDictionary *body = @{@"content":adviceStr};
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"feedback",@"reqCode",
                                   body,@"body",
                                   nil];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    for (id key in params){
        [request addPostValue:[params objectForKey:key] forKey:key];
    }
    [request setDelegate:self];
    [request startAsynchronous];

}
-(void)requestFailed:(NSError *)error
{
    [self.view makeToast:@"收到亲的建议，我们将会做得更好~" duration:2 position:kActivityDefaultPosition];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //    if () {
    //
    //    }
    NSLog(@"advice-finish");
    [self.view makeToast:@"收到亲的建议，我们将会做得更好~" duration:2 position:kActivityDefaultPosition];
    // Use when fetching text data
//    NSString *responseString = [request responseString];
//    
//    // Use when fetching binary data
//    NSData *responseData = [request responseData];
//    NSDictionary *jason = [responseData objectFromJSONData];
//    
    //    adCell.textLabel.text = [response objectForKey:@"ads"];
    //    [_tableView reloadData];
}


@end
