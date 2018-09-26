//
//  EFPrintTool.h
//  hk-eform-ipad
//
//  Created by Jacob_Liang on 2018/9/25.
//  Copyright © 2018年 Amway. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EFPrintStatus) {
    EFPrintStatusPrintSuccess = 200,
    EFPrintStatusPrintFailure = 506,
    EFPrintStatusPrinterOffLine,
    EFPrintStatusPrinting,
    EFPrintStatusNoTaskToPrint,
    EFPrintStatusContactPrinter,
    EFPrintStatusConnectFileUrl,
    EFPrintStatusCancelReSelectPrinter,
};

typedef void(^CompletionBlock)(NSString *dataJSONStr, EFPrintStatus code, NSString *msg);

@interface EFPrintTool : NSObject

/// 选择打印机
+ (void)selectPrinter;

/// 打印远程文件
- (void)printFiles:(NSArray<NSString *> *)fileUrls compeletion:(CompletionBlock)completionBlock;

@end
