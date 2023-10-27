//
//  Screen.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/20.
//

import UIKit
/// 屏幕宽
let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高
let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height

/// 屏幕宽比
let kScaleX: CGFloat = kScreenWidth / 375

/// 屏幕高比
let kScaleY: CGFloat = kScreenHeight / 667

/// 判断是否是iPhone
let kIsPhone = (UI_USER_INTERFACE_IDIOM() == .phone)

/// 判断是否是iPhoneX
let kIsPhoneX = (kScreenWidth >= 375 && kScreenHeight >= 812 && kIsPhone)

/// 状态栏高度
let kStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height//(kIsPhoneX ? 44 : 20)

/// 导航栏高度
let kNavBarHeight: CGFloat = 44

/// 状态栏和导航栏总高度
let kNavBarAndStatusBarHeight: CGFloat = kStatusBarHeight + kNavBarHeight//(kIsPhoneX ? 88 : 64)

/// 底部安全高度
let kSafeHeight: CGFloat = (kIsPhoneX ? 34 : 0)

/// Tabbar高度
let kTabBarHeight: CGFloat = (kIsPhoneX ? (49 + kSafeHeight) : 49)

/// 导航条和Tabbar总高度
let kNavAndTabHeight: CGFloat = kNavBarAndStatusBarHeight + kTabBarHeight



class Utils {
    static func getCurrentNavigationController() -> UINavigationController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return nil
        }

        var currentController: UIViewController = rootViewController
        while let presentedController = currentController.presentedViewController {
            currentController = presentedController
        }
        
        if let navigationController = currentController as? UINavigationController {
            return navigationController
        } else {
            return currentController.navigationController
        }
    }
}

