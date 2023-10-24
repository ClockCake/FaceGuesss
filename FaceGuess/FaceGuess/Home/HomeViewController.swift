//
//  HomeViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxSwift
import CoreLocation

class HomeViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private var locationView:LocationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let locationView = LocationView(frame: .zero)
        self.view.addSubview(locationView)
        locationView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        locationView.openButtonClicked.withUnretained(self).subscribe(onNext: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        }).disposed(by: disposeBag)
        self.locationView = locationView

        let gridView = FourGridImageView()
        self.view.addSubview(gridView)
        gridView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(customNavBar.snp.bottom).offset(100)
            make.width.height.equalTo(188 * 2)
        }
        
        // 设置点击回调
        gridView.didSelectImageView = { index in
            print("点击了第\(index)张图片")
            if index == 1 {
                let vc = HomeShowViewController(title: "",isShowBack: false)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let alert = UIAlertController(title: "", message: "在线用户有点多哦\n 请稍后再试", preferredStyle: .alert)
                
                // 添加确定按钮
                let okButton = UIAlertAction(title: "好的", style: .default) { _ in
                    print("确定按钮被点击")
                }
                
                // 将动作按钮添加到UIAlertController中
                alert.addAction(okButton)
                
                // 展示警告对话框
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let tipLab = UILabel.labelLayout(text: "点击你认为图片应该所在的位置\n 正确即可解锁TA", font: UIFont.boldSystemFont(ofSize: 13), textColor: .white.withAlphaComponent(0.57), ali: .center, isPriority: true, tag: 0)
        tipLab.numberOfLines = 0
        view.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.top.equalTo(gridView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        PermissionManager.shared.locationPermissionSubject.subscribe(onNext: { [weak self] isAuthorized in
            // 更新UI
            DispatchQueue.main.async { [weak self] in
                self?.locationView.isHidden = isAuthorized
            }
        }).disposed(by: disposeBag)
    }


}

