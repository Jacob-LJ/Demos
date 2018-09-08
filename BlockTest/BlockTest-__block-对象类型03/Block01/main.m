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
        void(^mallocBlock)(void);
        
        __block Person *person = [[Person alloc] init];
        mallocBlock = [^{
            NSLog(@"%p", person);
        } copy];
        [person release];
        
        mallocBlock();
        [mallocBlock release];
        
        
    }
    return 0;
}

