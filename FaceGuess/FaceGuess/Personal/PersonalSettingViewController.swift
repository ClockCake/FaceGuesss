//
//  PersonalSettingViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/22.
//

import UIKit
import RxSwift
class PersonalSettingViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.backgroundColor = .black
        
        let destroyBtn = UIButton(type: .custom)
        destroyBtn.backgroundColor = UIColor.colorWithHexString("#4272D7")
        destroyBtn.setTitle("注销", for: .normal)
        destroyBtn.setTitleColor(.white, for: .normal)
        destroyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        destroyBtn.layer.cornerRadius = 7
        destroyBtn.layer.masksToBounds = true
        view.addSubview(destroyBtn)
        destroyBtn.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(148)
            make.leading.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().offset(-35)
            make.height.equalTo(44)
        }
        
        let logoutBtn = UIButton(type: .custom)
        logoutBtn.backgroundColor = UIColor.colorWithHexString("#4272D7")
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.setTitleColor(.white, for: .normal)
        logoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        logoutBtn.layer.cornerRadius = 7
        logoutBtn.layer.masksToBounds = true
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { make in
            make.top.equalTo(destroyBtn.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().offset(-35)
            make.height.equalTo(44)
        }
        
        destroyBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            let alert = UIAlertController(title: "", message: "你确定要注销这个账号吗?", preferredStyle: .alert)
            
            let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { _ in
                
            }
            // 添加确定按钮
            let okButton = UIAlertAction(title: "确定", style: .default) { _ in
            }
            alert.addAction(cancelBtn)
            // 将动作按钮添加到UIAlertController中
            alert.addAction(okButton)
            
            // 展示警告对话框
            self.present(alert, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
        logoutBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            let alert = UIAlertController(title: "", message: "你确定要退出登录吗?", preferredStyle: .alert)
            
            let cancelBtn = UIAlertAction(title: "取消", style: .cancel) { _ in
                
            }
            // 添加确定按钮
            let okButton = UIAlertAction(title: "确定", style: .default) { _ in
            }
            alert.addAction(cancelBtn)
            // 将动作按钮添加到UIAlertController中
            alert.addAction(okButton)
            
            // 展示警告对话框
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        
    }
}
