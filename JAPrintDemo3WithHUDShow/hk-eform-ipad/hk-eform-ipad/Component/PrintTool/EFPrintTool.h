//
//  EFPrintTool.h
//  hk-eform-ipad
//
//  Created by Jacob_Liang on 2018/9/25.
//  Copyright © 2018年 Amway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFPrintTool : NSObject

/// 选择打印机
+ (void)selectPrinter;

/// 打印远程文件
- (void)printFiles:(NSArray<NSString *> *)fileUrls compeletion:(void(^)(BOOL completed))completionBlock;

@end
