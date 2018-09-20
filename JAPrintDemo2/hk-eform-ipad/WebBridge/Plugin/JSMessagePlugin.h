//
//  JSMessagePlugin.h
//  messageCenterDemo
//
//  Created by dolway on 2018/8/27.
//  Copyright © 2018年 ISS. All rights reserved.
//

#import "JSPlugIn.h"

@interface JSMessagePlugin : JSPlugIn

// 获取分类
- (void)JSgetCategories:(JSInvokedCommand *)command;
// 根据分类获取对应的消息
- (void)JSgetMessagesForCatalog:(JSInvokedCommand *)command;
// 通过消息ID查询消息
- (void)JSgetMessagesById:(JSInvokedCommand *)command;
// 删除消息
- (void)JSdeleteMessagesById:(JSInvokedCommand *)command;
// 标记消息为已读
- (void)JSmarkMessgeRaeded:(JSInvokedCommand *)command;

@end
