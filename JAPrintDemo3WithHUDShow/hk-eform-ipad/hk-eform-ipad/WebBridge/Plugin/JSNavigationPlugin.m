//
//  JSNavigationPlugin.m
//  messageCenterDemo
//
//  Created by dolway on 2018/8/28.
//  Copyright © 2018年 ISS. All rights reserved.
//

#import "JSNavigationPlugin.h"

@implementation JSNavigationPlugin

- (void)JSgoHome:(JSInvokedCommand *)command {
    if (self.viewController.navigationController.childViewControllers.count > 1) {
        [self.viewController.navigationController popViewControllerAnimated:YES];
    } else {
        [self.viewController dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
