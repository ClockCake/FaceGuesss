//
//  APIService.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/25.
//


import Moya

enum APIService {
    ///发送验证码
    case getSMSCode(mobile: String, signature: String)
    ///一键登录
    case getNoAuthLogin(signature:String,result:[String:Any])
    /// 验证码登录
    case login(mobile: String, signature: String,code:String)
    /// 退出登录
    case logout(key:String)
    ///注销文案
    case destructionInfo(key:String)
    ///注销提交
    case destructionCommit(key:String ,signature: String)
    ///设置
    case mySetting(key:String,signature: String)
    ///获取H5
    case getHtmlView(key:String,kefu:String)
    /// 获取未读数
    case getBadge(key:String)

}

extension APIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://bafacegs.tongchengjianzhi.cn")!
    }
    
    var path: String {
        switch self {
            case .getSMSCode:
                return "/sign/"
            case .getNoAuthLogin:
                return "/sign/"
            case .login:
                return "/sign/"
            case .logout:
                return "/sign/"
            case .destructionInfo:
                return "/sign/"
            case .destructionCommit:
                return "/sign/"
            case .mySetting:
                return "/sign/"
            case .getHtmlView:
                return "/find/"
            case .getBadge:
                return "/sign/"
            

        }
    }
    
    var method: Moya.Method {
        switch self {
//            case .getSMSCode:
//                return .get
//            case .login:
//                return .get
//            case .logout:
//                return .get
//            case .destructionInfo:
//                return .get
//            case .destructionCommit:
//                return .get
            default:
                return .get
                
        }
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
            case let .getSMSCode(mobile, signature):
                params["mobile"] = mobile
                params["signature"] = signature
                params["a"] = "index"
            case let .getNoAuthLogin(signature , result):
                params["result"] = result
                params["signature"] = signature
                params["a"] = "index"
            case let .login(mobile, signature, code):
                params["mobile"] = mobile
                params["signature"] = signature
                params["code"] = code
                params["a"] = "index"
            case let .logout(key):
                params["key"] = key
                params["a"] = "index"
            case let .destructionInfo(key):
                params["key"] = key
                params["a"] = "index"
                params["cancel_member"] = 1
            case let .destructionCommit(key, signature):
                params["key"] = key
                params["a"] = "index"
                params["cancel_member"] = 1
                params["signature"] = signature
            case let .mySetting(key, signature):
                params["key"] = key
                params["signature"] = signature
                params["a"] = "my"
            case let .getHtmlView(key, kefu):
                params["key"] = key
                params["kefu"] = kefu
            case let .getBadge(key):
                params["key"] = key
                params["a"] = "unread"

        }
        
        switch self.method {
        case .post:
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .get:
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
