//
//  UserManager.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/26.
//
import Foundation
/// <#Description#>
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
    
    /// 设置
    var settingModel: SettingModel? {
        didSet {
            if let model = settingModel {
                if let encodedData = try? JSONEncoder().encode(model) {
                    UserDefaults.standard.set(encodedData, forKey: "SettingModel")
                }
            }
        }
    }
    ///是否接受了协议
    var isAccpetAgree:Bool = false{
        didSet{
            UserDefaults.standard.set(isAccpetAgree, forKey: "isAccpetAgree")

        }
    }
    
    private init() {
        // 从UserDefaults中获取保存的数据
        self.key = UserDefaults.standard.string(forKey: "key")
        self.kefu = UserDefaults.standard.string(forKey: "kefu")
        self.tab = UserDefaults.standard.integer(forKey: "tab")
        self.isAccpetAgree = UserDefaults.standard.bool(forKey: "isAccpetAgree")

        // 加载SettingModel
        if let savedData = UserDefaults.standard.data(forKey: "SettingModel") {
            settingModel = try? JSONDecoder().decode(SettingModel.self, from: savedData)
        }
    }
    
    func clearAll() {
        key = nil
        kefu = nil
        tab = nil
        UserDefaults.standard.removeObject(forKey: "SettingModel")
    }
}
