//
//  CommentTestController.m
//  LanguageLocalizationDemo
//
//  Created by Jacob_Liang on 2018/9/6.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "CommentTestController.h"

@interface CommentTestController ()

@end

@implementation CommentTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 需要本地化显示的内容的 label
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(30, 70, 200, 50);
    [self.view addSubview:label];
    
    label.text = NSLocalizedString(@"", @"这是一个comment");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
