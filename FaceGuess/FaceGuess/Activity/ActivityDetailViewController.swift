//
//  ActivityDetailViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxSwift
class ActivityDetailViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHexString("#619EFF")
        customNavBar.backgroundColor = UIColor.colorWithHexString("#619EFF")
        setUI()
    }
 
    func setUI(){
        let bgView = UIView.init()
        bgView.backgroundColor = .black
        bgView.layer.cornerRadius = 16
        bgView.layer.masksToBounds = true
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
            make.top.equalTo(customNavBar.snp.bottom).offset(30)
            make.height.equalTo((556 / 812) * kScreenHeight)
        }
        
        let tipLab = UILabel.labelLayout(text: "恭喜你完成连猜\n是否要解锁TA", font: UIFont.boldSystemFont(ofSize: 18), textColor: UIColor.colorWithHexString("#EC5399"), ali: .center, isPriority: true, tag: 0)
        tipLab.numberOfLines = 0
        bgView.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        
        let unlockBtn = UIButton(type: .custom)
        unlockBtn.setTitle("解锁", for: .normal)
        unlockBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        unlockBtn.setTitleColor(.white, for: .normal)
        unlockBtn.backgroundColor = UIColor.colorWithHexString("#4272D7")
        unlockBtn.layer.cornerRadius = 10
        unlockBtn.layer.masksToBounds = true
        bgView.addSubview(unlockBtn)
        unlockBtn.snp.makeConstraints { make in
            make.top.equalTo(tipLab.snp.bottom).offset(23)
            make.trailing.equalTo(view.snp.centerX).offset(-7)
            make.width.equalTo(112)
            make.height.equalTo(34)
        }
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("不了", for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.backgroundColor = UIColor.colorWithHexString("#191919")
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.layer.masksToBounds = true
        bgView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.top.equalTo(unlockBtn)
            make.leading.equalTo(view.snp.centerX).offset(7)
            make.width.equalTo(112)
            make.height.equalTo(34)
        }
        
        let imageView = UIImageView(image: UIImage(named: "1"))
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        bgView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(cancelBtn.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(3)
            make.trailing.equalToSuperview().offset(-3)
            make.height.equalTo((331 / 812) * kScreenHeight)
        }
        
        let nameLab = UILabel.labelLayout(text: "柳青青", font: UIFont.boldSystemFont(ofSize: 26), textColor: .white, ali: .left, isPriority: true, tag: 0)
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
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
        
        cancelBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
            
        }).disposed(by: disposeBag)
    }
}
