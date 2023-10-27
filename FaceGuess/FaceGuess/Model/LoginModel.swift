//
//  LoginModel.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/26.
//

import Foundation

struct LoginModel: Codable {
    let key: String?
    let kefu: String?
    let tab: Int?
}
struct SettingModel: Codable {
    let prelogin:String?
    let full:String?
    let tab:String?
    let rank:String?
//    let box:boxModel?
}
struct boxModel: Codable {
    let url:String?
    let width:String
    let height:String
}
