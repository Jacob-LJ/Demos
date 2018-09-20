//
//  JSPlugIn.m
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/8/9.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import "JSPlugIn.h"

@implementation JSPlugIn

+ (instancetype)configWithClassName:(NSString *)className methodName:(NSString *)methodName callBackFunc:(NSString *)callBackFunc callBackID:(NSString *)callBackID parameter:(NSString *)parameter
{
    JSPlugIn *obj = (JSPlugIn *)[[NSClassFromString(className) alloc] init];
    JSInvokedCommand *command = [[JSInvokedCommand alloc]
                                 initWithParameter:parameter
                                 className:className
                                 methodName:methodName
                                 callBackFunc:callBackFunc
                                 callBackID:callBackID];
    obj.command = command;
    return obj;
}

- (JSBridgeWKWebViewController *)viewController
{
    JSHandler *handler = (JSHandler *)self.delegate;
    return handler.viewController;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if ([jsonString isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        return (NSDictionary *)jsonString;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil;
    }
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return jsonDic;
}

- (void)dealloc
{
    NSLog(@"%@---dealloc", self);
}


@end
