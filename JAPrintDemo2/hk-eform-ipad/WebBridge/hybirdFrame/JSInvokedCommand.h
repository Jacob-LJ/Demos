//
//  JSInvokedCommand.h
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/7/25.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSCommandDelegate.h"
#import "JSPlugIn.h"

@interface JSInvokedCommand : NSObject

// 回调函数名
@property (nonatomic, readonly, copy) NSString *callBackFunc;

// 回调函数标识
@property (nonatomic, readonly, copy) NSString *callBackID;

// 类名
@property (nonatomic, readonly, copy) NSString *className;

// 方法名
@property (nonatomic, readonly, copy) NSString *methodName;

// 参数
@property (nonatomic, readonly, copy) NSDictionary *parameter;

/**
 * 初始化JS调用原生的指令动作类
 * param className 处理事件的类名
 * param methodName 处理事件的方法名
 * param callBackFunc 回调方法
 * param callBackID 回调标识
 * param parameter 参数
 *
 */
- (instancetype)initWithParameter:(NSString *)parameter className:(NSString *)className methodName:(NSString *)methodName callBackFunc:(NSString *)callBackFunc callBackID:(NSString *)callBackID;

@end
