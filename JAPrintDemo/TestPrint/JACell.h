//
//  JACell.h
//  TestPrint
//
//  Created by Jacob_Liang on 2018/9/17.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JACell : UITableViewCell

@property (nonatomic, copy) void(^clickBlock)(void);

@end
