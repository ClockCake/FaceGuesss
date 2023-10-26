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
    /// 验证码登录
    case login(mobile: String, signature: String,code:String)
    /// 退出登录
    case logout(key:String)
}

extension APIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://bafacegs.tongchengjianzhi.cn")!
    }
    
    var path: String {
        switch self {
            case .getSMSCode:
                return "/sign/"
            case .login:
                return "/sign/"
            case .logout:
                return "/sign/"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getSMSCode:
                return .get
            case .login:
                return .get
            case .logout:
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
            case let .login(mobile, signature, code):
                params["mobile"] = mobile
                params["signature"] = signature
                params["code"] = code
                params["a"] = "index"
            case let .logout(key):
                params["key"] = key
                params["a"] = "index"
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
