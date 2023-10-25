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
    
    
    /// 获取PRC参数，并做时钟效验
    /// - Returns: 一个 Observable<String>，当时钟匹配成功时发出当前小时值
    func getSignatureTime() -> Observable<String> {
        let matchedHourSubject = ReplaySubject<String>.create(bufferSize: 1)
        
        let deviceDateFormatter = DateFormatter()
        deviceDateFormatter.dateFormat = "HH"  // 24小时制
        
        // 创建一个定时器，每秒检查一次
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        timer
            .subscribe(onNext: { _ in
                let currentDeviceHour = deviceDateFormatter.string(from: Date())
                
                let prcTimeZone = TimeZone(identifier: "Asia/Shanghai")
                let prcDateFormatter = DateFormatter()
                prcDateFormatter.timeZone = prcTimeZone
                prcDateFormatter.dateFormat = "HH"  // 24小时制
                let currentHourInPRC = prcDateFormatter.string(from: Date())
                
                // 检查设备时钟是否与 PRC 时区的时钟匹配
                if currentDeviceHour == currentHourInPRC {
                    print("时钟匹配")
                    matchedHourSubject.onNext(currentHourInPRC)
                } else {
                    print("时钟不匹配")
                }
            })
            .disposed(by: disposeBag)
        
        return matchedHourSubject.asObservable()
    }
    
    func md5(string: String) -> String {
        let data = Data(string.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        data.withUnsafeBytes { bufferPointer in
            _ = CC_MD5(bufferPointer.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

