//
//  NSString+JANumeberFormatter.m
//  iOSTips-NSNumberFormatter
//
//  Created by Jacob_Liang on 2018/9/10.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "NSString+JANumeberFormatter.h"

@implementation NSString (JANumeberFormatter)


+ (NSString *)ja_FormatDecimalNumberStr:(NSString *)numStr {
    if (!numStr || numStr.length == 0) {
        return numStr;
    }
    
    NSNumber *number = @(numStr.doubleValue);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.positiveFormat = @"###,##0.00";
    
    NSString *amountString = [formatter stringFromNumber:number];
    return amountString;
}

@end
