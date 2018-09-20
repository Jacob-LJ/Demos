
//
//  JSPrintPlugin.m
//  hk-eform-ipad
//
//  Created by Jacob_Liang on 2018/9/19.
//  Copyright © 2018年 Amway. All rights reserved.
//

#import "JSPrintPlugin.h"

#define kEFPrinterURL @"EFPrinterURL"
#define kEFPrinterName @"EFPrinterName"

@interface JSPrintPlugin ()<UIPrintInteractionControllerDelegate>

@property (nonatomic, strong) NSArray<NSString *> *fileUrls;
@property (nonatomic, strong) JSInvokedCommand *invokeCommand;

@end

@implementation JSPrintPlugin

// 根据传入的 urls 打印远程 pdf 文件
- (void)JSPrintRemotePdfs:(JSInvokedCommand *)command {
    
    NSArray<NSString *> *fileUrls = command.parameter[@"fileUrls"];
    self.fileUrls = fileUrls;
    self.invokeCommand = command;
    __weak typeof(self) weakSelf = self;

    // 是否保存打印机信息
    NSString *printerUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:kEFPrinterURL];
    if (printerUrlStr.length) {
        [self printFiles:fileUrls printerUrl:[NSURL URLWithString:printerUrlStr] completionBlock:^(BOOL completed) {
            [weakSelf didCompletedPrintOperation:completed invokedCommand:command];
        }];
    } else {
        /// 没有选择过打印机，优先选择打印机
        [self selectPrinterCompletion:^(BOOL didSavePrinterUrl, NSString *printerURLStr) {
            if (didSavePrinterUrl) {
                // 完成打印机选择后进行打印
                [weakSelf printFiles:fileUrls printerUrl:[NSURL URLWithString:printerURLStr] completionBlock:^(BOOL completed) {
                    [weakSelf didCompletedPrintOperation:completed invokedCommand:command];
                }];
            }
        }];
    }
    
}

// 完成打印后的回调
- (void)didCompletedPrintOperation:(BOOL)completed invokedCommand:(JSInvokedCommand *)command {
    NSDictionary *resultDict = nil;
    if (completed) {
        resultDict = @{@"data":@{},@"code":@200,@"msg":@"打印完成"}; // 参考的Plugin这样写的，原因应该是保证后续接手人能够知道各个参数意义
    } else {
        resultDict = @{@"data":@{},@"code":@506,@"msg":@"没有可打印内容"};
    }
    JSPluginResult *result = [JSPluginResult resultWithStatus:[self JSResultStatusFromCode:resultDict[@"code"]]
                                                      jsonObj:resultDict[@"data"]
                                                      message:resultDict[@"msg"]
                                                   callBackID:command.callBackID];
    [self.delegate sendPluginResult:result JSInvokedCommand:command];
}


#pragma mark - 打印操作

/// 预览形式打印
- (void)printFiles:(NSArray<NSString *> *)fileUrls printerUrl:(NSURL *)printerUrl completionBlock:(void(^)(BOOL completed))completionBlock {
    
    // 进行任务可打印性过滤
    if (![self printFilesFilter:fileUrls]) {
        // 任务都不可打印
        if (completionBlock) {
            completionBlock(NO);
        }
        return;
    }
    
    // 字符串 urls 转为 NSURLs 对象数组
    NSMutableArray *urlItems = [NSMutableArray array];
    [fileUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [urlItems addObject:[NSURL URLWithString:obj]];
    }];
    
    // 打印任务信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"hk-eform-ipad";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 打印预览控制器
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    pic.printInfo = printInfo;
    pic.printingItems = urlItems; //// array of NSData, NSURL, UIImage, ALAsset. does not support page range 不支持打印预览
    
    
    // 直接链接打印机打印
    UIPrinter *airPrinter = [UIPrinter printerWithURL:printerUrl];
    // 检查 printer 是否 online
    [airPrinter contactPrinter:^(BOOL available) {
        
        if (!available) {
            // 打印机不在线，提示重新选择打印机
            [self showPrinterOfflineAlert];
            return;
        }
        
        // 打印机 online
        [[UIPrintInteractionController sharedPrintController] printToPrinter:airPrinter completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
            if (error) {
                NSLog(@"打印失败! error %@",error);
                if (completionBlock) {
                    completionBlock(NO);
                }
                
            } else {
                if (completed) {
                    NSLog(@"打印完成");
                } else {
                    NSLog(@"打印失败-no error");
                }
                
                if (completionBlock) {
                    completionBlock(completed);
                }
            }
            
        }];
    }];
}

/// public - 选择打印机
+ (void)selectPrinter {
    JSPrintPlugin *plugin = [[JSPrintPlugin alloc] init];
    [plugin selectPrinterCompletion:NULL];
}

/// 选择打印机
- (void)selectPrinterCompletion:(void(^)(BOOL didSavePrinterUrl, NSString *printerURLStr))completionBlcok {
    
    UIPrinterPickerController *pickerController = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    UINavigationController *rootNva = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIBarButtonItem *rightItem = rootNva.topViewController.navigationItem.rightBarButtonItem;
    
    [pickerController presentFromBarButtonItem:rightItem animated:YES completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
        NSString *printerUrlStr = printerPickerController.selectedPrinter.URL.absoluteString;
        NSString *printerName = printerPickerController.selectedPrinter.displayName;
        BOOL didsave = NO;
        if (userDidSelect && printerUrlStr.length) {
            [[NSUserDefaults standardUserDefaults] setObject:printerUrlStr forKey:kEFPrinterURL];
            didsave = YES;
            NSLog(@"已选择打印机：URL-%@, Name-%@",printerUrlStr, printerName);
        }
        
        if (completionBlcok) {
            completionBlcok(didsave, printerUrlStr);
        }
    }];
    
}

/// 任务可打印性过滤
- (BOOL)printFilesFilter:(NSArray<NSString *> *)fileUrls {
    // 没有文件打印
    if (!fileUrls.count) {
        NSLog(@"任务不可打印");
        return NO;
    }
    
    // 只要有一份不能打印，即全部不能打印
    __block BOOL canPrintAll = YES;
    if (fileUrls.count > 1) {
        [fileUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![UIPrintInteractionController canPrintURL:[NSURL URLWithString:obj]]) {
                canPrintAll = NO;
                *stop = YES;
            }
        }];
    } else {
        if (![UIPrintInteractionController canPrintURL:[NSURL URLWithString:fileUrls.firstObject]]) { //如果虚拟打印机没启动，这个检测时间有点久, 或者网络情况差的话，也是很久
            canPrintAll = NO;
            
        }
    }
    
    if (!canPrintAll) NSLog(@"任务不可打印");
    return canPrintAll;
}

- (void)showPrinterOfflineAlert {
    
    UINavigationController *rootNva = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = rootNva.topViewController;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"打印机链接失败" message:@"是否重新选择打印机？" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [topVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 选择新的打印机
        [weakSelf selectPrinterCompletion:^(BOOL didSavePrinterUrl, NSString *printerURLStr) {
            if (didSavePrinterUrl) {
                // 完成打印机选择后进行打印
                [weakSelf printFiles:self.fileUrls printerUrl:[NSURL URLWithString:printerURLStr] completionBlock:^(BOOL completed) {
                    [weakSelf didCompletedPrintOperation:completed invokedCommand:weakSelf.invokeCommand];
                }];
            }
        }];
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [topVC presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - 数值的 code 和 JSResultStatus 关联映射
- (JSResultStatus)JSResultStatusFromCode:(NSNumber*)code {
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
