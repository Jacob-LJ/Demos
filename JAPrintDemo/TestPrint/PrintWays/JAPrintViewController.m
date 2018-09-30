//
//  JAPrintViewController.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/18.
//  Copyright © 2018年 Jacob. All rights reserved.
//


/// 测试打印 UIview，因为-viewPrintFormatter 是 UIView 的分类方法
#import "JAPrintViewController.h"

@interface JAPrintViewController ()

@end

@implementation JAPrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)printBtnClick:(id)sender {
    [self print];
}


- (void)print {
    // 打印信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"打印 view"; // 一般以文件名称作为任务名称
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 预览展示打印
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
//    pic.delegate = self;
    pic.printInfo = printInfo;
    
//    pic.printFormatter = [self formatterFromView]; // 无效使用
    
    // 将 view 转为 UIImage
//    pic.printingItem = [self imageFromView:self.view];
    
    // 将 view 转为 PDF
    pic.printingItem = [self createPDFfromUIView:self.view saveToDocumentsWithFileName:nil];
    
    //(TODO) 打印 scrollView 时候，转成 长PDF/长image 后如何分页打印？
    // 1、使用 webview 显示长的 PDF/image，再打印，因为打印 webview 内容时，会自动进行分页，或 pagerenderer 中设置
    // 2、高质量 view to pdf 参考：https://stackoverflow.com/a/35442187
    
    [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
        if (!completed && error)
            NSLog(@"FAILED! due to error in domain %@ with error code %ld",
                  error.domain, error.code);
    }];
}

#pragma mark - to viewPrintFormatter
- (UIPrintFormatter *)formatterFromView {
    // UIView 实例直接调用 viewPrintFormatter 无效
    UIPrintFormatter *formatter = [self.view viewPrintFormatter]; // 虽然 -viewPrintFormatter 是 UIView 的分类方法，但是只能用于 UITextView, MKMapView and UIWebView/WKWebView等实例对象上。UIPrintFormatter官方定义上有说明
    return formatter;
}

#pragma mark - to UIImage
- (UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, view.isOpaque, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

#pragma mark - to PDF
- (NSData *)createPDFfromUIView:(UIView *)aView saveToDocumentsWithFileName:(NSString *)aFilename {
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    
    
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    [aView.layer renderInContext:pdfContext];
    
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    if (!aFilename.length) {
        return pdfData;
    }
    
    // Retrieves the document directories from the iOS device
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    return pdfData;
}

@end
