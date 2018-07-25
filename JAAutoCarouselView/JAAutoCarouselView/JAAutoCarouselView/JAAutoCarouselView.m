//
//  JAAutoCarouselView.m
//  JAAutoCarouselView
//
//  Created by Jacob on 2018/3/2.
//  Copyright © 2018年 Jacob_LJ. All rights reserved.
//

#import "JAAutoCarouselView.h"

//View
#import "JAAutoCarouselDefaultCCell.h"

static const int kMaxItemNum = 3;
static const int kCenterIndex = kMaxItemNum * 0.5;

@interface JAAutoCarouselView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    JAAutoCarouselDefaultCCell *_firstCell;
    JAAutoCarouselDefaultCCell *_secondCell;
}

@property (nonatomic, weak) UICollectionView *colletionV;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) NSInteger currentIndex;   //内部添加getter和setter

@end

@implementation JAAutoCarouselView

+ (instancetype)autoCarouselViewWithFrame:(CGRect)frame withLoacalImageNames:(NSArray <NSString *>*)imageNames {
    JAAutoCarouselView *autoCarouselView = [[self alloc] initWithFrame:frame];
    autoCarouselView.dataArray = imageNames;
    return autoCarouselView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpInit];
        [self setUpCollecitonV];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setUpInit];
    [self setUpCollecitonV];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_infiniteLoop) {
        //默认滚动到中间位置
        [_colletionV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:kCenterIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
//    _flowLayout.itemSize = self.bounds.size;
//    _colletionV.frame = self.bounds;
//    NSLog(@"%@",NSStringFromCGRect(self.bounds));
}

//- (void)dealloc {
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    //最后在dealloc中移除通知 和结束设备旋转的通知
//    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
//}

- (void)setUpInit {
    
    //设置默认值
    _autoScrollTimeInterval = 2;
    _infiniteLoop = YES;
    _autoScroll = YES;
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _autoScrollDirection = JAACVAutoScrollDirection_Horizontal_Right;
    
    
//    //开启和监听 设备旋转的通知（不开启的话，设备方向一直是UIInterfaceOrientationUnknown）
//    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
//        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    }
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(handleDeviceOrientationChange:)
//                                                name:UIDeviceOrientationDidChangeNotification
//                                              object:nil];
//
}

- (void)handleDeviceOrientationChange:(NSNotification *)noti {
    [self layoutSubviews];
}

- (void)setUpCollecitonV {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = self.bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *colletionV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    colletionV.delegate = self;
    colletionV.dataSource = self;
    colletionV.scrollsToTop = NO;
    colletionV.bounces = NO; //防止快速滑动时候出现到尽头情况
    colletionV.pagingEnabled = YES;
    colletionV.backgroundColor = [UIColor darkGrayColor];
    colletionV.showsHorizontalScrollIndicator = NO;
    colletionV.showsVerticalScrollIndicator = NO;
    [colletionV registerClass:[JAAutoCarouselDefaultCCell class] forCellWithReuseIdentifier:JAAutoCarouselDefaultCCellID];
    [self addSubview:colletionV];
    _colletionV = colletionV;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_infiniteLoop) {
        return kMaxItemNum;
    } else {
        return self.dataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JAAutoCarouselDefaultCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JAAutoCarouselDefaultCCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 256.0 green:arc4random() % 256 / 256.0 blue:arc4random() % 256 / 256.0 alpha:1];
    NSString *imageName = nil;
    
    if (_infiniteLoop) {
        switch (indexPath.row) {
            case 0: {
                imageName = self.currentIndex == 0 ? self.dataArray.lastObject : self.dataArray[self.currentIndex - 1];
                break;
            }
            case 1: {
                imageName = self.dataArray[self.currentIndex];
                break;
            }
            case 2: {
                imageName = self.currentIndex == (self.dataArray.count - 1) ? self.dataArray.firstObject : self.dataArray[self.currentIndex + 1];
                break;
            }
        }
    } else {
        imageName = self.dataArray[indexPath.row];
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image) image = [UIImage imageWithContentsOfFile:imageName];
    if (!image) NSLog(@"此本地字段获取不了图片 - %@",imageName);
    cell.imageV.image = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击当前索引 - %ld +++ ItemIndexPath - %@", self.currentIndex, indexPath);
    if (self.itermClickBlock) {
        self.itermClickBlock(self.currentIndex);
    }
}




#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_autoScroll) {
        //滚动视差效果, 暂时支持手动滚动，自动无限还有bug, 还是竖直方向没处理， 无限循环也是
        [self scrollOffsetParallax];
    }

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //autoScroll滚动停止时调用
    [self scrollViewDidEndScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&  !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll];
        }
    }
}

- (void)scrollViewDidEndScroll {
    
    NSLog(@"停止");//停止类型 》 1、快速滚动，自然停止；2、快速滚动，手指按压突然停止；3、慢速上下滑动停止。
    
    //根据滚动方向计算currentIndex
    [self caculateCurrentIndexByScrollDirection];
    NSLog(@"当前Index = %ld", self.currentIndex);
    
    if (_infiniteLoop) {
        [_colletionV reloadData];
        //回归中间位置
        [_colletionV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:kCenterIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        [self reSetTimmerIfNeed];
    }
    
    if (!_autoScroll) {
        //滚动视差效果后, 回复原位
        [self resetCellImageViewFrame];
    }
    
}

//滚动视差效果
- (void)scrollOffsetParallax {
    
    CGFloat scrollVW = _colletionV.frame.size.width;
    CGFloat x = _colletionV.contentOffset.x;
    NSInteger index = x / scrollVW;
    //    NSLog(@"%lf", x);
    
    _firstCell = (JAAutoCarouselDefaultCCell *)[_colletionV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    _secondCell = (JAAutoCarouselDefaultCCell *)[_colletionV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index+1 inSection:0]];
    if (!_secondCell || !_firstCell) return;
    
    CGFloat firstImageW = _firstCell.imageV.frame.size.width;
    CGFloat firstImageH = _firstCell.imageV.frame.size.height;
    CGFloat secondImageW = _secondCell.imageV.frame.size.width;
    CGFloat secondImageH = _secondCell.imageV.frame.size.height;
    
    
    //    NSLog(@"1 - %@", [self.colletionV indexPathForCell:self.firstCell]);
    //    NSLog(@"2 - %@", [self.colletionV indexPathForCell:self.secondCell]);
    
    CGFloat animationOffset = 100;
    // 图片的起始位置,相对于父控件
    CGFloat imageOriginX = -scrollVW;
    // 每张图片滚动行程
    CGFloat pageOffsetX = x - index * scrollVW;
    
    CGFloat secondImageX = (imageOriginX + animationOffset) + pageOffsetX / scrollVW * (scrollVW - animationOffset); //需要理解一下
    CGFloat fistImageX = pageOffsetX * animationOffset / scrollVW;
    
    _firstCell.imageV.frame = CGRectMake(fistImageX, 0, firstImageW, firstImageH);
    _secondCell.imageV.frame = CGRectMake(secondImageX, 0, secondImageW, secondImageH);
}

//滚动视差效果后, 回复原位
- (void)resetCellImageViewFrame {
    
    CGFloat firstImageW = _firstCell.imageV.frame.size.width;
    CGFloat firstImageH = _firstCell.imageV.frame.size.height;
    CGFloat secondImageW = _secondCell.imageV.frame.size.width;
    CGFloat secondImageH = _secondCell.imageV.frame.size.height;
    
    _firstCell.imageV.frame = CGRectMake(0, 0, firstImageW, firstImageH);
    _secondCell.imageV.frame = CGRectMake(-secondImageW, 0, secondImageW, secondImageH);
    
    _firstCell = nil;
    _secondCell = nil;
}

#pragma mark - Timer

- (void)setupTimer {
    
    [self invalidateTimer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollTimeInterval target:self selector:@selector(timerAciton) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

- (void)reSetTimmerIfNeed {
    [self setAutoScroll:self.autoScroll];
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerAciton {
    
    NSInteger nextIndex = kCenterIndex;
    
    switch (_autoScrollDirection) {
        case JAACVAutoScrollDirection_Horizontal_Right:
        case JAACVAutoScrollDirection_Vertical_Down: {
            nextIndex = kCenterIndex - 1;
            break;
        }
        case JAACVAutoScrollDirection_Horizontal_Left:
        case JAACVAutoScrollDirection_Vertical_Up: {
            nextIndex = kCenterIndex + 1;
            break;
        }
    }
    
    [_colletionV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - private
// 根据 ScrollDirection 计算当前索引index
- (void)caculateCurrentIndexByScrollDirection {
    
    switch (_autoScrollDirection) {
        case JAACVAutoScrollDirection_Horizontal_Left:
        case JAACVAutoScrollDirection_Horizontal_Right: {
            
            if (_infiniteLoop) {
                if (_colletionV.contentOffset.x >= self.frame.size.width * 2) {
                    //左滑，currentIndex增加
                    
                    if (self.currentIndex == self.dataArray.count - 1) {
                        self.currentIndex = 0;
                    } else {
                        self.currentIndex++;
                    }
                    
                } else if (_colletionV.contentOffset.x <= 0) {
                    //右滑，currentIndex减少
                    if (self.currentIndex == 0) {
                        self.currentIndex = self.dataArray.count - 1;
                    } else {
                        self.currentIndex--;
                    }
                }
                
            } else {
                self.currentIndex = _colletionV.contentOffset.x / self.frame.size.width;
            }
            
            break;
        }
            
        case JAACVAutoScrollDirection_Vertical_Up:
        case JAACVAutoScrollDirection_Vertical_Down: {
            
            if (_infiniteLoop) {
                if (_colletionV.contentOffset.y >= self.frame.size.height * 2) {
                    //上滑，currentIndex增加
                    if (self.currentIndex == self.dataArray.count - 1) {
                        self.currentIndex = 0;
                    } else {
                        self.currentIndex++;
                    }
                } else if (_colletionV.contentOffset.y <= 0) {
                    //下滑，currentIndex减少
                    if (self.currentIndex == 0) {
                        self.currentIndex = self.dataArray.count - 1;
                    } else {
                        self.currentIndex--;
                    }
                }
                
            } else {
                self.currentIndex = _colletionV.contentOffset.y / self.frame.size.height;
            }
            
            break;
        }
    }
    
}

// 根据 ScrollDirection 修正 AutoScrollDirection
- (void)fixAutoScrollDirectionByScrollDirection {
    
    switch (_scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal: {
            BOOL isHorizontal = _autoScrollDirection == JAACVAutoScrollDirection_Horizontal_Left || _autoScrollDirection == JAACVAutoScrollDirection_Horizontal_Right;
            if (!isHorizontal) {
                self.autoScrollDirection = JAACVAutoScrollDirection_Horizontal_Left;
            }
            break;
        }
        case UICollectionViewScrollDirectionVertical: {
            BOOL isVertical = _autoScrollDirection == JAACVAutoScrollDirection_Vertical_Up || _autoScrollDirection == JAACVAutoScrollDirection_Vertical_Down;
            if (!isVertical) {
                self.autoScrollDirection = JAACVAutoScrollDirection_Vertical_Up;
            }
            break;
        }
    }
}

#pragma mark - getter & setter
- (void)setDataArray:(NSArray<NSString *> *)dataArray {
    _dataArray = dataArray;
    
    [self reSetTimmerIfNeed];
    [_colletionV reloadData];
}

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval {
    
    if (autoScrollTimeInterval < 0.5) {
        autoScrollTimeInterval = 0.5;
    }
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self reSetTimmerIfNeed];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    
    if (_infiniteLoop) {
        _colletionV.bounces = NO;
    } else {
        _colletionV.bounces = YES;
        self.autoScroll = NO;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    if (_autoScroll) {
        if (_infiniteLoop) {
            _infiniteLoop = YES;
            [self setupTimer];
        } else {
            _autoScroll = NO;
            [self invalidateTimer];
        }
    } else {
        [self invalidateTimer];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    
    _flowLayout.scrollDirection = _scrollDirection;
    [self fixAutoScrollDirectionByScrollDirection];
    [self reSetTimmerIfNeed];
}

- (void)setAutoScrollDirection:(JAACVAutoScrollDirection)autoScrollDirection {
    _autoScrollDirection = autoScrollDirection;
    
    [self fixAutoScrollDirectionByScrollDirection];
    [self reSetTimmerIfNeed];
}


@end
