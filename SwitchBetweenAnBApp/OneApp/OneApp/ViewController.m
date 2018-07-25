//
//  ViewController.m
//  OneApp
//
//  Created by Jacob_Liang on 2017/9/11.
//  Copyright © 2017年 Jacob. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (IBAction)jumpToTwoApp:(id)sender {
    
    NSString *urlscheme = @"twoapp://";
    [self checkIfInstalledAppWithUrlSchemes:urlscheme];
    
}

#pragma mark - 判断是否安装了APP 如安装则跳转到对应 App
- (void)checkIfInstalledAppWithUrlSchemes:(NSString *)urlScheme {
    
    NSURL *URL = [NSURL URLWithString:urlScheme];
    
    UIApplication *application = [UIApplication sharedApplication];
    /*
    // 方式一 ：
    
    // 判断是否安装了APP
     
     if ([application canOpenURL:URL]) {
     
         NSLog(@"已经安装，并且可以打开");
         if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
         
             // iOS10及以上判断方式
             [application openURL:URL options:@{} completionHandler:^(BOOL success) {
             
                 NSLog(@"iOS10及以上Open %@: 是否成功%d",urlScheme,success);
                 if (!success) {
                     // 没有成功
                     NSLog(@"iOS10 进入app失败");
                 }
             }];
     
         } else {
         
             BOOL success = [application openURL:URL];
             NSLog(@"Open %@: %d",urlScheme,success);
             if (!success) {
                 // 没有成功
                 NSLog(@"进入app失败");
             
             }
         
         }
     
     } else {
         NSLog(@"不能打开");
     
     }
    */
    
    // 方式二：
    
    // 直接进入，不成功就弹出提示即可, 建议使用这种方式
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        // iOS10及以上判断方式
        
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
               
               NSLog(@"iOS10及以上Open %@: 是否成功%d",urlScheme,success);
               
               if (!success) {
                   
                   // 没有成功
                   NSLog(@"iOS10 进入app失败");
                   
               }
               
        }];
        
    } else {
        
        BOOL success = [application openURL:URL];
        
        NSLog(@"Open %@: %d",urlScheme,success);
        if (!success) {
            // 没有成功
            NSLog(@"进入app失败");
            
        }
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
