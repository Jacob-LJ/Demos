//
//  JADiffPrinterSyncAsyncPrintController.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/17.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "JADiffPrinterSyncAsyncPrintController.h"

/// 同时连接两台打印机进行打印(不行)，只能一个一个 或 printItems 处理
@interface JADiffPrinterSyncAsyncPrintController ()<UIPrintInteractionControllerDelegate>

@property (nonatomic, strong) NSData *taskData1;
@property (nonatomic, strong) NSData *taskData2;

@property (nonatomic, copy) NSString *printerUrl1;
@property (nonatomic, copy) NSString *printerName1;

@property (nonatomic, copy) NSString *printerUrl2;
@property (nonatomic, copy) NSString *printerName2;

@end

@implementation JADiffPrinterSyncAsyncPrintController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"VIP application form.pdf" ofType:nil];
    self.taskData1 = [NSData dataWithContentsOfFile:path];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"ceshi.pdf" ofType:nil];
    self.taskData2 = [NSData dataWithContentsOfFile:path2];
}

// 两台打印机同步打印（方案不可行）
- (IBAction)print2TaskSync {
    [self printTask1:@"同时打印1"];
    [self printTast2:@"同时打印2"]; // 同时只能连接一个打印机，以最后处理为准
}

/// 在不同打印机打印2个任务(只能先后处理)
- (IBAction)print2TaskOneByOne {
    [self printTask1:@"任务1"]; // 任务1打印完后，通过 delegate 回调，再处理任务2
}

#pragma mark - 先选打印机
/// 选择 打印机1
- (IBAction)selectPrinter1 {
    UIPrinterPickerController *pickerController = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    [pickerController presentAnimated:YES completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
        if (userDidSelect) {
            self.printerUrl1 = printerPickerController.selectedPrinter.URL.absoluteString;
            self.printerName1 = printerPickerController.selectedPrinter.displayName;
        }
    }];
    
}

/// 选择 打印机2
- (IBAction)selectPrinter2:(id)sender {
    UIPrinterPickerController *pickerController = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    [pickerController presentAnimated:YES completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
        if (userDidSelect) {
            self.printerUrl2 = printerPickerController.selectedPrinter.URL.absoluteString;
            self.printerName2 = printerPickerController.selectedPrinter.displayName;
        }
    }];
}

#pragma mark - 打印任务
/// 通过打印机1 打印 任务1
- (void)printTask1:(NSString *)taskName {
    [[UIPrinter printerWithURL:[NSURL URLWithString:self.printerUrl1]] contactPrinter:^(BOOL available) {
        if (available) {
            NSLog(@"AIRPRINTER AVAILABLE");
            [self printOperationWithPrinterUrl:self.printerUrl1 taskName:taskName taskData:self.taskData1];
        } else {
            NSLog(@"AIRPRINTER NOT AVAILABLE");
        }
    }];
    
}


/// 通过打印机2 打印 任务2
- (void)printTast2:(NSString *)taskName {
    [[UIPrinter printerWithURL:[NSURL URLWithString:self.printerUrl2]] contactPrinter:^(BOOL available) {
        if (available) {
            NSLog(@"AIRPRINTER AVAILABLE");
            [self printOperationWithPrinterUrl:self.printerUrl2 taskName:taskName taskData:self.taskData2];
        } else {
            NSLog(@"AIRPRINTER NOT AVAILABLE");
        }
    }];
}

/// 单个任务处理
- (void)printOperationWithPrinterUrl:(NSString *)printerUrl taskName:(NSString *)taskName taskData:(NSData *)taskData {
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.jobName = taskName;
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    [UIPrintInteractionController sharedPrintController].delegate = self;
    [UIPrintInteractionController sharedPrintController].printInfo = printInfo;
    [UIPrintInteractionController sharedPrintController].printingItem = taskData;
    
    UIPrinter *airPrinter = [UIPrinter printerWithURL:[NSURL URLWithString:printerUrl]];
    [[UIPrintInteractionController sharedPrintController] printToPrinter:airPrinter completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        
        if(completed && error) {
            NSLog(@"Printing failed due to error in domain %@ with error code %lu. Localized description: %@, and failure reason: %@", error.domain, (long)error.code, error.localizedDescription, error.localizedFailureReason);
        }
        
        
    }];
     
}

#pragma mark - UIPrintInteractionControllerDelegate
//- ( UIViewController * _Nullable )printInteractionControllerParentViewController:(UIPrintInteractionController *)printInteractionController {
//
//}

//- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray<UIPrintPaper *> *)paperList {
//
//}

- (void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __func__);
}

- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __func__);
}

- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __func__);
}

- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __func__);
}

- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __func__);
}


- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __func__);
    // 任务1打印完成后，再打印任务2
    if ([printInteractionController.printInfo.jobName isEqualToString:@"任务1"]) {
        [self printTast2:@"任务2"];
    }
}

//// iOS 7.0
//- (CGFloat)printInteractionController:(UIPrintInteractionController *)printInteractionController cutLengthForPaper:(UIPrintPaper *)paper {
//
//    return 0;
//}
//
//// iOS 9.0
//- (UIPrinterCutterBehavior) printInteractionController:(UIPrintInteractionController *)printInteractionController chooseCutterBehavior:(NSArray *)availableBehaviors {
//    return UIPrinterCutterBehaviorNoCut;
//}


@end
