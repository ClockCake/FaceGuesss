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
import IQKeyboardManagerSwift
import RxSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate  {
    static private let talkingDataSDKKey = "3AB64976E76E4B2183430371D9AD139E"
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let viewModel = ViewModel()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ///屏蔽约束打印
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        IQKeyboardManager.shared.enable = true
        initTalkingDataSDK()
        extraGraphicsSetting()
        if let key = UserManager.shared.key,key.count > 0 {
            getBadgeSession()
        }
        
        CLShanYanSDKManager.initWithAppId("jesGSlEA") { (completeResult) in
            if ((completeResult.error) != nil) {
                print("初始化失败")
            } else {
                print("初始化成功")
            }
        }
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

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(token, forKey: "device_token")
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
                    // 延迟 2 秒执行
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        // 在这里放置需要延迟执行的代码
                        // 第二步：请求定位权限
                        self?.requestLocationPermission()
                        // 注册推送通知
                        let notificationCenter = UNUserNotificationCenter.current()
                        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                            // Handle granted or not
                        }
                        UIApplication.shared.registerForRemoteNotifications()
                    }



                }
            }
        }

    }
    
    /// 请求IDFA
    /// - Parameter completion: <#completion description#>
    func requestIDFA(completion: @escaping () -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    /// 初始化 TalkingDataSDK
                    TalkingDataSDK.`init`(AppDelegate.talkingDataSDKKey, channelId: "AppStore", custom: "")
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
    
    
    /// 获取定位
    func requestLocationPermission() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        UserDefaults.standard.set(location.coordinate.longitude, forKey: "longitude")
        UserDefaults.standard.set(location.coordinate.latitude, forKey: "latitude")
    }
    
    
    /// 获取Badge值并设置
    func getBadgeSession(){
        self.viewModel.getUnReadRequest(key: UserManager.shared.key ?? "")
            .withUnretained(self)
            .subscribe(onNext: { sender in
                UIApplication.shared.applicationIconBadgeNumber = sender.1["unread"] ?? 0
            })
            .disposed(by: disposeBag)
    }
}
extension Notification.Name {
    static let locationAuthorizationChanged = Notification.Name("locationAuthorizationChanged")
}

