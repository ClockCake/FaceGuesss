//
//  HomeShowViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxSwift
class HomeShowViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHexString("#619EFF")
        customNavBar.backgroundColor = UIColor.colorWithHexString("#619EFF")
        setUI()
    }
    func setUI(){
        let bgView = UIView.init()
        bgView.backgroundColor = UIColor.colorWithHexString("#000000")
        bgView.layer.cornerRadius = 16
        bgView.layer.masksToBounds = true
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.top.equalTo(customNavBar.snp.bottom).offset(50)
            make.height.equalTo(550)
        }
        
        let imageView = UIImageView(image: UIImage(named: "2"))
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        bgView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(3)
            make.trailing.equalToSuperview().offset(-3)
            make.height.equalTo(331)
        }
        
        let nameLab = UILabel.labelLayout(text: "柳青青", font: UIFont.boldSystemFont(ofSize: 26), textColor: UIColor.colorWithHexString("#E6E6E6"), ali: .left, isPriority: true, tag: 0)
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        
        let ageView = UIView.init()
        ageView.backgroundColor = UIColor.colorWithHexString("#EC5399")
        ageView.layer.cornerRadius = 6.5
        ageView.layer.masksToBounds = true
        bgView.addSubview(ageView)
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
        bgView.addSubview(addressLab)
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

        bgView.addSubview(moreButton)
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
        bgView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(addressLab.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        
        
        let detailBtn = UIButton(type: .custom)
        detailBtn.backgroundColor = UIColor.colorWithHexString("#4272D7")
        detailBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        detailBtn.layer.cornerRadius = 22
        detailBtn.layer.masksToBounds = true
        detailBtn.setTitle("查看详情", for: .normal)
        detailBtn.setTitleColor(.white, for: .normal)
        bgView.addSubview(detailBtn)
        detailBtn.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.layer.cornerRadius = 15
        closeBtn.layer.masksToBounds = true
        closeBtn.backgroundColor = UIColor.colorWithHexString("#191919")
        view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.top).offset(-15)
            make.trailing.equalTo(bgView.snp.trailing).offset(10)
            make.width.height.equalTo(30)
        }
        /// 以下为改页面的交互逻辑
        closeBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
            
        }).disposed(by: disposeBag)
        
        moreButton.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            let bottomSheetVC = BottomSheetViewController(height: 300)
            bottomSheetVC.modalPresentationStyle = .custom
            bottomSheetVC.transitioningDelegate = bottomSheetVC
            self.present(bottomSheetVC, animated: true, completion: nil)

        }).disposed(by: disposeBag)
        
        
        detailBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return  }
            let vc = HomeDetailViewController(title: "用户详情", isShowBack: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
    }
}
