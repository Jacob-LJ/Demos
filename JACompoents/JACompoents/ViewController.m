//
//  ViewController.m
//  JACompoents
//
//  Created by PSBC on 2019/4/19.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedFakePlaceholder.h"
#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AnimatedFakePlaceholder *inputV = [AnimatedFakePlaceholder inputViewWithType:AnimatedFakePlaceholderType_DefaultType];
    inputV.placeholder = @"手机号/身份证";
    [self.view addSubview:inputV];
    
    [inputV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(54);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
