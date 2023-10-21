//
//  BaseViewController.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/20.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa
class BaseViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var titleStr:String
    private var isShowBack:Bool
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHexString("#000000")
        // 隐藏系统导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        
    }
    init(title:String,isShowBack:Bool = true) {
        self.titleStr = title
        self.isShowBack = isShowBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //创建自定义导航栏
    /// <#Description#>
    /// - Returns: <#description#>
    lazy var customNavBar: UIView = {
        let customNavBar = UIView()
        customNavBar.backgroundColor = UIColor.colorWithHexString("#000000")
        self.view.addSubview(customNavBar)

        // 添加到视图
        customNavBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(kNavBarAndStatusBarHeight)
        }
        
        // 获取状态栏高度
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        
        // 考虑状态栏的高度
        customNavBar.frame.origin.y = statusBarHeight
        
        let backButton = UIButton.init()
        customNavBar.addSubview(backButton)
        backButton.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)

        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kStatusBarHeight)
            make.leading.equalToSuperview().offset(12)
            make.width.height.equalTo(30)
        }
        backButton.isHidden = !isShowBack 
        
        let titleLab = UILabel.labelLayout(text: titleStr, font: UIFont.boldSystemFont(ofSize: 18), textColor: .white, ali: .center, isPriority: true, tag: 0)
        customNavBar.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        return customNavBar
    }()

}
