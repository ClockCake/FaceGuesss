//
//  BottomSheetViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxSwift
class BottomSheetViewController: UIViewController {
    var height: CGFloat
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        // 设置左上和右上角为圆角
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.colorWithHexString("#999990"), for: .normal)
        cancelBtn.backgroundColor = UIColor.colorWithHexString("#191919")
        cancelBtn.layer.cornerRadius = 22
        cancelBtn.layer.masksToBounds = true
        view.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-(kSafeHeight + 40))
        }
        cancelBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        let reportBtn = UIButton(type: .custom)
        reportBtn.setTitle("举报", for: .normal)
        reportBtn.setTitleColor(.white, for: .normal)
        reportBtn.backgroundColor = UIColor.colorWithHexString("#4272D7")
        reportBtn.layer.cornerRadius = 22
        reportBtn.layer.masksToBounds = true
        view.addSubview(reportBtn)
        reportBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(44)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-20)
        }
        
        let blockBtn = UIButton(type: .custom)
        blockBtn.setTitle("拉黑", for: .normal)
        blockBtn.setTitleColor(.white, for: .normal)
        blockBtn.backgroundColor = UIColor.colorWithHexString("#4272D7")
        blockBtn.layer.cornerRadius = 22
        blockBtn.layer.masksToBounds = true
        view.addSubview(blockBtn)
        blockBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(44)
            make.bottom.equalTo(reportBtn.snp.top).offset(-20)
        }
        
        cancelBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        reportBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            let alert = UIAlertController(title: "", message: "是否确定要举报对方", preferredStyle: .alert)
            let reportBtn = UIAlertAction(title: "举报", style: .default) { _ in
                self.dismiss(animated: true)

            }
            // 添加确定按钮
            let cancelButton = UIAlertAction(title: "取消", style: .default) { _ in
                self.dismiss(animated: true)

            }
            // 自定义按钮颜色
            reportBtn.setValue(UIColor.gray, forKey: "titleTextColor")
            // 将动作按钮添加到UIAlertController中
            alert.addAction(reportBtn)
            alert.addAction(cancelButton)
            
            // 展示警告对话框
            self.present(alert, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
        blockBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            let alert = UIAlertController(title: "", message: "拉黑后,双方无法查看\n 对方微信号", preferredStyle: .alert)
            let blockBtn = UIAlertAction(title: "拉黑", style: .default) { _ in
                self.dismiss(animated: true)

            }
            // 添加确定按钮
            let cancelButton = UIAlertAction(title: "取消", style: .default) { _ in
                self.dismiss(animated: true)

            }
            // 自定义按钮颜色
            blockBtn.setValue(UIColor.gray, forKey: "titleTextColor")
            // 将动作按钮添加到UIAlertController中
            alert.addAction(blockBtn)
            alert.addAction(cancelButton)
            
            // 展示警告对话框
            self.present(alert, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
    }
    init(height: CGFloat) {
        self.height = height
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension BottomSheetViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting, height: height)
    }
}

