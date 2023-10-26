//
//  UserManager.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/26.
//

import Foundation
class UserManager {
    
    // 单例实例
    static let shared = UserManager()
    
    // 用户信息
    var key: String? {
        didSet {
            UserDefaults.standard.set(key, forKey: "key")
        }
    }
    var kefu: String? {
        didSet {
            UserDefaults.standard.set(kefu, forKey: "kefu")
        }
    }
    var tab: Int? {
        didSet {
            UserDefaults.standard.set(tab, forKey: "tab")
        }
    }
    
    private init() {
        // 从UserDefaults中获取保存的数据
        self.key = UserDefaults.standard.string(forKey: "key")
        self.kefu = UserDefaults.standard.string(forKey: "kefu")
        self.tab = UserDefaults.standard.integer(forKey: "tab")
    }
    func clearAll() {
        key = nil
        kefu = nil
        tab = nil
    }

    
}
