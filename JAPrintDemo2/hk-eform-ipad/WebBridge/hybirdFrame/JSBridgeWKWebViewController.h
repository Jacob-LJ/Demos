//
//  JSBridgeWKWebViewController.h
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/7/25.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface JSBridgeWKWebViewController : UIViewController

// 当前WKWebView
@property (nonatomic, strong) WKWebView *WKWebView;

// 加载本地文件PATH的字符串 （本地优先）
@property (nonatomic, copy) NSString *startPage;

// 加载url的字符串
@property (nonatomic, copy) NSString *url;

// 加载页面进度
- (void)webViewLoadingWithProgress:(float)progress;

@end
