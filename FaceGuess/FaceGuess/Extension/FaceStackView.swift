//
//  FaceStackView.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/22.
//

import UIKit

class FaceStackView: UIStackView {
    
    init(title: String,textItems: [(leftText: String, rightText: String)], backgroundColor: UIColor) {
        super.init(frame: .zero)
        
        // 设置StackView的属性
        self.axis = .vertical
        self.spacing = 10
        self.distribution = .fillProportionally
        self.backgroundColor = backgroundColor
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        self.addArrangedSubview(titleLabel)

        
        // 创建并添加每一行的内容
        for textItem in textItems {
            let leftLabel = UILabel()
            leftLabel.text = textItem.leftText
            leftLabel.font = UIFont.systemFont(ofSize: 14)
            leftLabel.textColor = .white
            let rightLabel = UILabel()
            rightLabel.text = textItem.rightText
            rightLabel.textColor = .white
            rightLabel.font = UIFont.systemFont(ofSize: 14)

            let rowStackView = UIStackView(arrangedSubviews: [leftLabel, rightLabel])
            rowStackView.axis = .horizontal
//            rowStackView.spacing = 15
//            rowStackView.distribution = .fillEqually
            
            self.addArrangedSubview(rowStackView)
        }
        // 添加约束以定义CustomStackView的边距
        self.layoutMargins = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        self.isLayoutMarginsRelativeArrangement = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

