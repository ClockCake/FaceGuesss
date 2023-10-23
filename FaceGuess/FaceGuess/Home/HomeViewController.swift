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
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationView.isHidden = false
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // 用户尚未做出选择
            print("Location permission not determined.")
            locationManager.requestWhenInUseAuthorization() // 请求权限
        case .restricted:
            // 由于活动限制或家长控制等原因，应用不被允许使用定位服务
            print("Location permission restricted.")
        case .denied:
            // 用户拒绝了访问地理位置的权限或者定位服务全局被关闭
            print("Location permission denied.")
        case .authorizedAlways:
            // 用户允许应用在前台和后台都能获取地理位置数据
            self.locationView.isHidden = true
            print("Location permission authorized always.")
        case .authorizedWhenInUse:
            // 用户允许应用在使用期间访问地理位置数据
            self.locationView.isHidden = true
            print("Location permission authorized when in use.")
        @unknown default:
            // 其他未知的情况
            print("Unknown location permission.")
        }
    }
}
extension HomeViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // 用户尚未做出选择
                self.locationView.isHidden = false
        case .restricted, .denied:
            // 用户拒绝授权或者受到限制
                self.locationView.isHidden = false
        case .authorizedAlways, .authorizedWhenInUse:
            // 用户允许授权
            // 在这里更新你的UI
                self.locationView.isHidden = true
        @unknown default:
                self.locationView.isHidden = false
            // 其他未知情况
        }
    }

}
