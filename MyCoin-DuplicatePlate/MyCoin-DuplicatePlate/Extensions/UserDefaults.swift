//
//  UserDefaults.swift
//  MyCoin-DuplicatePlate
//
//  Created by Jacob_Liang on 2018/10/9.
//  Copyright © 2018年 Jacob_Liang. All rights reserved.
//

import Foundation

protocol UserDefaultsNameSpace {
}

extension UserDefaultsNameSpace {
    static func namespace<T>(_ key: T) -> String where T: RawRepresentable {
        return "\(Self.self).\(key.rawValue)"
    }
}

protocol UserDefaultsSettable: UserDefaultsNameSpace { // 协议的继承 采用 UserDefaultsSettable协议的对象必须同时准守 UserDefaultsNameSpace协议
    associatedtype UserDefaultKey: RawRepresentable // 给关联类型设置约束
}
