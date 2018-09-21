//
//  JSInvokedCommand.m
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/7/25.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import "JSInvokedCommand.h"

@interface JSInvokedCommand ()
{
    NSDictionary *_parameter;
    NSString *_methodName;
    NSString *_className;
    NSString *_callBackFunc;
    NSString *_callBackID;
}
@end

@implementation JSInvokedCommand

- (instancetype)initWithParameter:(NSString *)parameter className:(NSString *)className methodName:(NSString *)methodName callBackFunc:(NSString *)callBackFunc callBackID:(NSString *)callBackID
{
    self = [super init];
    _parameter = [JSPlugIn dictionaryWithJsonString:parameter];
    _methodName = methodName;
    _className = className;
    _callBackFunc = callBackFunc;
    _callBackID = callBackID;
    return self;
}

- (void)dealloc
{
    NSLog(@"command---dealoc");
}

@end
