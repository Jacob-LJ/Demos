//
//  JAPrintNormal.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/17.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "JAPrintNormal.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImagePickerController.h"

@interface JAPrintNormal ()<UIPrintInteractionControllerDelegate>

@property (nonatomic, strong) TZImagePickerController *imagePickerVc;

@end

@implementation JAPrintNormal

#pragma mark - 需要打印的 数据类型
/// 打印 PDF
- (void)printPDF {
    
    // 准备 pdf data 数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"VIP application form.pdf" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    // 处理打印信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"打印PDF"; // 一般以文件名称作为任务名称
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 打印数据
    [self printOperation:data printInfo:printInfo];
    
}

/// 打印 UIImage data
- (void)printImageData {
    // 准备 file中的 image data 数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"car.jpg" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    // 处理打印信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"打印ImageData"; // 一般以文件名称作为任务名称
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 打印数据
    [self printOperation:data printInfo:printInfo];
    
}

/// 打印 UIImage
- (void)printImage {
    // 准备 image
    UIImage *image = [UIImage imageNamed:@"iOSMutiThread"];
    
    // 处理打印信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"打印Image"; // 一般以文件名称作为任务名称
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 打印数据
    [self printOperation:image printInfo:printInfo]; // 图片大的话，渲染时间相对会久一点
}


/// 打印 NSURL
- (void)printURL {
    // 准备 NSURL
    NSURL *url = [NSURL URLWithString:@"http://storage.xuetangx.com/public_assets/xuetangx/PDF/PlayerAPI_v1.0.6.pdf"]; // 可能会存在布局问题，把Xcode断点debug disabled掉
    
    // docx在线文档可以浏览，但不知道为啥打印不行
//    NSURL *url = [NSURL URLWithString:@"http://www.xdocin.com/demo/demo.docx"];
    
    // 暂时，不知道为啥不行
//    NSString *urlstr = @"http://www.xdocin.com/xdoc?_func=to&_format=html&_cache=1&_source=true&_xdoc=http://www.xdocin.com/doc/CreateReport.docx";
//    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlstr];
    
    
    // 处理打印信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"打印URL"; // 一般以文件名称作为任务名称
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 打印数据
    [self printOperation:url printInfo:printInfo];
}

/// 打印 ALAsset
- (void)printAsset {
    [self getAsset];
}
- (void)printAsset:(ALAsset *)asset {
    
    // 处理打印信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"打印ALAsset"; // 一般以文件名称作为任务名称
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    
    // 打印数据
    [self printOperation:asset printInfo:printInfo]; // 图片大的话，渲染时间相对会久一点
}

#pragma mark - 打印操作
/// 打印操作
- (void)printOperation:(id)item printInfo:(UIPrintInfo *)printInfo {
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    BOOL canPrintItem = NO;
    // NSData
    if ([item isKindOfClass:[NSData class]]) {
        canPrintItem = [UIPrintInteractionController canPrintData:item];
    }
    // UIImage
    if ([item isKindOfClass:[UIImage class]]) {
        canPrintItem = YES;
    }
    // NSURL
    if ([item isKindOfClass:[NSURL class]]) {
        canPrintItem = [UIPrintInteractionController canPrintURL:item];
    }
    // ALAsset
    if ([item isKindOfClass:[ALAsset class]]) {
        canPrintItem = YES; // 没有实际测试
    }
    // PHAsset (iOS 9.0)
    if ([item isKindOfClass:[PHAsset class]]) {
        canPrintItem = YES; // 模拟器测试时，不能成功预览，打印无反应
    }
    
    
    
    if  (pic && canPrintItem) {
        pic.delegate = self;
        pic.printInfo = printInfo;
        pic.printingItem = item; // // single NSData, NSURL, UIImage, ALAsset
        
        //官方建议 iPhone 或 iPad 的弹出方式分开处理
        //        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //            [pic presentFromBarButtonItem:self.printButton animated:YES
        //                        completionHandler:completionHandler];
        //        } else {
        [pic presentAnimated:YES completionHandler:^(UIPrintInteractionController * _Nonnull printInteractionController, BOOL completed, NSError * _Nullable error) {
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %ld",
                      error.domain, error.code);
        }];
        //        }
    }
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


#pragma mark - TZImagePickerController

- (void)getAsset {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    self.imagePickerVc = imagePickerVc;
    
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakSelf printAsset:assets.firstObject];
    }];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav.topViewController presentViewController:imagePickerVc animated:YES completion:nil];
}


@end
