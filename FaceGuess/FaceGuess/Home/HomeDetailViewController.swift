//
//  HomeDetailViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxSwift
class HomeDetailViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.backgroundColor = .black
        setUI()
    }
    func setUI(){
        let imageView = UIImageView(image: UIImage(named: "2"))
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(customNavBar.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo((343 / 812) * kScreenHeight )
        }
        
        let nameLab = UILabel.labelLayout(text: "柳青青", font: UIFont.boldSystemFont(ofSize: 26), textColor: UIColor.colorWithHexString("#E6E6E6"), ali: .left, isPriority: true, tag: 0)
        view.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        
        let ageView = UIView.init()
        ageView.backgroundColor = UIColor.colorWithHexString("#EC5399")
        ageView.layer.cornerRadius = 6.5
        ageView.layer.masksToBounds = true
        view.addSubview(ageView)
        ageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(nameLab)
            make.width.equalTo(32)
            make.height.equalTo(13)
        }
        
        let iv = UIImageView.init(image: UIImage(named: "woman"))
        ageView.addSubview(iv)
        iv.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
            make.width.height.equalTo(8)
            make.centerY.equalToSuperview()
        }
        
        let ageLab = UILabel.labelLayout(text: "27", font: UIFont.systemFont(ofSize: 9), textColor: .white, ali: .center, isPriority: true, tag: 0)
        ageView.addSubview(ageLab)
        ageLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-6)
        }
        
        let addressLab = UILabel.labelLayout(text: "北京 · 朝阳区", font: UIFont.systemFont(ofSize: 13), textColor: UIColor.colorWithHexString("#D7D7D7"), ali: .left, isPriority: true, tag: 0)
        view.addSubview(addressLab)
        addressLab.snp.makeConstraints { make in
            make.top.equalTo(nameLab.snp.bottom).offset(10)
            make.leading.equalTo(nameLab)
        }
        
        // 创建一个按钮并设置其类型为系统按钮
        let moreButton = UIButton(type: .system)
         
         // 使用系统的 "ellipsis" 图片作为按钮的图标
        if let moreImage = UIImage(systemName: "ellipsis") {
            moreButton.setImage(moreImage, for: .normal)
        }
        moreButton.tintColor = UIColor.white

        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(addressLab)
         
        }
        
        // 创建一个空的 UIStackView
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5 // 设置每个Label之间的间距为5

        
        // 要显示的文本数组
        let texts = ["狮子座", "单身", "超级超级温柔"]
        
        // 为每一个文本创建一个 UILabel 并添加到 UIStackView
        for text in texts {
            let label = UILabel()
            label.text = text
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 10)
            label.backgroundColor = UIColor.colorWithHexString("#4272D7")
            label.textAlignment = .center
            
            // 计算文本宽度并设置标签的尺寸
            let textSize = label.sizeThatFits(CGSize(width: 0, height: 18))
            label.layer.cornerRadius = 9
            label.layer.masksToBounds = true
            
            stackView.addArrangedSubview(label)
            label.snp.makeConstraints { make in
                make.width.equalTo(textSize.width + 16)
                make.height.equalTo(18)
            }
        }
        
        // 配置StackView的属性
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 将StackView添加到主视图
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(addressLab.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
   
        let introduceLab = UILabel.labelLayout(text: "交友宣言\n千山万水，无数黑夜，等一轮明月", font: UIFont.systemFont(ofSize: 14), textColor: UIColor.colorWithHexString("#999999"), ali: .center, isPriority: true, tag: 0)
        introduceLab.numberOfLines = 0
        introduceLab.layer.cornerRadius = 10
        introduceLab.layer.masksToBounds = true
        introduceLab.layer.borderWidth = 1.0
        introduceLab.layer.borderColor = UIColor.colorWithHexString("#191919").cgColor
        view.addSubview(introduceLab)
        introduceLab.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(81)
        }
        
        let wechatBtn = UIButton(type: .custom)
        wechatBtn.backgroundColor = UIColor.colorWithHexString("#04B029")
        wechatBtn.setTitle("查看微信号", for: .normal)
        wechatBtn.setTitleColor(.white, for: .normal)
        view.addSubview(wechatBtn)
        wechatBtn.snp.makeConstraints { make in
            make.top.equalTo(introduceLab.snp.bottom).offset(43)
            make.leading.equalToSuperview().offset(60)
            make.trailing.equalToSuperview().offset(-60)
            make.height.equalTo(44)
        }
        
        wechatBtn.layer.cornerRadius = 10
        wechatBtn.layer.masksToBounds = true
        
        wechatBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            let alert = UIAlertController(title: "", message: "对方的微信号是\n love1266520", preferredStyle: .alert)
            
            
            let cancelBtn = UIAlertAction(title: "关闭", style: .cancel) { _ in
                
            }
            // 添加确定按钮
            let okButton = UIAlertAction(title: "复制", style: .default) { _ in
                let textToCopy = "love1266520"
                UIPasteboard.general.string = textToCopy
            }
            cancelBtn.setValue(UIColor.gray, forKey: "titleTextColor")

            // 将动作按钮添加到UIAlertController中
            alert.addAction(cancelBtn)
            alert.addAction(okButton)
            
            // 展示警告对话框
            self.present(alert, animated: true, completion: nil)
            
        }).disposed(by: disposeBag)
        
        moreButton.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            let bottomSheetVC = BottomSheetViewController(height: 300)
            bottomSheetVC.modalPresentationStyle = .custom
            bottomSheetVC.transitioningDelegate = bottomSheetVC
            self.present(bottomSheetVC, animated: true, completion: nil)

        }).disposed(by: disposeBag)
        

    }
}
