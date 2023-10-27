//
//  CommonModel.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/25.
//
import AdSupport
import UIKit
struct CommonModel:Codable {
    ///版本号(version)
    var version:String{
        get{
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return version
            }
            return "Unknown"
        }
    }
    ///获取客户端
    var client:String{
        get{
            let deviceType = UIDevice.current.userInterfaceIdiom

            switch deviceType {
            case .phone:
                return "iPhone"
            case .pad:
                return "iPad"
            default:
                return "unknown"
            }
        }
    }
    
    /// 设备型号(device)
    var device:String {
        get{
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            var identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else {
                    return identifier
                }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            identifier = identifier.replacingOccurrences(of: " ", with: "-")
            identifier = identifier.replacingOccurrences(of: ",", with: "-")
            return identifier
        }
    }
    ///广告标识(idfa)
    var idfa: String {
        get {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                return ASIdentifierManager.shared().advertisingIdentifier.uuidString
            } else {
                // 用户禁止了广告跟踪或在设置中限制了广告跟踪
                return "advertisingTrackingDisabled"
            }
        }
    }
    
    /// APNs设备码(device_token)
    var device_token: String {
        get {
            if let deviceToken = UserDefaults.standard.string(forKey: "device_token") {
                return deviceToken
            }
            return "Device token not available"
        }
    }
    
    /// TakingData 唯一ID(tdid)
    var tdid:String {
        get{
            return  TalkingDataSDK.getDeviceId()
        }
    }
    ///经度
    var lng: String {
        get {
            if let longitude = UserDefaults.standard.value(forKey: "longitude") as? Double {
                return "\(longitude)"
            }
            return "0.0"
        }
    }
    ///纬度
    var lat: String {
        get {
            if let latitude = UserDefaults.standard.value(forKey: "latitude") as? Double {
                return "\(latitude)"
            }
            return "0.0"
        }
    }
    
    /// 应用名
    var appname:String{
        get{
            return "bafacegs"
        }
    }
}
