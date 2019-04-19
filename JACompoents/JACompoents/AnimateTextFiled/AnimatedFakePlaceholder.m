//
//  AnimatedFakePlaceholder.m
//  JACompoents
//
//  Created by PSBC on 2019/4/19.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import "AnimatedFakePlaceholder.h"
#import <Masonry.h>
#import "UIControl+HitEdgeInsets.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kOnePixelHeight (1.0 / [UIScreen mainScreen].scale)

#define UserMainBlueColor UIColorFromRGB(0x488ff0)

@interface AnimatedFakePlaceholder ()

@property (nonatomic, assign) AnimatedFakePlaceholderType inputType;
@property (nonatomic, weak) UILabel *placeholderLB;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIView *btmLine;
@property (nonatomic, weak) UIView *animatedLine;

@property (nonatomic, assign) BOOL placeholderInTop;

@end

@implementation AnimatedFakePlaceholder

+ (instancetype)inputViewWithType:(AnimatedFakePlaceholderType)type {
    AnimatedFakePlaceholder *inputV = [[AnimatedFakePlaceholder alloc] initWithFrame:CGRectZero inputType:type];
    return inputV;
}

- (instancetype)initWithFrame:(CGRect)frame inputType:(AnimatedFakePlaceholderType)type {
    if (self = [self initWithFrame:frame]) {
        _inputType = type;
        [self setUpSubViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing) name:UITextFieldTextDidBeginEditingNotification object:self.textField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing) name:UITextFieldTextDidEndEditingNotification object:self.textField];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpSubViews {
    // 输入框
    UITextField *tf = [self getTextFieldByInputType];
    tf.textColor = UIColorFromRGB(0x333333);
    tf.font = [UIFont systemFontOfSize:15];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.hitInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
    [self addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.mas_equalTo(-5);
    }];
    self.textField = tf;
    
    // 占位文本
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont systemFontOfSize:15];
    lb.textColor = UIColorFromRGB(0xbfbfbf);
    lb.text = @"";
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.width.equalTo(self.textField);
    }];
    self.placeholderLB = lb;
    
    // 底部灰色线
    UIView *btmLine = [[UIView alloc] init];
    btmLine.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [self addSubview:btmLine];
    [btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.mas_equalTo(kOnePixelHeight);
    }];
    self.btmLine = btmLine;
    
    // 动画蓝色线
    UIView *animatedLine = [[UIView alloc] init];
    animatedLine.backgroundColor = UserMainBlueColor;
    [self.btmLine addSubview:animatedLine];
    self.animatedLine = animatedLine;
}

- (UITextField *)getTextFieldByInputType {
    if (self.inputType == AnimatedFakePlaceholderType_SecretType) {
        return [[UITextField alloc] init];
    } else {
        return [[UITextField alloc] init];
    }
}

#pragma mark - TextField action
- (void)textDidBeginEditing {
    
    [self animatePlaceholderUpward:YES animated:YES];
    
    self.animatedLine.frame = CGRectMake(0, 0, 0, self.btmLine.frame.size.height);
    [UIView animateWithDuration:1 animations:^{
        self.animatedLine.frame = self.btmLine.bounds;
    }];
    
    [self showErrorTip:NO];
}

- (void)textDidEndEditing {
    BOOL hasText = self.textField.hasText;
    if (!hasText) {
        [self animatePlaceholderUpward:NO animated:YES];
    }
    [UIView animateWithDuration:1 animations:^{
        self.animatedLine.frame = CGRectMake(0, 0, 0, self.btmLine.bounds.size.height);
    }];
}

- (void)animatePlaceholderUpward:(BOOL)upward animated:(BOOL)animated {
    NSTimeInterval interval = animated ? 1 : 0;
    if (upward && !self.placeholderInTop) { // 上移
        self.placeholderLB.layer.position = self.placeholderLB.frame.origin;
        self.placeholderLB.layer.anchorPoint = CGPointMake(0, 0);
        self.placeholderInTop = YES;
        [UIView animateWithDuration:interval animations:^{
            CGAffineTransform tf = CGAffineTransformMakeScale(0.8, 0.8);
            tf = CGAffineTransformTranslate(tf, 0, -25);
            self.placeholderLB.transform = tf;
        }];
    } else if (!upward && self.placeholderInTop) { // 下移
        self.placeholderInTop = NO;
        [UIView animateWithDuration:interval animations:^{
            self.placeholderLB.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - public

// 改变底部线条的颜色，默认(NO)是灰色，YES为红色
- (void)showErrorTip:(BOOL)show {
    self.btmLine.backgroundColor = show ? UIColorFromRGB(0xfb5b49) : UIColorFromRGB(0xe5e5e5);
}

#pragma mark - getter & setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLB.text = _placeholder;
}

@end
