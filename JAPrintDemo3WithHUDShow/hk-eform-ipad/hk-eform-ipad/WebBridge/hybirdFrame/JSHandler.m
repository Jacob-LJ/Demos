//
//  JSHandler.m
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/7/25.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import "JSHandler.h"
#import "JSPlugIn.h"
#import "JSInvokedCommand.h"

@interface JSHandler ()

{
    __weak JSBridgeWKWebViewController *_viewController;
    NSMutableDictionary *_cacheDic;
}

@end

@implementation JSHandler

- (instancetype)initWithJSBridgeWKWebViewController:(JSBridgeWKWebViewController *)JSBridgeWKWebViewController
{
    self = [super init];
    _viewController = JSBridgeWKWebViewController;
    _cacheDic = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary *dic = [JSPlugIn dictionaryWithJsonString:message.body];
//    NSDictionary *callBackDic = [JSPlugIn dictionaryWithJsonString:dic[@"callBack"]];
    
    // 根据className返回plugin的对应子类
    JSPlugIn *plugin = [JSPlugIn configWithClassName:dic[@"className"]
                                methodName:dic[@"funcName"]
                                callBackFunc:dic[@"callBack"]
                                callBackID:@"1" // 放弃该方案，不再需要该字段
                                parameter:dic[@"parameter"]];
    if (!plugin) {
        return;
    }
    [_cacheDic setObject:plugin forKey:@(plugin.command.hash)];
    plugin.delegate = self;
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", dic[@"funcName"]]);
    if ([plugin respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [plugin performSelector:sel withObject:plugin.command];
#pragma clang diagnostic pop
    }   
}

- (void)sendPluginResult:(JSPluginResult *)result JSInvokedCommand:(JSInvokedCommand *)JSInvokedCommand
{
    [_cacheDic removeObjectForKey:@(JSInvokedCommand.hash)];
    NSString *js = [NSString stringWithFormat:@"%@(%@);", JSInvokedCommand.callBackFunc, [result getJsonStr]];
    [_viewController.WKWebView evaluateJavaScript:js completionHandler:^(id _Nullable parameter, NSError * _Nullable error) {
//        NSLog(@"%@==%@", parameter, error);
    }];
}

- (void)runInBackground:(void(^)(void))block
{
    dispatch_async(dispatch_queue_create(DISPATCH_TARGET_QUEUE_DEFAULT, 0), block);
}

- (void)dealloc
{
    NSLog(@"handler---dealloc");
}

@end
