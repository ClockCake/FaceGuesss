//
//  APIService.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/25.
//


import Moya

enum APIService {
    case getSMSCode(mobile: String, signature: String)
}

extension APIService: TargetType {
    var baseURL: URL {
        return URL(string: "https://bafacegs.tongchengjianzhi.cn")!
    }
    
    var path: String {
        switch self {
        case .getSMSCode:
            return "/sign/?a=index"
        // ... 其他API
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSMSCode:
            return .post
        // ... 其他API
        }
    }
    
    var task: Task {
        switch self {
        case let .getSMSCode(mobile, signature):
                // 请求参数
                var params: [String: Any] = [:]
                params["mobile"] = mobile
                params["signature"] = signature
            
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        // ... 其他API
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
