//
//  AnimatedFakePlaceholder.h
//  JACompoents
//
//  Created by PSBC on 2019/4/19.
//  Copyright © 2019 Jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AnimatedFakePlaceholderType) {
    AnimatedFakePlaceholderType_DefaultType,    // 通用型 TextField
    AnimatedFakePlaceholderType_SecretType,     // 弹出加密键盘的 PSBCPasswordTextField
};


@interface AnimatedFakePlaceholder : UIView

@property (nonatomic, copy) NSString *placeholder;   ///<占位文本

+ (instancetype)inputViewWithType:(AnimatedFakePlaceholderType)type;

// 改变底部线条的颜色，默认(NO)是灰色，YES为红色
- (void)showErrorTip:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
