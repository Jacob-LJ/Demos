//
//  JSPluginResult.h
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/7/25.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JSResultStatus_OK = 200,
    JSResultStatus_Faild = 506,
    JSResultStatus_NotFound = 404,
} JSResultStatus;

@interface JSPluginResult : NSObject

// 回调状态
@property (nonatomic, readonly) JSResultStatus status;

// 回调json
@property (nonatomic, readonly, copy) NSArray *jsonObj;

// 回调信息
@property (nonatomic, readonly, copy) NSString *message;

// 回调标识
@property (nonatomic, readonly, copy) NSString *callBackID;


/**
 * 初始化返回JS的回调类
 * param status 回调状态
 * param jsonObj 回调的JSON对象
 * param message 回调信息
 * param callBackID 回调标识
 */
+ (instancetype)resultWithStatus:(JSResultStatus)status jsonObj:(NSArray *)jsonObj message:(NSString *)message callBackID:(NSString *)callBackID;

// 把返回JS的回调类转为JSON对象
- (NSString *)getJsonStr;

@end
