//
//  ViewController.m
//  ios10TabelView
//
//  Created by Jacob_Liang on 2017/9/21.
//  Copyright © 2017年 Jacob. All rights reserved.
//

#import "ViewController.h"

static NSString * const CELLID = @"CELLID";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSUInteger page;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpInit];
    [self setUpNav];
    [self setUpTableView];
    
}

- (void)setUpInit {
    self.automaticallyAdjustsScrollViewInsets = NO; //iOS 11下被废弃了
    self.view.backgroundColor = [UIColor purpleColor];
}

- (void)setUpNav {
    self.navigationItem.title = @"出席统计";
}

- (void)setUpTableView {
    
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenW, screenH - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    _tableView = tableView;
    tableView.backgroundColor = [UIColor lightGrayColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
    
    //关闭 iOS 11默认打开的 Self-Sizing 功能
//    tableView.estimatedRowHeight = 0;
//    tableView.estimatedSectionFooterHeight = 0;
//    tableView.estimatedSectionHeaderHeight = 0;

}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return nil;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}

@end
