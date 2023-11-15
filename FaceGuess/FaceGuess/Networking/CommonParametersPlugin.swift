//
//  CommonParametersPlugin.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/25.
//

import Moya

public struct CommonParametersPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        let model = CommonModel()
        // 公共参数
        let commonParameters: [String: Any] = ["vjrzgaf":model.version,
                                               "hlgjfb": model.client,
                                               "djvghj":model.device,
                                               "gdno":model.idfa,
                                               "djvghj_bakjf":model.device_token,
                                               "bdgd":model.tdid,
                                               "lfi":model.lng,
                                               "lob":model.lat,
                                               "appname":model.appname,
        ]

        do {
            if var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: false),
               var queryItems = urlComponents.queryItems {
                
                // 将公共参数添加到已有参数中
                for (key, value) in commonParameters {
                    let queryItem = URLQueryItem(name: key, value: "\(value)")
                    queryItems.append(queryItem)
                }

                urlComponents.queryItems = queryItems
                request.url = urlComponents.url
            } else {
                var urlComponents = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
                urlComponents?.queryItems = commonParameters.map {
                    URLQueryItem(name: $0, value: "\($1)")
                }
                request.url = urlComponents?.url
            }
        } catch {
            // 错误处理
        }

        return request
    }
}
