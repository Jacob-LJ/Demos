//
//  JSPluginResult.m
//  WKWebViewDemo
//
//  Created by 莫至钊 on 2017/7/25.
//  Copyright © 2017年 莫至钊. All rights reserved.
//

#import "JSPluginResult.h"

@interface JSPluginResult ()

{
    JSResultStatus _status;
    NSString *_message;
    NSArray *_jsonObj;
    NSString *_callBackID;
}

@end

@implementation JSPluginResult

+ (instancetype)resultWithStatus:(JSResultStatus)status jsonObj:(NSArray *)jsonObj message:(NSString *)message callBackID:(NSString *)callBackID
{
    JSPluginResult *result = [[JSPluginResult alloc] init];
    result->_message = message;
    result->_status = status;
    result->_jsonObj = jsonObj;
    result->_callBackID = callBackID;
    return result;
}

- (NSString *)getJsonStr
{
    NSDictionary *jsonDic = @{@"code": @(_status),
                              @"data": _jsonObj ?: @{},
                              @"msg" : _message ?: @"",
                              @"callBackID" : _callBackID ?: @""};

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

- (void)dealloc
{
    NSLog(@"result----dealloc");
}

@end
