//
//  LoginViewController.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/20.
//

import RxSwift
import UIKit
class LoginViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    func setUI(){
        let tipLab = UILabel.labelLayout(text: "手机号注册/登录", font: UIFont.boldSystemFont(ofSize: 20), textColor: .white, ali: .left, isPriority: true, tag: 0)
        self.view.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(30)
        }
        
        let phoneView = UIView.init()
        phoneView.layer.cornerRadius = 23
        phoneView.layer.masksToBounds = true
        phoneView.backgroundColor = UIColor.colorWithHexString("#191919")
        self.view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(tipLab.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(46)
        }
        
        let passwordView = UIView.init()
        passwordView.layer.cornerRadius = 23
        passwordView.layer.masksToBounds = true
        passwordView.backgroundColor = UIColor.colorWithHexString("#191919")
        self.view.addSubview(passwordView)
        passwordView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(46)
        }
        
        
    }
}

