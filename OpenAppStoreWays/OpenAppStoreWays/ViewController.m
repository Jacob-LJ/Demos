//
//  ViewController.m
//  OpenAppStoreWays
//
//  Created by Jacob_Liang on 2017/9/7.
//  Copyright © 2017年 Jacob. All rights reserved.
//

#import "ViewController.h"
//lib
#import "SVProgressHUD.h"
//other
#import <StoreKit/StoreKit.h>

static NSString * const HLMAPPID = @"414478124";

@interface ViewController ()<SKStoreProductViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Private
- (IBAction)fistClick:(id)sender {
    //present 样式，应用内打开 Appstore
    [self openAppFromAppStore:HLMAPPID];
}

- (IBAction)secondClick:(id)sender {
    
    //push 样式的 App Store应用 打开下载界面 scheme > itms-apps://
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",HLMAPPID]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
}

- (IBAction)thirdClick:(id)sender {
    
    //push 样式的 App Store应用 打开下载界面 scheme > https://
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/in/app/id%@",HLMAPPID]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
}

#pragma mark - Download HLM in SKStoreProductViewController
- (void)openAppFromAppStore:(NSString *)appid {
    if (nil == appid || appid.length <= 0) {
        return;
    }
    
    //loading
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    //    // 改变导航栏的文字和图片颜色
    //    [[UINavigationBar appearance] setTintColor:[UIColor greenColor]];
    //    // 红色导航栏
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    //    [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[SKStoreProductViewController class]]];
    //
    
    SKStoreProductViewController *store = [[SKStoreProductViewController alloc] init];
    store.delegate = self;
    NSDictionary<NSString *, id> *parameters = @{SKStoreProductParameterITunesItemIdentifier: appid};
    
    [store loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error) {
        
        // finish loading
        [SVProgressHUD dismiss];
        
        if (error) {
            
            NSLog(@"error %@ with userInfo %@", error, [error userInfo]);
            
            // 提示用户发生了错误
            //或者通过 URL 打开 AppStore App.
            [self thirdClick:nil];
            
        } else {
            
            [self presentViewController:store animated:YES completion:NULL];
        }
    }];
}

/// 用户点击取消会执行该方法
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}

@end
