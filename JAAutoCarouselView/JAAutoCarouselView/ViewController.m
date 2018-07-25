//
//  ViewController.m
//  JAAutoCarouselView
//
//  Created by Jacob on 2018/3/2.
//  Copyright © 2018年 Jacob_LJ. All rights reserved.
//

#import "ViewController.h"

#import "JAAutoCarouselView.h"
#import "AutoCarouselXibVC.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *temArrayM = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSString *imageName = [NSString stringWithFormat:@"bundleTest%d.jpg",i];
        [temArrayM addObject:imageName];
    }
    
    JAAutoCarouselView *autoCarouselView = [JAAutoCarouselView autoCarouselViewWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200) withLoacalImageNames:temArrayM];
    autoCarouselView.autoScrollTimeInterval = 5;
    autoCarouselView.infiniteLoop = NO;
    autoCarouselView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    autoCarouselView.autoScrollDirection = JAACVAutoScrollDirection_Vertical_Down;
    autoCarouselView.autoScroll = NO;
    
    
    self.dataArray = temArrayM;
    __weak typeof(self) weakSelf = self;
    autoCarouselView.itermClickBlock = ^(NSInteger clickIndex) {
        AutoCarouselXibVC *carouselXibVC = [[AutoCarouselXibVC alloc] init];
        carouselXibVC.carouselView.autoScrollTimeInterval = 5;
        carouselXibVC.carouselView.infiniteLoop = NO;
        carouselXibVC.carouselView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        carouselXibVC.carouselView.autoScrollDirection = JAACVAutoScrollDirection_Vertical_Down;
        carouselXibVC.carouselView.autoScroll = NO;
        carouselXibVC.carouselView.dataArray = weakSelf.dataArray;
        [weakSelf.navigationController pushViewController:carouselXibVC animated:YES];
    };
    
    [self.view addSubview:autoCarouselView];
}

@end
