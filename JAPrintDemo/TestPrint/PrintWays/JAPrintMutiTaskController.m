//
//  JAPrintMutiTaskController.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/17.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "JAPrintMutiTaskController.h"


/// 同类型多个任务单个打印机连续打印 - UIPrintInteractionController 的 printingItems 的使用
@interface JAPrintMutiTaskController ()<UIPrintInteractionControllerDelegate>

@property (nonatomic, copy) NSString *printerUrl1;
@property (nonatomic, copy) NSString *printerName1;

@property (nonatomic, strong) NSData *taskData1;
@property (nonatomic, strong) NSData *taskData2;
@property (nonatomic, strong) NSData *taskData3;

@end

@implementation JAPrintMutiTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"VIP application form.pdf" ofType:nil];
    self.taskData1 = [NSData dataWithContentsOfFile:path];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"ceshi.pdf" ofType:nil];
    self.taskData2 = [NSData dataWithContentsOfFile:path2];
    
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"car.jpg" ofType:nil];
    self.taskData3 = [NSData dataWithContentsOfFile:path3];
}

#pragma mark - 预览控制器形式打印
/// 预览式 同类型多个任务 打印
- (IBAction)previewPrintOneTypeMutiTasks:(id)sender {
    NSArray *items = @[self.taskData1, self.taskData1, self.taskData1];
    // NSData 数组
    [self printItems:items]; // 可以打印,但不支持预览，因为默认就不支持 pageRange，UIPrintInteractionController的printingItems属性内官方有说明
}

- (void)printItems:(NSArray *)items {
    // 打印信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"可直接打印的，不同类型的多个任务组"; // 一般以文件名称作为任务名称
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 打印预览控制器
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    pic.printingItems = items; //// array of NSData, NSURL, UIImage, ALAsset. does not support page range // 不支持打印预览的
    pic.printInfo = printInfo;

    
    [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        if (!completed && error)
            NSLog(@"FAILED! due to error in domain %@ with error code %ld",
                  error.domain, error.code);
    }];
}

#pragma mark - 通过记录的打印机打印
/// 选择打印机
- (IBAction)selectPrinter:(id)sender {
    UIPrinterPickerController *pickerController = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    [pickerController presentAnimated:YES completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
        if (userDidSelect) {
            self.printerUrl1 = printerPickerController.selectedPrinter.URL.absoluteString;
            self.printerName1 = printerPickerController.selectedPrinter.displayName;
        }
    }];
}

/// 通过记录的打印机打印
- (IBAction)print:(id)sender {
    [[UIPrinter printerWithURL:[NSURL URLWithString:self.printerUrl1]] contactPrinter:^(BOOL available) {
        if (available) {
            NSLog(@"AIRPRINTER AVAILABLE");
            // NSData 数组
            NSArray *items = @[self.taskData1, self.taskData2, self.taskData3];
            [self printDirectlyWithItems:items];
        } else {
            NSLog(@"AIRPRINTER NOT AVAILABLE");
        }
    }];
}

/// 直接链接打印机打印多个任务
- (void)printDirectlyWithItems:(NSArray *)items {
    // 打印信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"可直接打印的，不同类型的多个任务组"; // 一般以文件名称作为任务名称
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 打印预览控制器
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    pic.printInfo = printInfo;
    pic.printingItems = items; //// array of NSData, NSURL, UIImage, ALAsset. does not support page range
    
    // 直接链接打印机打印
    UIPrinter *airPrinter = [UIPrinter printerWithURL:[NSURL URLWithString:self.printerUrl1]];
    [[UIPrintInteractionController sharedPrintController] printToPrinter:airPrinter completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        
        if(completed && error)
            NSLog(@"Printing failed due to error in domain %@ with error code %lu. Localized description: %@, and failure reason: %@", error.domain, (long)error.code, error.localizedDescription, error.localizedFailureReason);
        
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
