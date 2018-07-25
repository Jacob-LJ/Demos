//
//  JAAutoCarouselDefaultCCell.m
//  JAAutoCarousel
//
//  Created by Jacob on 2018/3/2.
//  Copyright © 2018年 Jacob_LJ. All rights reserved.
//

#import "JAAutoCarouselDefaultCCell.h"

@interface JAAutoCarouselDefaultCCell ()

@property (nonatomic, weak) UIView *containerV;

@end

@implementation JAAutoCarouselDefaultCCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *containerV = [[UIView alloc] init];
        containerV.clipsToBounds = YES;
        [self.contentView addSubview:containerV];
        _containerV = containerV;
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_containerV addSubview:imageV];
        _imageV = imageV;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _containerV.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end

