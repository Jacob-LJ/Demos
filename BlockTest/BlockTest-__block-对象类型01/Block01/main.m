//
//  main.m
//  Block01
//
//  Created by Jacob_Liang on 2018/9/2.
//  Copyright © 2018年 Jacob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"

struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
};

struct __main_block_desc_1 {
    size_t reserved;
    size_t Block_size;
};

struct __Block_byref_person_0 {
    void *__isa;
    struct __Block_byref_person_0 *__forwarding;
    int __flags;
    int __size;
    void (*__Block_byref_id_object_copy)(void*, void*);
    void (*__Block_byref_id_object_dispose)(void*);
    Person *person;
};

// stackBlock
struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    struct __Block_byref_person_0 *person; // by ref
};

// mallocBlock
struct __main_block_impl_1 {
    struct __block_impl impl;
    struct __main_block_desc_1* Desc;
    struct __Block_byref_person_0 *person; // by ref
};

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        __block Person *person = [[Person alloc] init];
        
        NSLog(@"stack - __block perosn 结构体内的 person 地址 %p", person);
        
        // 栈
        void(^stackBlock)(void) = ^{
            NSLog(@"%p", person);
        };
        stackBlock();
        NSLog(@"stackBlock - %@ - 地址 %p",[stackBlock class], stackBlock);
        struct __main_block_impl_0 *stackBlockImp = (struct __main_block_impl_0 *)stackBlock;
        NSLog(@"stackBlockImp 地址 - %p",stackBlockImp);
        NSLog(@"stack - __block perosn 结构体地址 %p",stackBlockImp->person);
        NSLog(@"stack - __block perosn 结构体地址 的__forwarding值 %p",stackBlockImp->person->__forwarding);
        NSLog(@"stack - __block perosn 结构体内的 person 地址 %p",stackBlockImp->person->__forwarding->person);
        
        
        // 堆
        void(^mallocBlock)(void) = [^{
            NSLog(@"%p", person);
        } copy];
        mallocBlock();
        NSLog(@"mallocBlock - %@ - 地址 %p",[mallocBlock class], mallocBlock);
        struct __main_block_impl_1 *mallocBlockImp = (struct __main_block_impl_1 *)mallocBlock;
        NSLog(@"mallocBlockImp 地址 - %p",mallocBlockImp);
        NSLog(@"malloc - __block perosn 结构体地址 %p",mallocBlockImp->person);
        NSLog(@"malloc - __block perosn 结构体地址 的__forwarding值 %p",mallocBlockImp->person->__forwarding);
        NSLog(@"malloc - __block perosn 结构体内的 person 地址 %p",mallocBlockImp->person->__forwarding->person);
        
        // __block perosn 结构体 内存位置变化后
        NSLog(@"stack - __block perosn 结构体地址 %p",stackBlockImp->person);
        NSLog(@"stack - __block perosn 结构体地址 的__forwarding值 %p",stackBlockImp->person->__forwarding); //__forwarding指针变化了，指向堆中的结构体地址
        NSLog(@"stack - __block perosn 结构体内的 person 地址 %p",stackBlockImp->person->__forwarding->person);
        
    }
    return 0;
}

