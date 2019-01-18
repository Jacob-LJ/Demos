//
//  WebViewJavascriptBridge.h
//  ExampleApp-iOS
//
//  Created by Marcus Westin on 6/14/13.
//  Copyright (c) 2013 Marcus Westin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridgeBase.h"

#if (__MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9 || __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1)
#define supportsWKWebView // 根据各个平台版本判断是否支持wkwebview
#endif

#if defined supportsWKWebView
#import <WebKit/WebKit.h>
#endif

#if defined __MAC_OS_X_VERSION_MAX_ALLOWED // 用于 macOS 中
    #define WVJB_PLATFORM_OSX
    #define WVJB_WEBVIEW_TYPE WebView
    #define WVJB_WEBVIEW_DELEGATE_TYPE NSObject<WebViewJavascriptBridgeBaseDelegate>
    #define WVJB_WEBVIEW_DELEGATE_INTERFACE NSObject<WebViewJavascriptBridgeBaseDelegate, WebPolicyDelegate>
#elif defined __IPHONE_OS_VERSION_MAX_ALLOWED // 用于 iPhone 中
    #import <UIKit/UIWebView.h>
    #define WVJB_PLATFORM_IOS // 定义一个iOS平台标志
    #define WVJB_WEBVIEW_TYPE UIWebView // webview类型是UIWebView
    #define WVJB_WEBVIEW_DELEGATE_TYPE NSObject<UIWebViewDelegate> // 代理类型 UIWebViewDelegate
    #define WVJB_WEBVIEW_DELEGATE_INTERFACE NSObject<UIWebViewDelegate, WebViewJavascriptBridgeBaseDelegate> // .h 文件继承和代理类型
#endif

@interface WebViewJavascriptBridge : WVJB_WEBVIEW_DELEGATE_INTERFACE // 等同于 NSObject<UIWebViewDelegate, WebViewJavascriptBridgeBaseDelegate> 


+ (instancetype)bridgeForWebView:(id)webView;
+ (instancetype)bridge:(id)webView;

+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;

- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler;
- (void)removeHandler:(NSString*)handlerName;
// 注释没有回调的responseCallback方法，强制使用带有 responseCallback 的方法，防止调用一些h5没有注册的方法
//- (void)callHandler:(NSString*)handlerName;
//- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
- (void)setWebViewDelegate:(id)webViewDelegate;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end
