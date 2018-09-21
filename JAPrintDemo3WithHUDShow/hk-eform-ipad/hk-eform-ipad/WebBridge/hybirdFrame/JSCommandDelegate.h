//
//  JSCommandDelegate.h
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/7/25.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSPluginResult.h"
@class JSInvokedCommand;

@protocol JSCommandDelegate <NSObject>

/**
 * 发送回调协议必须遵守的方法
 * param result 回调结果类
 * param JSInvokedCommand JS指令
 *
 */
- (void)sendPluginResult:(JSPluginResult *)result JSInvokedCommand:(JSInvokedCommand *)JSInvokedCommand;

// 通过异步回调
- (void)runInBackground:(void(^)(void))block;

@end
