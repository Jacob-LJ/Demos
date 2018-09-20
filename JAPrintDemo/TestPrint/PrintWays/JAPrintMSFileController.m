//
//  JAPrintMSFileController.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/17.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "JAPrintMSFileController.h"
#import <WebKit/WebKit.h>

/// 打印本地 doc(x)，ppt(x)的文件  - UIPrintInteractionController 的 printFormatter 的使用
@interface JAPrintMSFileController ()<UIPrintInteractionControllerDelegate>

@property (nonatomic, copy) NSString *printerUrl1;
@property (nonatomic, copy) NSString *printerName1;

@property (weak, nonatomic) WKWebView *webView;

@end

@implementation JAPrintMSFileController

/*
 将本地的 msfile 转成 data 形式打印时不可以的
 借助 webview 格式化显示，获得 formatter 形式，进行打印（此时与打印网页内容基本一致）
 */

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
    
    // docx
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test5.docx" ofType:nil];
    // pptx
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testppt.pptx" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    
    WKWebView *webView = [[WKWebView alloc] init];
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



@end
