//
//  ViewController.m
//  LocalizationGenStringsDemo
//
//  Created by Jacob_Liang on 2018/9/6.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor lightGrayColor];
    label.frame = CGRectMake(50, 50, 100, 50);
    [self.view addSubview:label];
    
    label.text = NSLocalizedString(@"home", @"这个是用来在生成 strings 文件时，在对应的 key-value 行上的注释，用来提示翻译员或者猿们的相关提示");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
