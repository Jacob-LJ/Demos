//
//  JAMutiFormattersController.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/17.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "JAMutiFormattersController.h"
#import <WebKit/WebKit.h>
#import "JAPrintPageRenderer.h"

/// 通过 UIPrintPageRenderer 整合打印多个 Formatters - UIPrintInteractionController 的 printPageRenderer 中的 addPrintFormatter:startingAtPageAtIndex: 的使用
@interface JAMutiFormattersController ()<UIPrintInteractionControllerDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIViewPrintFormatter *webFormatter1;
@property (nonatomic, strong) UIViewPrintFormatter *webFormatter2;
@property (nonatomic, strong) UIViewPrintFormatter *webFormatter3;

@property (nonatomic, copy) NSString *printerUrl1;
@property (nonatomic, copy) NSString *printerName1;

@end

@implementation JAMutiFormattersController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareFormatters];
}

- (void)prepareFormatters {
    
    NSString *pathDoc = [[NSBundle mainBundle] pathForResource:@"test5.docx" ofType:nil];
    NSURL *docUrl = [NSURL fileURLWithPath:pathDoc];
    
    
    NSString *pathPPT = [[NSBundle mainBundle] pathForResource:@"testppt.pptx" ofType:nil];
    NSURL *pptUrl = [NSURL fileURLWithPath:pathPPT];
    
    
    WKWebView *webView = [[WKWebView alloc] init];
    webView.frame = self.view.frame;
    [webView loadRequest:[NSURLRequest requestWithURL:docUrl]];
    self.webFormatter1 = [webView viewPrintFormatter];
    
    
    WKWebView *webView1 = [[WKWebView alloc] init];
    webView1.frame = self.view.frame;
    [webView1 loadRequest:[NSURLRequest requestWithURL:pptUrl]];
    self.webFormatter2 = [webView1 viewPrintFormatter];
    
    
    WKWebView *webView2 = [[WKWebView alloc] init];
    webView2.frame = self.view.frame;
    [webView2 loadRequest:[NSURLRequest requestWithURL:docUrl]];
    self.webFormatter3 = [webView2 viewPrintFormatter];
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

/// 直接打印
- (IBAction)print:(id)sender {
    
    // 打印任务信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.jobName = @"直接打印多个 formatters";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 整合多个 formatters
    // 不恰当的起始打印页位置
//    UIPrintPageRenderer *renderer = [self improperStaringAtPage];
    
    // 通过自定义的renderer，自动调整各个 formatter 的起始打印页位置（直接打印，自定义 renderer 无效）
//    UIPrintPageRenderer *renderer = [self customerRenderer];
    
    // 手动自己计算页数
    UIPrintPageRenderer *renderer = [self selfCaculateStarPageRender];
    
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    pic.printInfo = printInfo;
    pic.printPageRenderer = renderer;
    
    // 直接打印
    UIPrinter *airPrinter = [UIPrinter printerWithURL:[NSURL URLWithString:self.printerUrl1]];
    [pic printToPrinter:airPrinter completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        
        if(completed && error)
            NSLog(@"Printing failed due to error in domain %@ with error code %lu. Localized description: %@, and failure reason: %@", error.domain, (long)error.code, error.localizedDescription, error.localizedFailureReason);
        
    }];
}


/// 预览方式打印
- (IBAction)printPreview:(id)sender {
    // 打印任务信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    printInfo.jobName = @"预览形式打印多个 formatters";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 整合多个 formatters
    // 不恰当的起始打印页位置
//    UIPrintPageRenderer *renderer = [self improperStaringAtPage];
    
    // 通过自定义的renderer，自动调整各个 formatter 的起始打印页位置
//    UIPrintPageRenderer *renderer = [self customerRenderer];
    
    // 手动自己计算页数
//    UIPrintPageRenderer *renderer = [self selfCaculateStarPageRender];
    
    //
    UIPrintPageRenderer *renderer = [self justAddInPrintFormattersArray];
    
    
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    pic.printInfo = printInfo;
    pic.printPageRenderer = renderer;
    
    // 预览展示打印
    [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        if (!completed && error)
            NSLog(@"FAILED! due to error in domain %@ with error code %ld",
                  error.domain, error.code);
    }];
}

/*
 下面的方式正常来说是可行的，startingAtPageAtIndex,要填入的参数是指，从第几页开始打印，
 正确做法是使用formatter 的 pageCount, 但不知道为啥获一直是0，查阅过内容，这个是应该是系统 bug
 */
- (UIPrintPageRenderer *)improperStaringAtPage {
    UIPrintPageRenderer *renderer = [[UIPrintPageRenderer alloc] init];
    [renderer addPrintFormatter:self.webFormatter1 startingAtPageAtIndex:0];
    [renderer addPrintFormatter:self.webFormatter2 startingAtPageAtIndex:self.webFormatter1.pageCount]; // self.webFormatter1.pageCount = 0
    [renderer addPrintFormatter:self.webFormatter3 startingAtPageAtIndex:self.webFormatter2.pageCount]; // self.webFormatter2.pageCount = 0
    return renderer;
}

// 重写了 renderer 的 numberpages 属性，预览模式打印可以自动调整 formatter 的 starPage。但是直接打印不行
- (UIPrintPageRenderer *)customerRenderer {
    JAPrintPageRenderer *renderer = [[JAPrintPageRenderer alloc] init];
    [renderer addPrintFormatter:self.webFormatter1 startingAtPageAtIndex:0];
    [renderer addPrintFormatter:self.webFormatter2 startingAtPageAtIndex:1]; // 后面会自动调整正确的打印位置
    [renderer addPrintFormatter:self.webFormatter3 startingAtPageAtIndex:2];
    return renderer;
}

// 如果你有其他办法，能够正确获取每一个 formatter 的页数的话，是可以自己进行计算处理的
- (UIPrintPageRenderer *)selfCaculateStarPageRender {
    // 暂时没有好方法，除非你知道formatter 的页数，下面是假设我知道的页数
    UIPrintPageRenderer *renderer = [[UIPrintPageRenderer alloc] init];
    [renderer addPrintFormatter:self.webFormatter1 startingAtPageAtIndex:0]; // 2页
    [renderer addPrintFormatter:self.webFormatter2 startingAtPageAtIndex:2]; // 1页
    [renderer addPrintFormatter:self.webFormatter3 startingAtPageAtIndex:3]; // 2页
    return renderer;
}

/// 直接使用 UIPrintPageRenderer 中的 printFormatters 属性 （同样存在startingAtPageAtIndex方法的问题）
- (UIPrintPageRenderer *)justAddInPrintFormattersArray {
    UIPrintPageRenderer *renderer = [[UIPrintPageRenderer alloc] init];
    // 不指定的话会有问题
    self.webFormatter1.startPage = 0;
    self.webFormatter2.startPage = 2;
    self.webFormatter3.startPage = 3;
    renderer.printFormatters = @[self.webFormatter1, self.webFormatter2, self.webFormatter3];
    return renderer;
}

@end
