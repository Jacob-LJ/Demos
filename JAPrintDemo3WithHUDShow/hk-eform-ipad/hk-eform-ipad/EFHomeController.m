//
//  EFHomeController.m
//  hk-eform-ipad
//
//  Created by Jacob_Liang on 2018/9/18.
//  Copyright © 2018年 Amway. All rights reserved.
//

#import "EFHomeController.h"
#import "EFPrintTool.h"

@interface EFHomeController ()

@end

@implementation EFHomeController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"indexh5.html" ofType:nil];
        self.startPage = path;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
}

- (void)setUpNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择打印机" style:UIBarButtonItemStylePlain target:self action:@selector(selectPrinter)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.WKWebView.frame = self.view.frame;
}

- (void)selectPrinter {
    [EFPrintTool selectPrinter];
}


@end
