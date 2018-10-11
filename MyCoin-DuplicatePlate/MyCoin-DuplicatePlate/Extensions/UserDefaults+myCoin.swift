//
//  UserDefaults+myCoin.swift
//  MyCoin-DuplicatePlate
//
//  Created by Jacob_Liang on 2018/10/8.
//  Copyright © 2018年 Jacob_Liang. All rights reserved.
//

import Foundation

// 对 UserDefaults 进行扩展
extension UserDefaults {
    
    struct Document: UserDefaultsSettable {
        enum UserDefaultKey: String {
            case coinsPlistExists
        }
    }
    
    struct Settings: UserDefaultsSettable {
        enum UserDefaultKey: String {
            case marketColor        // 行情颜色
            case currency           // 货币符号
            case percentChange      // 涨跌周期
            case authentication     // 认证
            case usdPrice           // 显示美元对照
        }
    }
}
