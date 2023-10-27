//
//  ViewModel.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/25.
//

import RxMoya
import Moya
import RxSwift
import RxCocoa
import CommonCrypto

enum APIError: Error {
    case parsingFailed(String)
    case dataFieldMissing
    case badStatusCode(Int)
    
    var localizedDescription: String {
        switch self {
        case .parsingFailed(let message):
            return message
        case .dataFieldMissing:
            return "Data field is missing or null."
        case .badStatusCode(let code):
            return "Bad status code: \(code)"
        }
    }
}


class ViewModel {
    
    let commonParametersPlugin: CommonParametersPlugin
    let networkLogger = NetworkLoggerPlugin()
    var provider: MoyaProvider<APIService>
    let disposeBag = DisposeBag()
    
    init() {
        commonParametersPlugin = CommonParametersPlugin()
        provider = MoyaProvider<APIService>(plugins: [commonParametersPlugin,networkLogger])
    }
    
    /// 发送验证码
    /// - Parameters:
    ///   - mobile: <#mobile description#>
    ///   - signature: <#signature description#>
    /// - Returns: <#description#>
    func RequestSMSCode(mobile: String, signature: String) -> Observable<Any> {
        return provider.rx.request(.getSMSCode(mobile: mobile, signature: signature))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
    }
    
    
    /// 一键登录
    /// - Parameters:
    ///   - signature: <#signature description#>
    ///   - result: <#result description#>
    /// - Returns: <#description#>
    func NoAuthLoginRequest(signature: String,result:[String:Any])-> Observable<LoginModel> {
        return provider.rx.request(.getNoAuthLogin(signature: signature, result: result))
            .filterSuccessfulStatusCodes()
            .asObservable()  // 转换 Single 为 Observable
            .flatMap { [unowned self] response -> Observable<LoginModel> in
                do {
                    let result = try self.mapDataField(from: response, type: LoginModel.self)
                    return Observable.just(result)  // 创建并返回一个包含解析结果的 Observable
                } catch let error {
                    return Observable.error(error)  // 创建并返回一个包含错误的 Observable
                }
            }
            .catch { error in
                // 在这里，你可以处理错误
                return Observable.error(error)
            }
    }
    
    /// 登录
    /// - Parameters:
    ///   - mobile: <#mobile description#>
    ///   - signature: <#signature description#>
    ///   - code: <#code description#>
    /// - Returns: <#description#>
    func loginRequest(mobile: String, signature: String, code: String) -> Observable<LoginModel> {
        return provider.rx.request(.login(mobile: mobile, signature: signature, code: code))
            .filterSuccessfulStatusCodes()
            .asObservable()  // 转换 Single 为 Observable
            .flatMap { [unowned self] response -> Observable<LoginModel> in
                do {
                    let result = try self.mapDataField(from: response, type: LoginModel.self)
                    return Observable.just(result)  // 创建并返回一个包含解析结果的 Observable
                } catch let error {
                    return Observable.error(error)  // 创建并返回一个包含错误的 Observable
                }
            }
            .catch { error in
                // 在这里，你可以处理错误
                return Observable.error(error)
            }
    }
    
    /// 退出登录
    /// - Parameter key: <#key description#>
    /// - Returns: <#description#>
    func logoutRequest(key:String) -> Observable<Any>{
        return provider.rx.request(.logout(key: key))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
    }
    
    /// 注销账号-文案
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - cancel_member: <#cancel_member description#>
    /// - Returns: <#description#>
    func destructionInfoRequest(key:String) -> Observable<[String:String]> {
        return provider.rx.request(.destructionInfo(key: key))
            .filterSuccessfulStatusCodes()
            .asObservable()  // 转换 Single 为 Observable
            .flatMap { [unowned self] response -> Observable<[String:String]> in
                do {
                    let result = try self.mapDataField(from: response, type: [String:String].self)
                    return Observable.just(result)  // 创建并返回一个包含解析结果的 Observable
                } catch let error {
                    return Observable.error(error)  // 创建并返回一个包含错误的 Observable
                }
            }
            .catch { error in
                // 在这里，你可以处理错误
                return Observable.error(error)
            }
    }
    
    
    /// 注销账号-提交
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - signature: <#signature description#>
    /// - Returns: <#description#>
    func destructionCommitRequest(key:String , signature:String) -> Observable<Any>{
        return provider.rx.request(.destructionCommit(key: key, signature: signature))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
    }
    
    /// 设置
    /// - Parameter key: <#key description#>
    /// - Returns: <#description#>
    func mySettingRequest(key:String , signature:String) -> Observable<SettingModel> {
        return provider.rx.request(.mySetting(key: key, signature: signature))
            .filterSuccessfulStatusCodes()
            .asObservable()  // 转换 Single 为 Observable
            .flatMap { [unowned self] response -> Observable<SettingModel> in
                do {
                    let result = try self.mapDataField(from: response, type: SettingModel.self)
                    return Observable.just(result)  // 创建并返回一个包含解析结果的 Observable
                } catch let error {
                    return Observable.error(error)  // 创建并返回一个包含错误的 Observable
                }
            }
            .catch { error in
                // 在这里，你可以处理错误
                return Observable.error(error)
            }
    }
    
    
    /// 获取Html 动态页
    /// - Parameters:
    ///   - key: <#key description#>
    ///   - kefu: <#kefu description#>
    /// - Returns: <#description#>
    func getHtmlRequest(key: String, kefu: String) -> Observable<String> {
        return provider.rx.request(.getHtmlView(key: key, kefu: kefu))
            .filterSuccessfulStatusCodes()
            .mapString()  // 使用.mapString()来获取响应体作为字符串
            .asObservable()
    }
    
    ///消息未读数
    func getUnReadRequest(key:String) -> Observable<[String:Int]> {
        return provider.rx.request(.getBadge(key: key))
            .filterSuccessfulStatusCodes()
            .asObservable()  // 转换 Single 为 Observable
            .flatMap { [unowned self] response -> Observable<[String:Int]> in
                do {
                    let result = try self.mapDataField(from: response, type: [String:Int].self)
                    return Observable.just(result)  // 创建并返回一个包含解析结果的 Observable
                } catch let error {
                    return Observable.error(error)  // 创建并返回一个包含错误的 Observable
                }
            }
            .catch { error in
                // 在这里，你可以处理错误
                return Observable.error(error)
            }
    }
    

}

extension ViewModel {
    
    /// PRC 时钟
    /// - Returns: <#description#>
    func getSignatureTime() ->String {
        let prcTimeZone = TimeZone(identifier: "Asia/Shanghai")
        let prcDateFormatter = DateFormatter()
        prcDateFormatter.timeZone = prcTimeZone
        prcDateFormatter.dateFormat = "HH"  // 24小时制
        let currentHourInPRC = prcDateFormatter.string(from: Date())
        return currentHourInPRC
    }
    
    /// MD5 加密
    /// - Parameter string: <#string description#>
    /// - Returns: <#description#>
    func md5(string: String) -> String {
        let data = Data(string.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { bufferPointer in
            _ = CC_MD5(bufferPointer.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    /// Json 解析过滤
    /// - Parameters:
    ///   - response: <#response description#>
    ///   - type: <#type description#>
    /// - Returns: <#description#>
    func mapDataField<T: Codable>(from response: Response, type: T.Type) throws -> T {
        let jsonDecoder = JSONDecoder()
        let statusCode = response.statusCode
        
        if statusCode != 200 {
            throw APIError.badStatusCode(statusCode)
        }
        
        if let jsonResponse = try? JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
           let dataField = jsonResponse["data"] {
            if dataField is NSNull {
                throw APIError.dataFieldMissing
            }
            let data = try JSONSerialization.data(withJSONObject: dataField, options: [])
            return try jsonDecoder.decode(T.self, from: data)
        } else {
            throw APIError.parsingFailed("Failed to parse JSON.")
        }
    }
    /// 时钟效验
    /// - Returns: 一个 Observable<String>，当时钟匹配成功时发出当前小时值
//    func getSignatureTime() -> Observable<String> {
//        let matchedHourSubject = ReplaySubject<String>.create(bufferSize: 1)
//
//        let deviceDateFormatter = DateFormatter()
//        deviceDateFormatter.dateFormat = "HH"  // 24小时制
//
//        // 创建一个定时器，每秒检查一次
//        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//
//        timer
//            .subscribe(onNext: { _ in
//                let currentDeviceHour = deviceDateFormatter.string(from: Date())
//
//                let prcTimeZone = TimeZone(identifier: "Asia/Shanghai")
//                let prcDateFormatter = DateFormatter()
//                prcDateFormatter.timeZone = prcTimeZone
//                prcDateFormatter.dateFormat = "HH"  // 24小时制
//                let currentHourInPRC = prcDateFormatter.string(from: Date())
//
//                // 检查设备时钟是否与 PRC 时区的时钟匹配
//                if currentDeviceHour == currentHourInPRC {
//                    print("时钟匹配")
//                    matchedHourSubject.onNext(currentHourInPRC)
//                } else {
//                    print("时钟不匹配")
//                }
//            })
//            .disposed(by: disposeBag)
//
//        return matchedHourSubject.asObservable()
//    }
}
