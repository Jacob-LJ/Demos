//
//  EFPrintTool.m
//  hk-eform-ipad
//
//  Created by Jacob_Liang on 2018/9/25.
//  Copyright © 2018年 Amway. All rights reserved.
//

#import "EFPrintTool.h"

#define kEFPrinterURL @"EFPrinterURL"
#define kEFPrinterName @"EFPrinterName"

typedef NS_ENUM(NSUInteger, HUDStatusType) {
    HUDStatusTypePrintSuccess = 1,
    HUDStatusTypePrintFailure,
    HUDStatusTypePrinterOffLine,
    HUDStatusTypePrinting,
    HUDStatusTypeNoTaskToPrint,
    HUDStatusTypeContactPrinter,
    HUDStatusTypeConnectFileUrl,
};

@interface EFPrintTool ()<UIPrinterPickerControllerDelegate>

@property (nonatomic, strong) UIViewController *topVC;
@property (nonatomic, strong) NSDictionary *statusDict;
@property (nonatomic, strong) NSArray<NSString *> *fileUrls;

@end

@implementation EFPrintTool

/// 选择打印机
+ (void)selectPrinter {
    EFPrintTool *printTool = [[EFPrintTool alloc] init];
    [printTool selectPrinterCompletion:NULL];
}

/// 打印远程文件
- (void)printFiles:(NSArray<NSString *> *)fileUrls compeletion:(void(^)(BOOL completed))completionBlock {
    
    self.fileUrls = fileUrls;
    __weak typeof(self) weakSelf = self;
    
    // 是否保存打印机信息
    NSString *printerUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:kEFPrinterURL];
    if (printerUrlStr.length) {
        [self printFiles:fileUrls printerUrl:[NSURL URLWithString:printerUrlStr] completionBlock:^(BOOL completed) {
            if (completionBlock) {
                completionBlock(completed);
            }
        }];
    } else {
        /// 没有选择过打印机，优先选择打印机
        [self selectPrinterCompletion:^(BOOL didSavePrinterUrl, NSString *printerURLStr) {
            if (didSavePrinterUrl) {
                // 完成打印机选择后进行打印
                [weakSelf printFiles:fileUrls printerUrl:[NSURL URLWithString:printerURLStr] completionBlock:^(BOOL completed) {
                    if (completionBlock) {
                        completionBlock(completed);
                    }
                }];
            }
        }];
    }
}

/// 选择打印机
- (void)selectPrinterCompletion:(void(^)(BOOL didSavePrinterUrl, NSString *printerURLStr))completionBlcok {
    
    UIPrinterPickerController *pickerController = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    UIBarButtonItem *rightItem = self.topVC.navigationItem.rightBarButtonItem;
    
    [pickerController presentFromBarButtonItem:rightItem animated:YES completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
        
        NSLog(@"打印机选择控制器：%@，用户是否选择打印机：%@，error：%@",printerPickerController, userDidSelect?@"已选":@"取消", error);
        
        NSString *printerUrlStr = printerPickerController.selectedPrinter.URL.absoluteString;
        NSString *printerName = printerPickerController.selectedPrinter.displayName;
        BOOL didsave = NO;
        if (userDidSelect && printerUrlStr.length) {
            [[NSUserDefaults standardUserDefaults] setObject:printerUrlStr forKey:kEFPrinterURL];
            [[NSUserDefaults standardUserDefaults] synchronize];
            didsave = YES;
            NSLog(@"已选择打印机：URL-%@, Name-%@",printerUrlStr, printerName);
        }
        
        if (completionBlcok) {
            completionBlcok(didsave, printerUrlStr);
        }
    }];
    
}

#pragma mark - 打印操作

/// 链接打印机直接打印
- (void)printFiles:(NSArray<NSString *> *)fileUrls printerUrl:(NSURL *)printerUrl completionBlock:(void(^)(BOOL completed))completionBlock {
    
    // 进行任务可打印性过滤
    [self printFilesFilter:fileUrls completion:^(BOOL canprintAll) {
        // 任务都不可打印
        if (!canprintAll) {
            if (completionBlock) {
                completionBlock(NO);
                [self showHUDAutoHideWithtitle:HUDStatusTypeNoTaskToPrint];
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
        pic.printInfo = printInfo;
        pic.printingItems = urlItems; //// array of NSData, NSURL, UIImage, ALAsset. does not support page range 不支持打印预览
        
        // 直接链接打印机打印
        UIPrinter *airPrinter = [UIPrinter printerWithURL:printerUrl];
        // 检查 printer 是否 online
        [self showHUDWithTitle:HUDStatusTypeContactPrinter];
        [airPrinter contactPrinter:^(BOOL available) { // 这个检测方法是异步的，最长耗时30s
            [self hideHUD];
            
            if (!available) {
                // 打印机不在线，提示重新选择打印机，选择打印机后会直接打印该任务
                [self showPrinterOfflineAlertCompletionBlock:completionBlock];
                return;
            }
            
            [self showHUDAutoHideWithtitle:HUDStatusTypePrinting];
            
            // 打印机 online
            [[UIPrintInteractionController sharedPrintController] printToPrinter:airPrinter completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
                if (error) {
                    if (completionBlock) {
                        completionBlock(NO);
                    }
                    return;
                }
                
                if (completed) {
                    [self showHUDAutoHideWithtitle:HUDStatusTypePrintSuccess];
                } else {
                    [self showHUDAutoHideWithtitle:HUDStatusTypePrintFailure];
                }
                
                if (completionBlock) {
                    completionBlock(completed);
                }
                NSLog(@"打印回调 - completed:%d, error: %@", completed, error);
                
            }];
        }];
        
    }];
    
}

/// 检测任务url是否可打印
- (void)printFilesFilter:(NSArray<NSString *> *)fileUrls completion:(void(^)(BOOL canprintAll))compeletionBlock {
    
    [self showHUDWithTitle:HUDStatusTypeConnectFileUrl];
    
    // 没有文件打印
    if (!fileUrls.count) {
        NSLog(@"任务不可打印");
        if (compeletionBlock) {
            compeletionBlock(NO);
        }
    }
    
    // 这里使用异步原因是 检测 URL 耗时较长，会阻塞主线程，HUD 显示不出来
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (compeletionBlock) {
                compeletionBlock(canPrintAll);
            }
        });
    });
    
}

/// 提示，重新选择打印机，选择后会立即打印任务
- (void)showPrinterOfflineAlertCompletionBlock:(void(^)(BOOL completed))completionBlock {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"打印机链接失败" message:@"是否重新选择打印机？" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    [alertVc addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completionBlock) {
            completionBlock(NO);
        }
        [weakSelf.topVC dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertVc addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 选择新的打印机
        [weakSelf selectPrinterCompletion:^(BOOL didSavePrinterUrl, NSString *printerURLStr) {
            if (didSavePrinterUrl) {
                // 完成打印机选择后 立即进行打印
                [weakSelf printFiles:weakSelf.fileUrls printerUrl:[NSURL URLWithString:printerURLStr] completionBlock:^(BOOL completed) {
                    if (completionBlock) {
                        completionBlock(completed);
                    }
                }];
            }
        }];
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self.topVC presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - HUD
- (void)showHUDWithTitle:(HUDStatusType)hudStatusType {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.topVC.view];
    if (hud) {
        [hud hideAnimated:NO];
    }
    NSString *title = self.statusDict[@(hudStatusType)];
    [MBProgressHUD showLoadToView:self.topVC.view
                  backgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]
                            title:title];
    
}

- (void)hideHUD {
    [MBProgressHUD hideHUDForView:self.topVC.view];
}

- (void)showHUDAutoHideWithtitle:(HUDStatusType)hudStatusType {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.topVC.view];
    if (hud) {
        [hud hideAnimated:NO];
    }
    NSString *title = self.statusDict[@(hudStatusType)];
    [MBProgressHUD showTitleToView:self.topVC.view postion:NHHUDPostionCenten title:title];
}


#pragma mark - getter & setter
- (UIViewController *)topVC {
    if (!_topVC) {
        UINavigationController *rootNva = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *topVC = rootNva.topViewController;
        _topVC = topVC;
    }
    return _topVC;
}

- (NSDictionary *)statusDict {
    if (!_statusDict) {
        _statusDict = @{
                        @(HUDStatusTypePrintSuccess) : @"打印成功",
                        @(HUDStatusTypePrintFailure) : @"打印失败",
                        @(HUDStatusTypePrinterOffLine) : @"打印机离线，请重新选择打印机",
                        @(HUDStatusTypePrinting) : @"正在打印中",
                        @(HUDStatusTypeNoTaskToPrint) : @"任务不可打印",
                        @(HUDStatusTypeContactPrinter) : @"正在链接打印机",
                        @(HUDStatusTypeConnectFileUrl) : @"链接打印任务",
                        };
    }
    return _statusDict;
}

@end
