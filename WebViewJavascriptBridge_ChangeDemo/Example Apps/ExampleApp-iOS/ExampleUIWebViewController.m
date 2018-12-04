//
//  ExampleUIWebViewController.m
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 1/13/14.
//  Copyright (c) 2014 Marcus Westin. All rights reserved.
//

#import "ExampleUIWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "UIWebView+JSBridge.h"

// 通过分类UIWebView+JSBridge的封装可以限制调用的方式，这样可以不用注释源码提供的多个call方法，同时可以起到解耦作用
// 同时，能够通过分类封装，自定义一个baseWebView类出来，该类就能直接默认在初始方法内调用设置bridge的方法，子类就能直接通过webView调用注册js方法和call js 方法了

@interface ExampleUIWebViewController ()
//@property WebViewJavascriptBridge* bridge;
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation ExampleUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    
    // 设置 WebViewJavascriptBridge，或使用分类UIWebView+JSBridge进行快速设置
    //    [WebViewJavascriptBridge enableLogging];
    //    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
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


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

- (void)renderButtons:(UIWebView*)webView {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:11.0];
    
    UIButton *callbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callbackButton setTitle:@"Call handler" forState:UIControlStateNormal];
    [callbackButton addTarget:self action:@selector(callHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callbackButton aboveSubview:webView];
    callbackButton.frame = CGRectMake(0, 400, 100, 35);
    callbackButton.titleLabel.font = font;
    
    UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reloadButton setTitle:@"Reload webview" forState:UIControlStateNormal];
    [reloadButton addTarget:webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:reloadButton aboveSubview:webView];
    reloadButton.frame = CGRectMake(90, 400, 100, 35);
    reloadButton.titleLabel.font = font;
    
    UIButton* safetyTimeoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [safetyTimeoutButton setTitle:@"Disable safety timeout" forState:UIControlStateNormal];
    [safetyTimeoutButton addTarget:self action:@selector(disableSafetyTimeout) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:safetyTimeoutButton aboveSubview:webView];
    safetyTimeoutButton.frame = CGRectMake(190, 400, 120, 35);
    safetyTimeoutButton.titleLabel.font = font;
}

- (void)disableSafetyTimeout {
//    [self.bridge disableJavscriptAlertBoxSafetyTimeout];
}

- (void)callHandler:(id)sender {
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    // 调用H5中注册的方法，或使用分类UIWebView+JSBridge进行方法调用
//    [_bridge callHandler:@"testJavascriptHandler00" data:data responseCallback:^(id response) {
//    }];
    [self.webView callBridgeHandlerName:@"testJavascriptHandler00" data:data responseCallback:^(id responseData) {
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

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}
@end
