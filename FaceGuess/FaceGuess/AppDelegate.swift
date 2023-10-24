//
//  AppDelegate.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import Network
import AppTrackingTransparency
import AdSupport
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate  {
    static private let talkingDataSDKKey = "3AB64976E76E4B2183430371D9AD139E"

    private let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ///屏蔽约束打印
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        initTalkingDataSDK()
        
        extraGraphicsSetting()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    /// overall situation setting
    func extraGraphicsSetting()
    {
        if #available(iOS 13.0, *) {
            // Override user interface style to light mode
            UIWindow.appearance().overrideUserInterfaceStyle = .light
        }

    }
    
    func initTalkingDataSDK(){
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {  [weak self] path in
            if path.status == .satisfied {
                // 网络可用，请求IDFA
                self?.requestIDFA { [weak self] in
                    // 第二步：请求定位权限
                    self?.requestLocationPermission()
                    TalkingDataSDK.`init`(AppDelegate.talkingDataSDKKey, channelId: "AppStore", custom: "")

                }
            }
        }

    }
    func requestIDFA(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    print("IDFA: \(idfa)")
                default:
                    print("Not authorized to use IDFA.")

                }
                // 处理授权结果
                completion()
                
            }
        } else {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            // 处理授权结果
            print("IDFA: \(idfa)")
            // 处理授权结果
            completion()
        }
    }
    
    func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // 从UserDefaults中获取上一次的定位授权状态
        let isAuthorized = UserDefaults.standard.bool(forKey: "isLocationAuthorized")
        PermissionManager.shared.isLocationAuthorized = isAuthorized
    }
    
    // CLLocationManagerDelegate方法，用于处理定位授权状态
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var isAuthorized: Bool = false
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // 已授权，执行后续操作
            isAuthorized = true
            break
        default:
            // 其他状态
            isAuthorized = false
            break
        }
        // 更新BehaviorSubject的值
          PermissionManager.shared.isLocationAuthorized = isAuthorized
          UserDefaults.standard.set(isAuthorized, forKey: "isLocationAuthorized")
    }

}
extension Notification.Name {
    static let locationAuthorizationChanged = Notification.Name("locationAuthorizationChanged")
}

