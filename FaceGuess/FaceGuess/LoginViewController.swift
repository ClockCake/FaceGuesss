//
//  LoginViewController.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/20.
//

import RxSwift
import UIKit
import RxCocoa
class LoginViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    // 创建 BehaviorRelay 实例来跟踪输入框和选择按钮的状态
    private let isPhoneValid = BehaviorRelay(value: false)
    private let isPasswordValid = BehaviorRelay(value: false)
    private let isButtonSelected = BehaviorRelay(value: false)
    private let viewModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    func setUI(){
        let tipLab = UILabel.labelLayout(text: "手机号注册/登录", font: UIFont.boldSystemFont(ofSize: 20), textColor: .white, ali: .left, isPriority: true, tag: 0)
        self.view.addSubview(tipLab)
        tipLab.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(30)
        }
        
        let phoneView = UIView.init()
        phoneView.layer.cornerRadius = 23
        phoneView.layer.masksToBounds = true
        phoneView.backgroundColor = UIColor.colorWithHexString("#191919")
        self.view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(tipLab.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(46)
        }
        let userImageView = UIImageView(image: UIImage(named: "user"))
        phoneView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(18)
        }
        
        let phoneTF = UITextField.init()
        phoneTF.keyboardType = .namePhonePad
        phoneTF.tag = 101
        phoneTF.delegate = self
        let placeholderText = NSAttributedString(string: "请输入手机号", attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#A3A3A3")])
        phoneTF.attributedPlaceholder = placeholderText
        phoneTF.textColor = .white
        phoneTF.font = UIFont.systemFont(ofSize: 16 )
        phoneTF.textAlignment = .left
        phoneTF.borderStyle = .none
        phoneView.addSubview(phoneTF)
        phoneTF.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        let passwordView = UIView.init()
        passwordView.layer.cornerRadius = 23
        passwordView.layer.masksToBounds = true
        passwordView.backgroundColor = UIColor.colorWithHexString("#191919")
        self.view.addSubview(passwordView)
        passwordView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(46)
        }
        
        let passwordImageView = UIImageView(image: UIImage(named: "password"))
        passwordView.addSubview(passwordImageView)
        passwordImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(18)
        }
        
        let passwordTF = UITextField.init()
        passwordTF.delegate = self
        passwordTF.tag = 102
        passwordTF.keyboardType = .namePhonePad
        let placeholderText1 = NSAttributedString(string: "输入验证码", attributes: [NSAttributedString.Key.foregroundColor : UIColor.colorWithHexString("#A3A3A3")])
        passwordTF.attributedPlaceholder = placeholderText1
        passwordTF.textColor = .white
        passwordTF.font = UIFont.systemFont(ofSize: 16 )
        passwordTF.textAlignment = .left
        passwordTF.borderStyle = .none
        passwordView.addSubview(passwordTF)
        passwordTF.snp.makeConstraints { make in
            make.leading.equalTo(passwordImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        let getCodeBtn = CountdownButton(type: .custom)
        getCodeBtn.setTitle("获取验证码", for: .normal)
        getCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        getCodeBtn.setTitleColor(UIColor.colorWithHexString("#4272D7"), for: .normal)
        getCodeBtn.layer.borderWidth = 1
        getCodeBtn.layer.borderColor = UIColor.colorWithHexString("#4272D7").cgColor
        getCodeBtn.layer.cornerRadius = 16
        getCodeBtn.layer.masksToBounds = true
        passwordView.addSubview(getCodeBtn)
        getCodeBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(91)
            make.height.equalTo(32)
        }
        
        let selBtn = UIButton(type: .custom)
        selBtn.isSelected = false
        selBtn.setImage(UIImage(named: "noSelect"), for: .normal)
        self.view.addSubview(selBtn)
        selBtn.snp.makeConstraints { make in
            make.leading.equalTo(phoneView).offset(10)
            make.top.equalTo(passwordView.snp.bottom).offset(35)
            make.width.height.equalTo(16)
        }

        
        let textView = UITextView()
        textView.delegate = self
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        self.view.addSubview(textView)

        textView.snp.makeConstraints { make in
            make.leading.equalTo(selBtn.snp.trailing).offset(6)
            make.centerY.equalTo(selBtn)
            make.trailing.equalToSuperview().offset(-16)
        }
        let attributedString = NSMutableAttributedString(
            string: "同意《用户协议》和《隐私政策》",
            attributes: [
                .foregroundColor: UIColor.colorWithHexString("#9D9D9D"),
                .font: UIFont.systemFont(ofSize: 12)
            ]
        )

        let userAgreementRange = (attributedString.string as NSString).range(of: "《用户协议》")
        let privacyPolicyRange = (attributedString.string as NSString).range(of: "《隐私政策》")

        attributedString.setAttributes([
            .foregroundColor: UIColor.colorWithHexString("#4272D7"),
            .link: NSURL(string: "userAgreement://")!
        ], range: userAgreementRange)

        attributedString.setAttributes([
            .foregroundColor: UIColor.colorWithHexString("#4272D7"),
            .link: NSURL(string: "privacyPolicy://")!
        ], range: privacyPolicyRange)

        textView.attributedText = attributedString
        
        
        let loginBtn = UIButton.init(type: .custom)
        loginBtn.backgroundColor = UIColor.colorWithHexString("#4272D7").withAlphaComponent(0.3)
        loginBtn.isUserInteractionEnabled = false
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginBtn.layer.cornerRadius = 27
        loginBtn.layer.masksToBounds = true
        self.view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(54)
        }

        /// 以下为交互逻辑
        selBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            selBtn.isSelected = !selBtn.isSelected
            if selBtn.isSelected {
                selBtn.setImage(UIImage(named: "select"), for: .normal)
            }else{
                selBtn.setImage(UIImage(named: "noSelect"), for: .normal)
            }
            
        }).disposed(by: disposeBag)
        
        
        getCodeBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            getCodeBtn.startCountdown()
            let hh = self.viewModel.getSignatureTime()
            self.viewModel.RequestSMSCode(mobile: phoneTF.text ?? "", signature: self.viewModel.md5(string: "bafacegs\(hh)"))
                .subscribe(onNext: { response in
                    print("Success:", response)
                }, onError: { error in
                    print("Error:", error)
                })
                .disposed(by: self.disposeBag)

        }).disposed(by: disposeBag)
        
        // 监听 phoneTF 和 passwordTF 的文本更改，并更新 isPhoneValid 和 isPasswordValid
        phoneTF.rx.text.orEmpty
            .map { $0.count == 11 }
            .bind(to: isPhoneValid)
            .disposed(by: disposeBag)

        passwordTF.rx.text.orEmpty
            .map { $0.count == 5 }
            .bind(to: isPasswordValid)
            .disposed(by: disposeBag)

        // 监听 selBtn 的点击事件，并更新 isButtonSelected
        selBtn.rx.tap
            .map { [weak selBtn] in selBtn?.isSelected ?? false }
            .bind(to: isButtonSelected)
            .disposed(by: disposeBag)

        // 组合 isPhoneValid, isPasswordValid, 和 isButtonSelected 的状态
        Observable.combineLatest(isPhoneValid, isPasswordValid, isButtonSelected) { $0 && $1 && $2 }
            .bind { [weak loginBtn] isValid in
                loginBtn?.isUserInteractionEnabled = isValid
                loginBtn?.backgroundColor = isValid ? UIColor.colorWithHexString("#4272D7") : UIColor.colorWithHexString("#4272D7").withAlphaComponent(0.3)
            }
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            let hh = self.viewModel.getSignatureTime()
            self.viewModel.loginRequest(mobile: phoneTF.text ?? "", signature: self.viewModel.md5(string: "bafacegs\(hh)"), code: passwordTF.text ?? "")
                .withUnretained(self)
                .subscribe(onNext: { response in
                    UserManager.shared.key = response.1.key
                    UserManager.shared.kefu = response.1.kefu
                    UserManager.shared.tab = response.1.tab
                    // 创建 MainTabController 实例
                    let mainTabController = MainTabController()
                    // 设置 mainTabController 为 UIWindow 的根视图控制器
                    UIApplication.shared.windows.first?.rootViewController = mainTabController
                    self.getBadgeSession()
                }, onError: { error in
                    
                }).disposed(by: self.disposeBag)

        }).disposed(by: disposeBag)

  
    }
    
}

extension LoginViewController : UITextViewDelegate,UITextFieldDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "userAgreement" {
            // Push to User Agreement View Controller
            let userAgreementVC = WebViewController.init(title: "用户协议",  url: "https://www.baidu.com")
            self.navigationController?.pushViewController(userAgreementVC, animated: true)
            return false
        } else if URL.scheme == "privacyPolicy" {
            // Push to Privacy Policy View Controller
            let privacyPolicyVC = WebViewController.init(title: "隐私政策",  url: "https://www.apple.com")
            self.navigationController?.pushViewController(privacyPolicyVC, animated: true)
            return false
        }

        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        if textField.tag == 101 {
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= 11 && updatedText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
        else{
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            // 检查输入的字符是否都是数字
            let isNumeric = string.isEmpty || (Int(string) != nil)
            
            // 检查输入的字符长度是否不超过6位
            let isNewLengthValid = prospectiveText.count <= 6
            
            return isNumeric && isNewLengthValid
        }

    }
    /// 获取Badge值并设置
    func getBadgeSession(){
        self.viewModel.getUnReadRequest(key: UserManager.shared.key ?? "")
            .withUnretained(self)
            .subscribe(onNext: { sender in
                UIApplication.shared.applicationIconBadgeNumber = sender.1["unread"] ?? 0
            })
            .disposed(by: disposeBag)
    }

}
