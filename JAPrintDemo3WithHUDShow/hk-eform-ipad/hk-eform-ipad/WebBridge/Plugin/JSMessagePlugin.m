
//  JSMessagePlugin.m
//  messageCenterDemo
//
//  Created by dolway on 2018/8/27.
//  Copyright © 2018年 ISS. All rights reserved.
//

#import "JSMessagePlugin.h"
#import "DCHMessageOperator.h"
@implementation JSMessagePlugin
// 获取分类列表
- (void)JSgetCategories:(JSInvokedCommand *)command{
    
    NSDictionary *dict = [[DCHMessageOperator shareInstance] getCategories];
    JSPluginResult *result = [JSPluginResult resultWithStatus:[self JSResultStatusFromCode:dict[@"code"]]  jsonObj:dict[@"data"] message:dict[@"msg"] callBackID:command.callBackID];
    [self.delegate sendPluginResult:result JSInvokedCommand:command];
}

// 根据消息分类ID查询消息
- (void)JSgetMessagesForCatalog:(JSInvokedCommand *)command{
    NSString *categoryId = [NSString stringWithFormat:@"%@",command.parameter[@"templateTypeId"]];
    NSString *lastmsgId = [NSString stringWithFormat:@"%@",command.parameter[@"lastmsgId"]];
    NSString *count = [NSString stringWithFormat:@"%@",command.parameter[@"count"]];
    [[DCHMessageOperator shareInstance] getMessagesForCatalogByCatalogId:categoryId lastmsgId:lastmsgId count:count completed:^(NSDictionary *dict) {
        
        JSPluginResult *result = [JSPluginResult resultWithStatus:[self JSResultStatusFromCode:dict[@"code"]]  jsonObj:dict[@"data"] message:dict[@"msg"] callBackID:command.callBackID];
        [self.delegate sendPluginResult:result JSInvokedCommand:command];
        
    }];
    

}

// 通过消息ID查询消息
- (void)JSgetMessagesById:(JSInvokedCommand *)command{
    NSString *msgId = [NSString stringWithFormat:@"%@",command.parameter[@"msgId"]];
    
    NSDictionary * dict = [[DCHMessageOperator shareInstance] getMessagesById:msgId];
    
    JSPluginResult *result = [JSPluginResult resultWithStatus:[self JSResultStatusFromCode:dict[@"code"]] jsonObj:dict[@"data"] message:dict[@"msg"] callBackID:command.callBackID];
    [self.delegate sendPluginResult:result JSInvokedCommand:command];
    
}
// 删除消息
- (void)JSdeleteMessagesById:(JSInvokedCommand *)command{
    NSString *msgId = [NSString stringWithFormat:@"%@",command.parameter[@"msgId"]];
    NSDictionary * __block dict;
    // 删除服务端数据
    [[DCHMessageOperator shareInstance] deleteMessageByID:msgId success:^(id response) {
        dict = [[DCHMessageOperator shareInstance] deleteMessagesById:msgId];
    } failure:^(NSError *error) {
        dict = @{@"data":@[@{}],@"code":@506,@"msg":@"删除消息失败"};
    }];
    JSPluginResult *result = [JSPluginResult resultWithStatus:[self JSResultStatusFromCode:dict[@"code"]]  jsonObj:dict[@"data"] message:dict[@"msg"] callBackID:command.callBackID];
    [self.delegate sendPluginResult:result JSInvokedCommand:command];
    

}
// 标记消息为已读
- (void)JSmarkMessgeRaeded:(JSInvokedCommand *)command{
    NSArray<NSString *> *msgIds = command.parameter[@"msgIdArr"];
    NSDictionary * __block dict;
    [[DCHMessageOperator shareInstance] batchDeliveryReportMessageByIDs:msgIds success:^(id response) {
        dict = [[DCHMessageOperator shareInstance] markMessgeRaeded:msgIds];
    } failure:^(NSError *error) {
        dict = @{@"data":@[@{}],@"code":@506,@"msg":@"标记消息失败"};
    }];
    JSPluginResult *result = [JSPluginResult resultWithStatus:[self JSResultStatusFromCode:dict[@"code"]]  jsonObj:dict[@"data"] message:dict[@"msg"] callBackID:command.callBackID];
    [self.delegate sendPluginResult:result JSInvokedCommand:command];
}



- (JSResultStatus)JSResultStatusFromCode:(NSNumber*)code{
    JSResultStatus resultStatus;
    NSNumber *number = code;
    if ([number isEqual:@200]) {
        resultStatus = JSResultStatus_OK;
    }else if ([number isEqual:@506]) {
        resultStatus = JSResultStatus_Faild;
    }else{
        resultStatus = JSResultStatus_Faild;
    }
    return resultStatus;
}

@end
