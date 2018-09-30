//
//  AppDelegate.swift
//  MyCoin-DuplicatePlate
//
//  Created by Jacob_Liang on 2018/9/28.
//  Copyright © 2018年 Jacob_Liang. All rights reserved.
//

import UIKit // 不再使用@“”了

@UIApplicationMain // 相当于 OC 的 mian.m 文件
class AppDelegate: UIResponder, UIApplicationDelegate {// 一个类的定义，开始位置
    // 内部可以写实例方法,协议写法与集成的父类写法是一样的，形式上与类是一致了
    // 类定义 使用 class 声明

    var window: UIWindow? //一个变量的定义，可选类型，可以能为空，自动生成的格式是:靠左，不是两边有空格形式

    // [Swift函数(Functions) - 简书](https://www.jianshu.com/p/25eb2e706936)
    /*
     下划线，隐藏第一个调用是外部参数名参数
     func test(_ prarms1: Int, prarms2: Int) {
     }
     调用
     AppDelegate().test(<#T##prarms1: Int##Int#>, prarms2: <#T##Int#>)
     */
    
    
    
    /*
     木有下划线
     func test(prarms1: Int, prarms2: Int) {
     }
     调用
     AppDelegate().test(params1: <#Int#>, prarms2: <#T##Int#>)
     */
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        setUpRootWindow() //self.setUpRootWindow() 也可以这样写, 扩展 AppDelegate 的方法，直接新建 swift 文件，文件命名上参考 OC 分类(xxx+xx); 使用 extension 关键字处理 [Swift创建类别Category - 简书](https://www.jianshu.com/p/a32697d2a9f3)
        
        return true
        
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


} //一个类的定义，结束位置

