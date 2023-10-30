//
//  AutoLoginVIewController.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/30.
//

import UIKit
import CL_ShanYanSDK
import Alamofire
class AutoLoginVIewController:BaseViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        if let key = UserManager.shared.key,key.count > 0 {
            
        }else{
            CLShanYanSDKManager.preGetPhonenumber()
        }
        quickLogin()
    }
    


    // 用户需要使用闪验一键登录时的方法
    func quickLogin() {

        //定制界面
        let baseUIConfigure = CLUIConfigure()
        //requried
        baseUIConfigure.viewController = self
        baseUIConfigure.clLogoImage = UIImage(named: "2")!
        //开发者自己的loading
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.show()
    
        CLShanYanSDKManager.quickAuthLogin(with: baseUIConfigure) {  (completeResult) in
            SVProgressHUD.dismiss()
            if completeResult.error != nil {
                //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式
                //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式
                //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式

                DispatchQueue.main.async(execute: {
                    if completeResult.code == 1011 {
                        // 用户取消登录
                        //处理建议：如无特殊需求可不做处理，仅作为状态回调，此时已经回到当前用户自己的页面
                        SVProgressHUD.showInfo(withStatus: "用户取消免密登录")
                    }else{
                        //处理建议：其他错误代码表示闪验通道无法继续，可以统一走开发者自己的其他登录方式，也可以对不同的错误单独处理
                        if completeResult.code == 1009{
                            // 无SIM卡
                            SVProgressHUD.showInfo(withStatus: "此手机无SIM卡")
                        }else if completeResult.code == 1008{
                            SVProgressHUD.showInfo(withStatus: "请打开蜂窝移动网络")
                        }else {
                            // 跳转验证码页面
                            SVProgressHUD.showInfo(withStatus: "网络状况不稳定，切换至验证码登录")
                        }
                    }
                })
            }else{
              //SDK成功获取到Token
                  
                  /** token置换手机号
                code
                */
              
                NSLog("quickAuthLogin Success:%@",completeResult.data ?? "")

                //urlStr:用户后台对接闪验后台后配置的API，以下为Demo提供的调试API及调用示例，在调试阶段可暂时调用此API，也可用此API验证后台API是否正确配置
                var urlStr : String?
                let APIString = "https://api.253.com/"

                if let telecom = completeResult.data?["telecom"] as! String?{
                    switch telecom {
                    case "CMCC":
                        urlStr = APIString.appendingFormat("open/flashsdk/mobile-query-m")
                        break
                    case "CUCC":
                        urlStr = APIString.appendingFormat("open/flashsdk/mobile-query-u")
                        break
                    case "CTCC":
                        urlStr = APIString.appendingFormat("open/flashsdk/mobile-query-t")
                        break
                    default:
                        break
                    }
                }

                if let urlStr = urlStr{
                    let dataDict = completeResult.data as! Parameters
                    
                    Alamofire.request(urlStr, method: .post, parameters: dataDict, encoding: URLEncoding.default, headers: [:]).responseJSON { response in
                        if response.result.isSuccess {
                            if let json = response.result.value as? [String: Any] {
                                if let code = json["code"] as? Int, code == 200000 {
                                    if let data = json["data"] as? [String: Any],
                                       let mobileName = data["mobileName"] as? String {
                                        // 在这里，如果你有用于解密的代码，可以用它来解密 mobileName。
                                        // 例如：
                                        // let mobileCode = yourDESDecryptFunction(mobileName, key: "yourKey")
                                        // 使用 DispatchQueue 更新 UI
                                        DispatchQueue.main.async {
                                            // 更新 UI，例如使用 SVProgressHUD 或其他库
                                            // SVProgressHUD.showSuccess(withStatus: "免密登录成功,手机号：\(mobileCode)")
                                        }
                                        print("免密登录成功,手机号：\(mobileName)")  // 或者使用解密后的 mobileCode
                                    }
                                }
                            }
                        } else {
                            // 处理错误
                            print("请求失败: \(String(describing: response.result.error))")
                        }
                    }

                }
            }
        }
//        CLShanYanSDKManager.quickAuthLogin(with: baseUIConfigure, timeOut: 4, shanyanAuthListener: { (completeResult) in
//            print("拉起授权页")
//        }) { (completeResult) in
//
//        }
    }

}
