//
//  ActivityViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxCocoa
import RxSwift
class ActivityViewController: BaseViewController {
    private let selectedButtonSubject = BehaviorSubject<UIButton?>(value: nil)
    private let disposeBag = DisposeBag()
    private let calculateTextSubject = PublishSubject<String>()
    private var count = 0
    var lastClickedButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    func setUI(){
        let simpleBtn = UIButton(type: .custom)
        simpleBtn.setTitle("简单模式", for: .normal)
        simpleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        simpleBtn.backgroundColor = UIColor.colorWithHexString("#191919")
        simpleBtn.layer.cornerRadius = 10
        simpleBtn.layer.masksToBounds = true
        simpleBtn.setTitleColor(.white, for: .normal)
        view.addSubview(simpleBtn)
        simpleBtn.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(5)
            make.trailing.equalTo(view.snp.centerX).offset(-7)
            make.width.equalTo(112)
            make.height.equalTo(34)
        }
        
        let hardBtn = UIButton(type: .custom)
        hardBtn.setTitle("困难模式", for: .normal)
        hardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        hardBtn.backgroundColor = UIColor.colorWithHexString("#191919")
        hardBtn.layer.cornerRadius = 10
        hardBtn.layer.masksToBounds = true
        hardBtn.setTitleColor(.white, for: .normal)
        view.addSubview(hardBtn)
        hardBtn.snp.makeConstraints { make in
            make.top.equalTo(simpleBtn)
            make.leading.equalTo(view.snp.centerX).offset(7)
            make.width.equalTo(112)
            make.height.equalTo(34)
        }
        
        let facemanBtn = UIButton(type: .custom)
        facemanBtn.setImage(UIImage(named: "faceman"), for: .normal)
        view.addSubview(facemanBtn)
        facemanBtn.snp.makeConstraints { make in
            make.top.equalTo(simpleBtn.snp.bottom).offset(105)
            make.leading.equalToSuperview().offset(52)
            make.width.height.equalTo(75)
        }
        
        
        let facewomanBtn = UIButton(type: .custom)
        facewomanBtn.setImage(UIImage(named: "facewoman"), for: .normal)
        view.addSubview(facewomanBtn)
        facewomanBtn.snp.makeConstraints { make in
            make.top.equalTo(facemanBtn.snp.bottom).offset(100)
            make.trailing.equalToSuperview().offset(-40)
            make.width.height.equalTo(55)
        }
        
        
        let calculateLab = UILabel.labelLayout(text: "", font: UIFont.boldSystemFont(ofSize: 24), textColor: .white, ali: .center, isPriority: true, tag: 0)
        view.addSubview(calculateLab)
        calculateLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(100 + kTabBarHeight))
            make.centerX.equalToSuperview()
        }
        
        let tipLab = UILabel.labelLayout(text: "连续点中5个相同颜色的脸谱，遇见TA", font: UIFont.systemFont(ofSize: 13), textColor: .white.withAlphaComponent(0.57), ali: .center, isPriority: true, tag: 0)
        view.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-(43 + kTabBarHeight))
            make.centerX.equalToSuperview()
        }
        
        
        ///以下为交互逻辑
        // 默认选择第一个按钮
        selectedButtonSubject.onNext(simpleBtn)
        
        // 绑定简单模式按钮
        simpleBtn.rx.tap
            .bind { [weak self] in
                self?.selectButton(simpleBtn)
            }
            .disposed(by: disposeBag)
        
        // 绑定困难模式按钮
        hardBtn.rx.tap
            .bind { [weak self] in
                self?.selectButton(hardBtn)
            }
            .disposed(by: disposeBag)
        
        // 观察选中按钮的变化，改变按钮样式
        selectedButtonSubject
            .subscribe(onNext: { button in
                simpleBtn.backgroundColor = (button == simpleBtn) ? UIColor.colorWithHexString("#4272D7") : UIColor.colorWithHexString("#191919")
                hardBtn.backgroundColor = (button == hardBtn) ? UIColor.colorWithHexString("#4272D7") : UIColor.colorWithHexString("#191919")
            })
            .disposed(by: disposeBag)
        
        
        // 绑定facemanBtn的点击事件
        facemanBtn.rx.tap
            .bind { [weak self] in
                if self?.lastClickedButton != facemanBtn {
                    self?.count = 0  // 重置计数
                }
                self?.count += 1
                self?.lastClickedButton = facemanBtn
                self?.calculateTextSubject.onNext("蓝色+\(self?.count ?? 0)")
                if self?.count ?? 0 >= 5 {
                    let vc = ActivityDetailViewController(title: "", isShowBack: false)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // 绑定facewomanBtn的点击事件
        facewomanBtn.rx.tap
            .bind { [weak self] in
                if self?.lastClickedButton != facewomanBtn {
                    self?.count = 0  // 重置计数
                }
                self?.count += 1
                self?.lastClickedButton = facewomanBtn
                self?.calculateTextSubject.onNext("红色+\(self?.count ?? 0)")
                if self?.count ?? 0 >= 5 {
                    let vc = ActivityDetailViewController(title: "", isShowBack: false)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // 绑定calculateLab的文本和颜色
        calculateTextSubject
            .subscribe(onNext: { text in
                calculateLab.text = text
                calculateLab.textColor = text.starts(with: "蓝色") ? UIColor.colorWithHexString("#4272D7") : UIColor.colorWithHexString("#EC5399")
            })
            .disposed(by: disposeBag)
    }
    private func selectButton(_ button: UIButton) {
        selectedButtonSubject.onNext(button)
    }
}
