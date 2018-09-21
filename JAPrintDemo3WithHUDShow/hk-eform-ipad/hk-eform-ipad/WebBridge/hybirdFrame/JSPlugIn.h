//
//  JSPlugIn.h
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/8/9.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "JSHandler.h"
#import "JSInvokedCommand.h"

@interface JSPlugIn : NSObject

// JS指令
@property (nonatomic, strong) JSInvokedCommand *command;

// 插件的代理，用于处理回调方法
@property (nonatomic, weak) id<JSCommandDelegate> delegate;

/**
 * 插件分发对应实现
 * param className 处理事件的类名
 * param methodName 处理事件的方法名
 * param callBackFunc 回调方法
 * param callBackID 回调标识
 * param parameter 参数
 *
 */
+ (instancetype)configWithClassName:(NSString *)className methodName:(NSString *)methodName callBackFunc:(NSString *)callBackFunc callBackID:(NSString *)callBackID parameter:(NSString *)parameter;

/**
 * 将json字符串转为字典对象
 * param jsonString JSON字符串
 *
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 * 获取当前JS操作的WKWebViewController
 *
 */
- (JSBridgeWKWebViewController *)viewController;

@end
