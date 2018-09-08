//
//  Person.m
//  Block01
//
//  Created by Jacob_Liang on 2018/9/2.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc {
    [super dealloc];
    NSLog(@"%s", __func__);
}

@end
