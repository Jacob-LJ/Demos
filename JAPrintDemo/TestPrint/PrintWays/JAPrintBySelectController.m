//
//  JAPrintBySelectController.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/17.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "JAPrintBySelectController.h"

/// 记录选择过的打印机，后续直接打印
@interface JAPrintBySelectController ()<UIPrintInteractionControllerDelegate>

@property (nonatomic, copy) NSString *printerUrl1;
@property (nonatomic, copy) NSString *printerName1;

@property (nonatomic, strong) NSData *data;

@end

@implementation JAPrintBySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"VIP application form.pdf" ofType:nil];
    self.data = [NSData dataWithContentsOfFile:path];
}


- (IBAction)select:(id)sender {
    
    UIPrinterPickerController *pickerController = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    [pickerController presentAnimated:YES completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
        if (userDidSelect) {
            self.printerUrl1 = printerPickerController.selectedPrinter.URL.absoluteString;
            self.printerName1 = printerPickerController.selectedPrinter.displayName;
        }
    }];
}

- (IBAction)print:(id)sender {
    [[UIPrinter printerWithURL:[NSURL URLWithString:self.printerUrl1]] contactPrinter:^(BOOL available) {
        if (available) {
            NSLog(@"AIRPRINTER AVAILABLE");
            [self printOperationWithPrinterUrl:self.printerUrl1 taskName:@"任务1" taskData:self.data];
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
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    pic.printInfo = printInfo;
    pic.printingItem = taskData;
    
    UIPrinter *airPrinter = [UIPrinter printerWithURL:[NSURL URLWithString:printerUrl]];
    [pic printToPrinter:airPrinter completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        
        if(completed && error)
            NSLog(@"Printing failed due to error in domain %@ with error code %lu. Localized description: %@, and failure reason: %@", error.domain, (long)error.code, error.localizedDescription, error.localizedFailureReason);
        
    }];
}





@end

