//
//  JAPrintNormal.h
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/17.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JAPrintNormal : NSObject

// 打印 PDF 信息
- (void)printPDF;

/// 打印 UIImage data
- (void)printImageData;

/// 打印 UIImage
- (void)printImage;

/// 打印 NSURL
- (void)printURL;

/// 打印 Asset
- (void)printAsset;

@end
