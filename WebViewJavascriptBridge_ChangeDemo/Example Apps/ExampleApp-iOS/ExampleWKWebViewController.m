//
//  ExampleWKWebViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "ExampleWKWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "WKWebView+JSBridge.h"

@interface ExampleWKWebViewController ()

//@property WKWebViewJavascriptBridge* bridge;
@property (nonatomic, weak) WKWebView *webView;

@end

@implementation ExampleWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    // 设置 WKWebViewJavascriptBridge，或使用分类UIWebView+JSBridge进行快速设置
    //    [WKWebViewJavascriptBridge enableLogging];
    //    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:webView];
    //    [_bridge setWebViewDelegate:self];
    [webView setUpBridgeWebViewDelegate:self];
    
    
    // 本地注册一个供H5调用方法，或使用分类UIWebView+JSBridge进行方法注册
    //    [_bridge registerHandler:@"AllKnownMethodName" handler:^(id data, WVJBResponseCallback responseCallback) {
    //        responseCallback(@"OC响应后回传AllKnownMethodName");
    //    }];
    [webView registerBridgeHandlerName:@"AllKnownMethodName" handler:^(id data, JSBridgeResponseCallback responseCallback) {
        NSLog(@"H5调用了 OC注册的AllKnownMethodName: %@", data);
        // 调用完后回调H5的方法
        responseCallback(@"OC响应后回传AllKnownMethodName");
    }];
    
    
    [self renderButtons:webView];
    [self loadExamplePage:webView];
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(WKWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(10, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(110, 400, 100, 35);
    reloadButton.titleLabel.font = font;
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    // 调用H5中注册的方法，或使用分类UIWebView+JSBridge进行方法调用
    //    [_bridge callHandler:@"testJavascriptHandler00" data:data responseCallback:^(id response) {
    //    }];
    [self.webView callBridgeHandlerName:@"testJavascriptHandler" data:data responseCallback:^(id responseData) {
        NSInteger code = [responseData[@"code"] integerValue];
        if (0 == code) {
            NSLog(@"正常调用H5注册的方法：%@", responseData);
        } else if (-9999 == code) {
            NSLog(@"你调用了不存在的方法 : %@", responseData);
        } else {
            NSLog(@"其他错误：%@", responseData);
        }
    }];
}


- (void)loadExamplePage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}
@end
