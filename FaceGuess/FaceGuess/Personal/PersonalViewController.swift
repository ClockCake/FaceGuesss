//
//  PersonalViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxSwift
import StoreKit
class PersonalViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    func setUI(){
        let baseInfo = UIView.init()
        view.addSubview(baseInfo)
        baseInfo.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        let avatorBtn = UIImageView(image: UIImage(named: "2"))
        avatorBtn.layer.cornerRadius = 30
        avatorBtn.layer.masksToBounds = true
        baseInfo.addSubview(avatorBtn)
        avatorBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(60)
        }
        
        let nameLab = UILabel.labelLayout(text: "廖积奎", font: UIFont.boldSystemFont(ofSize: 20), textColor: .white, ali: .left, isPriority: true, tag: 0)
        baseInfo.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.leading.equalTo(avatorBtn.snp.trailing).offset(17)
            make.top.equalTo(avatorBtn).offset(5)
        }
        
        let iv = UIImageView(image: UIImage(named: "man"))
        baseInfo.addSubview(iv)
        iv.snp.makeConstraints { make in
            make.centerY.equalTo(nameLab)
            make.leading.equalTo(nameLab.snp.trailing).offset(8)
            make.width.height.equalTo(17)
        }
        
        let phoneLab = UILabel.labelLayout(text: "135****4480", font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexString("#999999"), ali: .left, isPriority: true, tag: 0)
        baseInfo.addSubview(phoneLab)
        phoneLab.snp.makeConstraints { make in
            make.top.equalTo(nameLab.snp.bottom).offset(8)
            make.leading.equalTo(nameLab)
        }
        
        let arrowImage = UIImage(systemName: "chevron.right")
        let arrow = UIImageView(image: arrowImage)
        arrow.tintColor = .white
        baseInfo.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        
        let declarationLab = UILabel.labelLayout(text: "千山万水，无数黑夜，等一轮明月", font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexString("#AFAFAF"), ali: .center, isPriority: true, tag: 0)
        declarationLab.layer.borderWidth = 1
        declarationLab.layer.borderColor = UIColor.colorWithHexString("#191919").cgColor
        declarationLab.layer.cornerRadius = 10
        declarationLab.layer.masksToBounds = true
        view.addSubview(declarationLab)
        declarationLab.snp.makeConstraints { make in
            make.top.equalTo(baseInfo.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(44)
        }
        
        let arrowImage1 = UIImage(systemName: "chevron.right")
        let arrowRight = UIImageView(image: arrowImage1)
        arrowRight.tintColor = .white
        declarationLab.addSubview(arrowRight)
        arrowRight.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
        
        let textItems: [(leftText: String, rightText: String)] = [
            ("成功次数", "6次"),
            ("成功率", "69%"),
            ("目前排名", "234")
        ]

        let facemanView = FaceStackView(title:"脸猜",textItems: textItems, backgroundColor: UIColor.colorWithHexString("#3F6CCB"))
        facemanView.layer.cornerRadius = 10
        facemanView.layer.masksToBounds = true
        facemanView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(facemanView)

        // 添加约束以定义CustomStackView的位置和大小
        view.addSubview(facemanView)
        facemanView.snp.makeConstraints { make in
            make.top.equalTo(declarationLab.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(168)
            make.height.equalTo(160)
        }

        let faceWomemView = FaceStackView(title:"连猜",textItems: textItems, backgroundColor: UIColor.colorWithHexString("#EC5399"))
        faceWomemView.layer.cornerRadius = 10
        faceWomemView.layer.masksToBounds = true
        faceWomemView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(faceWomemView)

        // 添加约束以定义CustomStackView的位置和大小
        view.addSubview(faceWomemView)
        faceWomemView.snp.makeConstraints { make in
            make.top.equalTo(declarationLab.snp.bottom).offset(22)
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(168)
            make.height.equalTo(160)
        }

        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        stackView.backgroundColor = UIColor.colorWithHexString("#191919")
        view.addSubview(stackView)
        
        let titles = ["用户协议", "隐私协议", "应用评分", "系统设置"]
        let icons = ["UserAgreement","PrivacyAgreement","star","setting"]
        for (index, (title, icon)) in zip(titles, icons).enumerated() {
            let button = createButton(title: title, icon: icon)
            button.tag = 100 + index
            stackView.addArrangedSubview(button)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(facemanView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(103)
        }
        
        let placeholderLab = UILabel.labelLayout(text: "官方客服", font: UIFont.systemFont(ofSize: 14), textColor: .white, ali: .center, isPriority: true, tag: 0)
        view.addSubview(placeholderLab)
        placeholderLab.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        let callBtn = UIButton(type: .custom)
        callBtn.setTitle("010-05938843", for: .normal)
        callBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        callBtn.setTitleColor(UIColor.colorWithHexString("#3F6CCB"), for: .normal)
        view.addSubview(callBtn)
        callBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(placeholderLab.snp.bottom).offset(5)
        }
        callBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            if let url = URL(string: "tel://010-05938843"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    func createButton(title: String, icon: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.colorWithHexString("#666666"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        let image = UIImage(named: icon)?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // 调整图像和文字的位置
        let spacing: CGFloat = 10.0
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -image!.size.width, bottom: -(image!.size.height + spacing), right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: -(button.titleLabel!.intrinsicContentSize.height + spacing), left: 0, bottom: 0, right: -button.titleLabel!.intrinsicContentSize.width)
        
        return button
    }

    @objc func buttonTapped(sender: UIButton) {
        print("\(sender.currentTitle ?? "") button tapped")
        switch sender.tag {
        case 100:
            let userAgreementVC = WebViewController.init(title: "用户协议",  url: "https://www.baidu.com")
            self.navigationController?.pushViewController(userAgreementVC, animated: true)
        case 101:
            let privacyPolicyVC = WebViewController.init(title: "隐私政策",  url: "https://www.apple.com")
            self.navigationController?.pushViewController(privacyPolicyVC, animated: true)
        case 102:
            SKStoreReviewController.requestReview()
            ///上架后可切换下面这个
//            if let appStoreURL = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID?action=write-review"),
//               UIApplication.shared.canOpenURL(appStoreURL) {
//                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
//            }
        case 103:
            let privacyPolicyVC = PersonalSettingViewController(title: "系统设置", isShowBack: true)
            self.navigationController?.pushViewController(privacyPolicyVC, animated: true)
        default: break
            
        }
        
    }
}
