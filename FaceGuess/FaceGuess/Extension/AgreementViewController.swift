//
//  AgreementView.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/27.
//

import Foundation
import UIKit
import RxSwift
import PKHUD
class AgreementViewController: UIViewController {
    var height: CGFloat
    private let disposeBag = DisposeBag()
    var currentNavController: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray

        let contentView = UIView()
        contentView.backgroundColor = .black
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
        // 设置左上和右上角为圆角
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("拒绝", for: .normal)
        cancelBtn.setTitleColor(UIColor.colorWithHexString("#999990"), for: .normal)
        cancelBtn.backgroundColor = UIColor.colorWithHexString("#191919")
        cancelBtn.layer.cornerRadius = 22
        cancelBtn.layer.masksToBounds = true
        contentView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-(kSafeHeight + 40))
        }
        cancelBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            // 显示文本
            HUD.flash(.label("拒绝协议将无法继续使用此APP"), delay: 2.0)
        }).disposed(by: disposeBag)
        
        let agreeBtn = UIButton(type: .custom)
        agreeBtn.setTitle("同意", for: .normal)
        agreeBtn.setTitleColor(.white, for: .normal)
        agreeBtn.backgroundColor = UIColor.colorWithHexString("#4272D7")
        agreeBtn.layer.cornerRadius = 22
        agreeBtn.layer.masksToBounds = true
        contentView.addSubview(agreeBtn)
        agreeBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(44)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-20)
        }
        
        let titLab = UILabel.labelLayout(text: "服务协议和隐私政策", font: UIFont.boldSystemFont(ofSize: 18), textColor: .white, ali: .center, isPriority: true, tag: 0)
        contentView.addSubview(titLab)
        titLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        let contentLab = UILabel.labelLayout(text: "请你务必审慎阅读、充分理解“隐私政策”各条款，包括但不限于：为了更好的向你提供服务，我们需要收集你的设备标识、操作日志等信息用于分析、优化应用性能。", font: UIFont.systemFont(ofSize: 15), textColor: .white, ali: .left, isPriority: true, tag: 0)
        contentLab.numberOfLines = 0
        contentView.addSubview(contentLab)
        contentLab.snp.makeConstraints { make in
            make.top.equalTo(titLab.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        let textView = UITextView()
        textView.delegate = self
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        contentView.addSubview(textView)
        let attributedString = NSMutableAttributedString(
            string: "你可阅读 《用户协议》《隐私政策》了解详细信息。如果你同意，请点击下面按钮开始接受我们的服务。",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 15)
            ]
        )

        let userAgreementRange = (attributedString.string as NSString).range(of: "《用户协议》")
        let privacyPolicyRange = (attributedString.string as NSString).range(of: "《隐私政策》")

        attributedString.setAttributes([
            .foregroundColor: UIColor.colorWithHexString("#4272D7"),
            .font:UIFont.systemFont(ofSize: 15),
            .link: NSURL(string: "userAgreement://")!
        ], range: userAgreementRange)

        attributedString.setAttributes([
            .foregroundColor: UIColor.colorWithHexString("#4272D7"),
            .font:UIFont.systemFont(ofSize: 15),
            .link: NSURL(string: "privacyPolicy://")!
        ], range: privacyPolicyRange)

        textView.attributedText = attributedString
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(contentLab.snp.bottom).offset(24)
        }
        
        agreeBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            UserManager.shared.isAccpetAgree = true
            self.dismiss(animated: true)
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
extension AgreementViewController: UIViewControllerTransitioningDelegate,UITextViewDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting, height: height)
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "userAgreement" {
            // Push to User Agreement View Controller
            let userAgreementVC = WebViewController.init(title: "用户协议",  url: "https://www.baidu.com")
            currentNavController?.pushViewController(userAgreementVC, animated: true)
            return false
        } else if URL.scheme == "privacyPolicy" {
            // Push to Privacy Policy View Controller
            let privacyPolicyVC = WebViewController.init(title: "隐私政策",  url: "https://www.apple.com")
            currentNavController?.pushViewController(privacyPolicyVC, animated: true)
            return false
        }

        return true
    }
}
