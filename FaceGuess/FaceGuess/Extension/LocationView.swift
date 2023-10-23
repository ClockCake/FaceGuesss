//
//  LocationView.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/23.
//

import UIKit
import RxSwift
class LocationView: UIView {
    private let disposeBag = DisposeBag()
    let openButtonClicked = PublishSubject<Void>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.colorWithHexString("#191919")
        let titLab = UILabel.labelLayout(text: "开启定位权限，享受周边服务", font: UIFont.systemFont(ofSize: 12), textColor: .white, ali: .left, isPriority: true, tag: 0)
        self.addSubview(titLab)
        titLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        
        let openBtn = UIButton(type: .custom)
        openBtn.setTitle("去开启", for: .normal)
        openBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        openBtn.backgroundColor = UIColor.colorWithHexString("#4272D7")
        openBtn.setTitleColor(.white, for: .normal)
        self.addSubview(openBtn)
        openBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(68)
            make.height.equalTo(28)
        }
        openBtn.layer.cornerRadius = 14
        openBtn.layer.masksToBounds = true
        openBtn.rx.tap
            .bind(to: openButtonClicked)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
