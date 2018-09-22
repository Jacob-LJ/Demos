//
//  JAPrintWebController.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/17.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "JAPrintWebController.h"
#import <WebKit/WebKit.h>

/// 简单打印网页显示的内容 注意页面的横竖 - UIPrintInteractionController 的 printFormatter 的使用
@interface JAPrintWebController ()<UIPrintInteractionControllerDelegate>

@property (nonatomic, copy) NSString *printerUrl1;
@property (nonatomic, copy) NSString *printerName1;

@property (weak, nonatomic) WKWebView *webView;

@end

@implementation JAPrintWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    [self setUpWebView];
}

- (void)setUpNav {
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"预览打印" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick1)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"选记打印机" style:UIBarButtonItemStylePlain target:self action:@selector(select)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"直接打印" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick2)];
    self.navigationItem.rightBarButtonItems = @[item3, item2, item1];
}

- (void)setUpWebView {
    WKWebView *webView = [[WKWebView alloc] init];
    NSURL *url = [NSURL URLWithString:@"https://www.apple.com/"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    webView.frame = self.view.frame;
    [self.view addSubview:webView]; // webview 可以不用展示,但是一定有 frame, 也是可以获取到它的内容进行打印的
    self.webView = webView;
}

- (void)rightItemClick1 {
    // 打印任务信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"打印webVeiw内容"; // 一般以文件名称作为任务名称
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 格式化 view 内容打印
    UIViewPrintFormatter *viewFormatter = [self.webView viewPrintFormatter];
    // 还有一种思路，使用 printPageRenderer 包装 webview 的 printFormatter，然后 将printPageRenderer转为 PDF data，参考：https://stackoverflow.com/a/26276745
    
    // 预览展示打印
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    pic.printInfo = printInfo;
    pic.printFormatter = viewFormatter;
    
    [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        if (!completed && error)
            NSLog(@"FAILED! due to error in domain %@ with error code %ld",
                  error.domain, error.code);
    }];
}

#pragma mark - 通过记录的打印机直接打印
- (void)select {
    UIPrinterPickerController *pickerController = [UIPrinterPickerController printerPickerControllerWithInitiallySelectedPrinter:nil];
    [pickerController presentAnimated:YES completionHandler:^(UIPrinterPickerController * _Nonnull printerPickerController, BOOL userDidSelect, NSError * _Nullable error) {
        if (userDidSelect) {
            self.printerUrl1 = printerPickerController.selectedPrinter.URL.absoluteString;
            self.printerName1 = printerPickerController.selectedPrinter.displayName;
        }
    }];
}

- (void)rightItemClick2 {
    
    [[UIPrinter printerWithURL:[NSURL URLWithString:self.printerUrl1]] contactPrinter:^(BOOL available) {
        if (available) {
            NSLog(@"AIRPRINTER AVAILABLE");
            [self print];
        } else {
            NSLog(@"AIRPRINTER NOT AVAILABLE");
        }
    }];
    
}

- (void)print {
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.jobName = @"打印网页内容";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 格式化 view 内容打印
    UIViewPrintFormatter *viewFormatter = [self.webView viewPrintFormatter];
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    pic.printInfo = printInfo;
    pic.printFormatter = viewFormatter;
    
    UIPrinter *airPrinter = [UIPrinter printerWithURL:[NSURL URLWithString:self.printerUrl1]];
    [pic printToPrinter:airPrinter completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        
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
