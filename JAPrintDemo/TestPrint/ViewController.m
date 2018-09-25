//
//  ViewController.m
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/7.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "ViewController.h"

#import "JACell.h"
#import "JAPrintNormal.h"
#import "JAPrintBySelectController.h"
#import "JAPrintMutiTaskController.h"
#import "JADiffPrinterSyncAsyncPrintController.h"
#import "JAPrintWebController.h"
#import "JAPrintMSFileController.h"
#import "JAMutiFormattersController.h"
#import "JAPrintViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) JAPrintNormal *normalALAsset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JACell *cell = [tableView dequeueReusableCellWithIdentifier:@"JACell"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    NSString *title = @"NULL";
    
    __weak typeof(self) weakSelf = self;
    
    switch (indexPath.row) {
        case 0: {
            title = @"打印PDF - JAPrintNormal";
            cell.clickBlock = ^{
                JAPrintNormal *printNormal = [[JAPrintNormal alloc] init];
                [printNormal printPDF];
            };
            break;
        }
        case 1: {
            title = @"打印 jpg文件 转成的 NSData - JAPrintNormal";
            cell.clickBlock = ^{
                JAPrintNormal *printNormal = [[JAPrintNormal alloc] init];
                [printNormal printImageData];
            };
            break;
        }
        case 2: {
            title = @"打印 UIImage - JAPrintNormal";
            cell.clickBlock = ^{
                JAPrintNormal *printNormal = [[JAPrintNormal alloc] init];
                [printNormal printImage];
            };
            break;
        }
        case 3: {
            title = @"打印 NSURL (.pdf 的链接是可以的，但是 .docx 的链接不行) - JAPrintNormal";
            cell.clickBlock = ^{
                JAPrintNormal *printNormal = [[JAPrintNormal alloc] init];
                [printNormal printURL];
            };
            break;
        }
        case 4: {
            title = @"打印 Asset, 测试的是 PHAsset，但是不能预览，打印也不行 - JAPrintNormal";
            cell.clickBlock = ^{
                JAPrintNormal *printNormal = [[JAPrintNormal alloc] init];
                weakSelf.normalALAsset = printNormal;
                [printNormal printAsset];
            };
            break;
        }
        case 5: {
            title = @"选择并记录打印机，然后直接单个printItem - JAPrintBySelectController";
            cell.clickBlock = ^{
                JAPrintBySelectController *selectVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([JAPrintBySelectController class])];
                [weakSelf.navigationController pushViewController:selectVC animated:YES];
            };
            break;
        }
        case 6: {
            title = @"NSData数组的printItems 打印，通过预览控制器打印 或 直接打印 - JAPrintMutiTaskController";
            cell.clickBlock = ^{
                JAPrintMutiTaskController *mutiTaskVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([JAPrintMutiTaskController class])];
                [weakSelf.navigationController pushViewController:mutiTaskVC animated:YES];
            };
            break;
        }
        case 7: {
            title = @"同时连接两台打印机进行打印(不行)，只能一个一个 或 printItems 处理 - JADiffPrinterSyncAsyncPrintController";
            cell.clickBlock = ^{
                JADiffPrinterSyncAsyncPrintController *diffPrinterVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([JADiffPrinterSyncAsyncPrintController class])];
                [weakSelf.navigationController pushViewController:diffPrinterVC animated:YES];
            };
            break;
        }
        case 8: {
            title = @"简单打印网页内容 - JAPrintWebController";
            // 简单打印网页显示的内容 PS:系统会产生布局问题，需要将断点的 debug 功能 disable
            cell.clickBlock = ^{
                JAPrintWebController *webContentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([JAPrintWebController class])];
                [weakSelf.navigationController pushViewController:webContentVC animated:YES];
            };
            break;
        }
        case 9: {
            title = @"打印本地 doc(x)，ppt(x)的文件 - JAPrintMSFileController";
            cell.clickBlock = ^{
                JAPrintMSFileController *msFileVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([JAPrintMSFileController class])];
                [weakSelf.navigationController pushViewController:msFileVC animated:YES];
            };
            break;
        }
        case 10: {
            title = @"通过 UIPrintPageRenderer 整合打印多个 Formatters - JAMutiFormattersController";
            cell.clickBlock = ^{
                JAMutiFormattersController *formattersVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([JAMutiFormattersController class])];
                [weakSelf.navigationController pushViewController:formattersVC animated:YES];
            };
            break;
        }
        case 11: {
            title = @"打印 View (不能直接打印,转 image 或 pdf) - JAPrintViewController";
            cell.clickBlock = ^{
                JAPrintViewController *viewVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([JAPrintViewController class])];
                [weakSelf.navigationController pushViewController:viewVC animated:YES];
            };
            break;
        }
        case 12: {
            title = @"Normal - PDF";
            cell.clickBlock = ^{
                
            };
            break;
        }
        case 13: {
            title = @"Normal - PDF";
            cell.clickBlock = ^{
                
            };
            break;
        }
        case 14: {
            title = @"Normal - PDF";
            cell.clickBlock = ^{
                
            };
            break;
        }
            
        default:
            break;
    }
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s - %@", __func__ , indexPath);
    JACell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.clickBlock) {
        cell.clickBlock();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


@end

