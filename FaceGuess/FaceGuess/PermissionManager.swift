//
//  PermissionManager.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/24.
//
import RxSwift
import UIKit
class PermissionManager {
    static let shared = PermissionManager()
    var isLocationAuthorized: Bool {
        didSet {
            locationPermissionSubject.onNext(isLocationAuthorized)
        }
    }
    
    let locationPermissionSubject: BehaviorSubject<Bool>
    
    private init() {
        // 从UserDefaults或其他存储方式中获取初始状态
        self.isLocationAuthorized = UserDefaults.standard.bool(forKey: "isLocationAuthorized")
        
        // 使用获取到的初始状态初始化BehaviorSubject
        self.locationPermissionSubject = BehaviorSubject<Bool>(value: self.isLocationAuthorized)
    }
}

