//
//  main.m
//  Block01
//
//  Created by Jacob_Liang on 2018/9/2.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        void(^stackBlock)(void);
        
        __block Person *person = [[Person alloc] init];
        stackBlock = ^{
            NSLog(@"%p", person);
        };
        [person release];
        
        stackBlock();
        [stackBlock release];
        
        
    }
    return 0;
}

