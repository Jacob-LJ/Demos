//
//  JAAutoCarouselView.h
//  JAAutoCarouselView
//
//  Created by Jacob on 2018/3/2.
//  Copyright © 2018年 Jacob_LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 滚动方向 */
typedef NS_ENUM(NSUInteger, JAACVAutoScrollDirection) {
    JAACVAutoScrollDirection_Horizontal_Left,
    JAACVAutoScrollDirection_Horizontal_Right, /**< scrollDirection 为 UICollectionViewScrollDirectionHorizontal 默认值 */
    JAACVAutoScrollDirection_Vertical_Up, /**< scrollDirection 为 UICollectionViewScrollDirectionVertical 垂直时默认值 */
    JAACVAutoScrollDirection_Vertical_Down,
};

@interface JAAutoCarouselView : UIView


#pragma mark - 创建方式
/**
 创建本地图片轮播器
 
 @param imageNames 其中的字符串可以是 assets 中的图片名称 或 bundle 中的图片全称(需含文件后缀)、或文件所在bundle全地址
 */
+ (instancetype)autoCarouselViewWithFrame:(CGRect)frame withLoacalImageNames:(NSArray <NSString *>*)imageNames;

#pragma mark - 配置属性
/** 当前滚动所在位置索引 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/** 自动滚动间隔时间, 默认 2s; 最少值为 0.5s*/
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

/** 无限循环,默认YES ,当为NO时，autoScroll = NO */
@property (nonatomic, assign) BOOL infiniteLoop;

/** 自动滚动, 默认 YES ，此时infiniteLoop 为 YES */
@property (nonatomic, assign) BOOL autoScroll;

/** 图片滚动方向，默认为水平滚动 UICollectionViewScrollDirectionHorizontal */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/**
 自动滚动方向
 
 当 scrollDirection 为 UICollectionViewScrollDirectionHorizontal 则 autoScrollDirection 默认值是 JAACVAutoScrollDirection_Horizontal_Right;
 当 scrollDirection 为 UICollectionViewScrollDirectionVertical 则 autoScrollDirection 默认值是 JAACVAutoScrollDirection_Vertical_Up
 当 scrollDirection 与 autoScrollDirection 设置的值有冲突时，会自动修正为按 scrollDirection 方向的默认值，详情参考方法 -fixAutoScrollDirectionByScrollDirection
 */
@property (nonatomic, assign) JAACVAutoScrollDirection autoScrollDirection;

#pragma mark - 数据源
@property (nonatomic, strong) NSArray<NSString *> *dataArray;

#pragma mark - 动作事件
@property (nonatomic, copy) void(^itermClickBlock)(NSInteger clickIndex);


@end
