//
//  WKWebView+JSBridge.m
//  ExampleApp-iOS
//
//  Created by PSBC on 2018/12/3.
//  Copyright © 2018 Marcus Westin. All rights reserved.
//

#import "WKWebView+JSBridge.h"
#import "WKWebViewJavascriptBridge.h"
#import <objc/message.h>

@interface WKWebView ()

@property (nonatomic, strong) WKWebViewJavascriptBridge *jsBridge;

@end

@implementation WKWebView (JSBridge)

/**
 配置bridge的代理对象
 */
- (void)setUpBridgeWebViewDelegate:(id)delegate {
    
#ifdef DEBUG
    [WKWebViewJavascriptBridge enableLogging];
#else
#endif
    
    self.jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self];
    [self.jsBridge setWebViewDelegate:delegate];
    
}


/**
 H5调用本地的方法
 注意：调用前必须先设置配置JSBridge对象及其代理，调用-setUpBridgeWebViewDelegate:
 
 @param handlerName H5与本地交互的方法命名
 @param handler H5调用方法后的回调本地handler，通过 data获取 从H5回传出来的数据
 */
- (void)registerBridgeHandlerName:(NSString *)handlerName handler:(void(^)(id data, JSBridgeResponseCallback responseCallback))handler {
    [self.jsBridge registerHandler:handlerName handler:handler];
}


/**
 本地调用H5的方法
 注意：调用前必须先设置配置JSBridge对象及其代理，调用-setUpBridgeWebViewDelegate:
 
 @param handlerName 调用H5已有的方法名称
 @param data 传给H5的数据
 @param responseCallback H5方法调用后的回调
 */
- (void)callBridgeHandlerName:(NSString *)handlerName data:(id)data responseCallback:(JSBridgeResponseCallback)responseCallback {
    [self.jsBridge callHandler:handlerName data:data responseCallback:responseCallback];
}


#pragma mark - swizzle 通过分类给 WKWebView 实例对象添加属性
- (void)setJsBridge:(WKWebViewJavascriptBridge *)jsBridge {
    objc_setAssociatedObject(self, @selector(jsBridge), jsBridge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WKWebViewJavascriptBridge *)jsBridge {
    return objc_getAssociatedObject(self, @selector(jsBridge));
}


@end
