//
//  ViewController.m
//  iOSTips-NSNumberFormatter
//
//  Created by Jacob_Liang on 2018/9/10.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "ViewController.h"
#import "NSString+JANumeberFormatter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSLog(@"%@",[self ja_FormatDecimalNumberStr:@"00123"]);
//    NSLog(@"%@",[self ja_FormatDecimalNumberStr:@"12345"]);
//    NSLog(@"%@",[self ja_FormatDecimalNumberStr:@"1,234.00"]);
//    NSLog(@"%@",[self ja_FormatDecimalNumberStr:@"123456789123456789123456789123456789123456789"]);
    
    [self numberLog];
    [self localizedStringFromNumber_numberStyle_NoStyle];
    [self localizedStringFromNumber_numberStyle_DecimalStyle];
    [self localizedStringFromNumber_numberStyle_CurrencyStyle];
    [self localizedStringFromNumber_numberStyle_PercentStyle];
    [self localizedStringFromNumber_numberStyle_ScientificStyle];
    [self localizedStringFromNumber_numberStyle_SpellOutStyle];
    [self localizedStringFromNumber_numberStyle_OrdinalStyle];
    [self localizedStringFromNumber_numberStyle_CurrencyISOCodeStyle];
    [self localizedStringFromNumber_numberStyle_CurrencyPluralStyle];
    [self localizedStringFromNumber_numberStyle_CurrencyAccountingStyle];
}

- (void)numberLog {
    // number对象打印时
    NSNumber *Num1 = @(0.123456789123456789); // 1. 最大小数位数为16位
    NSNumber *Num2 = @(00.123456789123456789); // 2. 当整数部分每多一位，小数部分精度减少一位
    NSNumber *Num3 = @(1.123456789123456789);
    NSNumber *Num4 = @(12.123456789123456789);
    NSNumber *Num5 = @(1234.123456789123456789);
    NSNumber *Num6 = @(123456789.123456789123456789);
    NSNumber *Num7 = @(123456789123.123456789123456789);
    NSNumber *Num8 = @(123456789123456.123456789123456789);
    NSNumber *Num9 = @(123456789123456789.123456789123456789); // 3. 最后会以科学计数方式输出
    
    NSArray *numArray = @[Num1, Num2, Num3, Num4, Num5, Num6, Num7, Num8, Num9];
    [numArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        idx +=  1;
        NSLog(@"%zd Num - %@,",idx, obj);
        NSLog(@"%zd stringValue - %@",idx, [obj stringValue]);
        NSLog(@"%zd doubleValue - %lf",idx, [obj doubleValue]);
    }];
}


- (void)localizedStringFromNumber_numberStyle_NoStyle {
    
    // 四舍五入到整数
    NSNumber *NoStyleNum1 = @(123456.456);
    NSNumber *NoStyleNum2 = @(123456.500);
    NSNumber *NoStyleNum3 = @(123456.500000001);
    NSNumber *NoStyleNum4 = @(123456.6);
    
    NSArray *NoStyleArray = @[NoStyleNum1, NoStyleNum2, NoStyleNum3, NoStyleNum4];
    [NoStyleArray enumerateObjectsUsingBlock:^(NSNumber *NoStyleNum, NSUInteger idx, BOOL * _Nonnull stop) {
        idx +=  1;
        NSString *NoStyleNumStr = [NSNumberFormatter localizedStringFromNumber:NoStyleNum numberStyle:NSNumberFormatterNoStyle];
        NSLog(@"%zd NoStyle：%@ -> %@",idx ,NoStyleNum, NoStyleNumStr);
    }];

}

- (void)localizedStringFromNumber_numberStyle_DecimalStyle {
    
    // 货币数字形式(千分位格式)
    NSNumber *DecimalStyleNum1 = @(0.123456789123456789);// 1. 最多默认保留3位小数，会四舍五入小数的千分位
    NSNumber *DecimalStyleNum2 = @(123456789.1234);
    NSNumber *DecimalStyleNum3 = @(123456789.1235);
    NSNumber *DecimalStyleNum4 = @(123456789123.1234567);// 2. 整数部分位数越多，小数位数越少,超出16位时就会只显示整数部分
    NSNumber *DecimalStyleNum5 = @(1234567891234.1234567);
    NSNumber *DecimalStyleNum6 = @(12345678912345.1234567);
    NSNumber *DecimalStyleNum7 = @(123456789123456.1234567);
    NSNumber *DecimalStyleNum8 = @(1234567891234567.1234567);
    NSNumber *DecimalStyleNum9 = @(123456789123456789.1234567);// 3. 整数部分>16位后，会用科学记数法输出
    NSNumber *DecimalStyleNum10 = @(12345678912345678.1234567);
    NSNumber *DecimalStyleNum11 = @(1234567891234567.1234567);
    NSNumber *DecimalStyleNum12 = @(1234567891234567.7); // 4. 对比11的结果，整数部分为16位时，小数省略后变得奇怪，暂时区分不了什么
    NSNumber *DecimalStyleNum13 = @(1234567891234567.5);
    NSNumber *DecimalStyleNum14 = @(1234567891234567.4);
    NSNumber *DecimalStyleNum15 = @(1234567891234567.42);
    NSNumber *DecimalStyleNum16 = @(1234567891234567.72);
    NSNumber *DecimalStyleNum17 = @(1234567891234567.123);
    NSNumber *DecimalStyleNum18 = @(1234567891234567.125);
    
    NSArray *DecimalStyleArray = @[DecimalStyleNum1, DecimalStyleNum2, DecimalStyleNum3, DecimalStyleNum4, DecimalStyleNum5, DecimalStyleNum6, DecimalStyleNum7, DecimalStyleNum8, DecimalStyleNum9, DecimalStyleNum10, DecimalStyleNum11, DecimalStyleNum12, DecimalStyleNum13, DecimalStyleNum14, DecimalStyleNum15, DecimalStyleNum16, DecimalStyleNum17, DecimalStyleNum18];
    [DecimalStyleArray enumerateObjectsUsingBlock:^(NSNumber *DecimalStyleNum, NSUInteger idx, BOOL * _Nonnull stop) {
        idx +=  1;
        NSString *DecimalStyleNumStr = [NSNumberFormatter localizedStringFromNumber:DecimalStyleNum numberStyle:NSNumberFormatterDecimalStyle];
        NSLog(@"%zd DecimalStyle：%@ -> %@",idx ,DecimalStyleNum, DecimalStyleNumStr);
    }];
    
}


- (void)localizedStringFromNumber_numberStyle_CurrencyStyle {
    NSNumber *num1 = @(123456.789);
    // 货币的形式，带本地化的货币符号
    NSString *numStr3 = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyStyle];
    NSLog(@"%@", numStr3);
    
}

- (void)localizedStringFromNumber_numberStyle_PercentStyle {
    NSNumber *num1 = @(123456.789);
    // 百分数形式,并且四舍五入到百分比的整数部分
    NSString *numStr4 = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterPercentStyle];
    NSLog(@"%@", numStr4);
    
}

- (void)localizedStringFromNumber_numberStyle_ScientificStyle {
    NSNumber *num1 = @(123456.789);
    // 科学计数形式
    NSString *numStr5 = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterScientificStyle];
    NSLog(@"%@", numStr5);
    
}

- (void)localizedStringFromNumber_numberStyle_SpellOutStyle {
    NSNumber *num1 = @(123456.789);
    // 本地化拼写形式
    NSString *numStr6 = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterSpellOutStyle];
    NSLog(@"%@", numStr6);
    
}

- (void)localizedStringFromNumber_numberStyle_OrdinalStyle {
    NSNumber *num1 = @(123456.789);
    // iOS 9.0 序数形式
    NSString *numStr7 = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterOrdinalStyle];
    NSLog(@"%@", numStr7);
    
}

- (void)localizedStringFromNumber_numberStyle_CurrencyISOCodeStyle {
    NSNumber *num1 = @(123456.789);
    // iOS 9.0 货币形式 显示ISO分配的货币符号
    NSString *numStr8 = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyISOCodeStyle];
    NSLog(@"%@", numStr8);
    
}

- (void)localizedStringFromNumber_numberStyle_CurrencyPluralStyle {
    NSNumber *num1 = @(123456.789);
    // iOS 9.0 货币形式
    NSString *numStr9 = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyPluralStyle];
    NSLog(@"%@", numStr9);

}

- (void)localizedStringFromNumber_numberStyle_CurrencyAccountingStyle {
    NSNumber *num1 = @(123456.789);
    // iOS 9.0 会计形式
    NSString *numStr10 = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyAccountingStyle];
    NSLog(@"%@", numStr10);
    
}



- (NSString *)ja_FormatDecimalNumberStr:(NSString *)numStr {
    if (!numStr || numStr.length == 0) {
        return numStr;
    }
    
//    NSNumber *number = @(numStr.doubleValue);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.positiveFormat = @"###,##0.00";
    NSNumber *number = [formatter numberFromString:numStr];
    
    NSString *amountString = [formatter stringFromNumber:number];
    return amountString;
}

@end
