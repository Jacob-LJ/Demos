//
//  ViewController.m
//  LanguageLocalizationDemo
//
//  Created by Jacob on 2018/9/4.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "ViewController.h"
#import "XibController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取当前项目指定的语言
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSLog(@"AppleLanguages 语言有 %@", languages);
    NSString *currentLanguage = languages.firstObject;
    NSLog(@"模拟器当前语言：%@",currentLanguage);

    
//    // 需要本地化显示的内容的 label
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(30, 70, 200, 50);
//    [self.view addSubview:label];
//
//    // 本地化内容
//    //    label.text = NSLocalizedString(@"lala", @"这是一个comment");
//    label.text = NSLocalizedStringFromTable(@"click", @"Module1", nil);
    
    
    self.imageV.image = [UIImage imageNamed:NSLocalizedString(@"langueIcon", nil)];
    
}

- (IBAction)jumpToXibVC:(id)sender {
    XibController *xibVC = [[XibController alloc] init];
    [self presentViewController:xibVC animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}


@end
