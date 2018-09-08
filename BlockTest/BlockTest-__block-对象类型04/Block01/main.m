//
//  main.m
//  Block01
//
//  Created by Jacob_Liang on 2018/9/2.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"
#import "Man.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        void(^mallocBlock)(void);
        void(^mallocBlock2)(void);
        {
            __block Person *person = [[Person alloc] init];
            mallocBlock = ^{
                NSLog(@"1 - %p", person);
            };
        }
        
        {
            __block Man *man = [[Man alloc] init];
            __weak Man *weakMan = man;
            mallocBlock2 = ^{
                NSLog(@"2 - %p", weakMan);
            };
        }
        
        mallocBlock();
        mallocBlock2();
        
        NSLog(@"-----");
        
    }
    return 0;
}

