
//
//  JSPrintPlugin.m
//  hk-eform-ipad
//
//  Created by Jacob_Liang on 2018/9/19.
//  Copyright © 2018年 Amway. All rights reserved.
//

#import "JSPrintPlugin.h"
#import "EFPrintTool.h"


@interface JSPrintPlugin ()

@property (nonatomic, strong) EFPrintTool *printTool;
@property (nonatomic, strong) JSInvokedCommand *invokeCommand;

@end

@implementation JSPrintPlugin

/// 根据传入的 urls 打印远程 pdf 文件
- (void)JSPrintRemotePdfs:(JSInvokedCommand *)command {
    self.invokeCommand = command;
    
    NSArray<NSString *> *fileUrls = command.parameter[@"fileUrls"];
    __weak typeof(self) weakSelf = self;
    
    EFPrintTool *printTool = [[EFPrintTool alloc] init];
    [printTool printFiles:fileUrls compeletion:^(NSString *dataJSONStr, EFPrintStatus code, NSString *msg) {
        // 完成打印后的回调

        NSDictionary *resultDict = @{@"data":dataJSONStr.length ? dataJSONStr : @"",
                                     @"code":@(code),
                                     @"msg":msg.length ? msg : @""}; // 参考的Plugin这样写的，原因应该是保证后续接手人能够知道各个参数意义
        
        JSPluginResult *result = [JSPluginResult resultWithStatus:[weakSelf JSResultStatusFromCode:resultDict[@"code"]]
                                                          jsonObj:resultDict[@"data"]
                                                          message:resultDict[@"msg"]
                                                       callBackID:weakSelf.command.callBackID];
        [weakSelf.delegate sendPluginResult:result JSInvokedCommand:weakSelf.command];
        
        
    }];
    self.printTool = printTool;
    
}

#pragma mark - 数值的 code 和 JSResultStatus 关联映射
// JSResultStatus 用于通用组件的共用状态码，如需要其他状态码可以通过 plugin 类来组合定义，必须留下注释
- (JSResultStatus)JSResultStatusFromCode:(NSNumber*)code {
    JSResultStatus resultStatus;
    NSNumber *number = code;
    if ([number isEqual:@200]) {
        resultStatus = JSResultStatus_OK;
    } else if ([number isEqual:@506]) {
        resultStatus = JSResultStatus_Faild;
    } else {
        resultStatus = JSResultStatus_Faild;
    }
    return resultStatus;
}


@end
