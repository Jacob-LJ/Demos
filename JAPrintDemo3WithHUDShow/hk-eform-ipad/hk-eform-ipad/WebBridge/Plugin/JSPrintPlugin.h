//
//  JSPrintPlugin.h
//  hk-eform-ipad
//
//  Created by Jacob_Liang on 2018/9/19.
//  Copyright © 2018年 Amway. All rights reserved.
//

#import "JSPlugIn.h"

@interface JSPrintPlugin : JSPlugIn

/// 根据传入的 urls 打印远程 pdf 文件
- (void)JSPrintRemotePdfs:(JSInvokedCommand *)command;

@end
