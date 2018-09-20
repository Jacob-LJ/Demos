//
//  JSHandler.h
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/7/25.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "JSCommandDelegate.h"
#import "JSBridgeWKWebViewController.h"

@interface JSHandler : NSObject <WKScriptMessageHandler, JSCommandDelegate>

// 用于存放插件的缓存池
@property (nonatomic, strong, readonly) NSMutableDictionary *cacheDic;

// 当前的JSBridgeWKWebViewController视图控制器
@property (nonatomic, weak, readonly) JSBridgeWKWebViewController *viewController;

/**
 * 初始化JS调用原生处理分发事件
 * param JSBridgeWKWebViewController 通过WKWebView控制器初始化
 */
- (instancetype)initWithJSBridgeWKWebViewController:(JSBridgeWKWebViewController *)JSBridgeWKWebViewController;


@end
