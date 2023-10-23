//
//  TextDislogVIew.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/23.
//

import UIKit

class TextDislogView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "修改昵称"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入昵称"
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 10.0
        tf.layer.masksToBounds = true
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("保存", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onSave: ((String) -> Void)? // 定义闭包

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.layer.cornerRadius = 10.0
        self.backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(confirmButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    @objc private func confirmButtonTapped() {
        // 使用闭包传回输入值
        onSave?(textField.text ?? "")
        // 这里处理按钮点击事件，例如关闭弹框
        self.removeFromSuperview()
    }
}

