//
//  JSBridgeWKWebViewController.m
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/7/25.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import "JSBridgeWKWebViewController.h"
#import "JSHandler.h"

NSString * const progressContext = @"progress_context";

@interface JSBridgeWKWebViewController () <WKUIDelegate, WKNavigationDelegate>
{
    JSHandler *_jsHandler;
}
@end

@implementation JSBridgeWKWebViewController

- (instancetype)init
{
    self = [super init];
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configWKWebView];
    [self listenLoadingProgress];
    [self setting];
}

- (void)webViewLoadingWithProgress:(float)progress
{
    NSLog(@"%.2f", progress);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.WKWebView.frame = self.view.bounds;
}

#pragma mark-- privte
- (void)listenLoadingProgress
{
    [self.WKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(progressContext)];
}

- (void)configWKWebView
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContenController = [[WKUserContentController alloc] init];
    config.userContentController = userContenController;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    _jsHandler = [[JSHandler alloc] initWithJSBridgeWKWebViewController:self];
    [userContenController addScriptMessageHandler:_jsHandler name:@"nativeInterface"];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.WKWebView = webView;
}

- (void)setting
{
    if (self.startPage.length != 0) {
        NSURL *url = [NSURL fileURLWithPath:self.startPage];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.WKWebView loadRequest:request];
        return;
    }
    if (self.url.length != 0) {
        NSURL *url = [NSURL URLWithString:self.url];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.WKWebView loadRequest:request];
        return;
    }
}

#pragma mark-- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == (__bridge void * _Nullable)(progressContext)) {
        float progress = [change[@"new"] floatValue];
        [self webViewLoadingWithProgress:progress];
    }
}

#pragma mark-- navigationDelegate

#pragma mark-- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alert.textFields[0].text);
    }];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc
{
    [self.WKWebView.configuration.userContentController removeScriptMessageHandlerForName:@"JSPlugin"];
    [self.WKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    NSLog(@"webView----dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [_jsHandler.cacheDic removeAllObjects];
}

@end
