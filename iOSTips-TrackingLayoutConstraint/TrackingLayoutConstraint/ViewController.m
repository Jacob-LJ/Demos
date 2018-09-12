//
//  ViewController.m
//  TrackingLayoutConstraint
//
//  Created by Jacob_Liang on 2018/9/11.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stepper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    MASAttachKeys(self.testView, self.stepper);
//    self.testView.mas_key = self.testView;
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
    }];
    
//    self.stepper.mas_key = self.stepper;
    [self.stepper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
    }];
}


@end
