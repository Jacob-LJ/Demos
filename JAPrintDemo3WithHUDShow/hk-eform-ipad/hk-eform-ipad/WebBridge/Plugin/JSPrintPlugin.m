
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
    [printTool printFiles:fileUrls compeletion:^(BOOL completed) {
        [weakSelf didCompletedPrintOperation:completed];
    }];
    self.printTool = printTool;
    
}

// 完成打印后的回调
- (void)didCompletedPrintOperation:(BOOL)completed {
    NSDictionary *resultDict = nil;
    if (completed) {
        resultDict = @{@"data":@{},@"code":@200,@"msg":@"打印完成"}; // 参考的Plugin这样写的，原因应该是保证后续接手人能够知道各个参数意义
    } else {
        resultDict = @{@"data":@{},@"code":@506,@"msg":@"打印失败"};
    }
    JSPluginResult *result = [JSPluginResult resultWithStatus:[self JSResultStatusFromCode:resultDict[@"code"]]
                                                      jsonObj:resultDict[@"data"]
                                                      message:resultDict[@"msg"]
                                                   callBackID:self.command.callBackID];
    [self.delegate sendPluginResult:result JSInvokedCommand:self.command];
}

#pragma mark - 数值的 code 和 JSResultStatus 关联映射
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
