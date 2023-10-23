//
//  CountdownButton.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxSwift
import RxCocoa

class CountdownButton: UIButton {
    private var timer: Timer?
    private var countdown: Int = 60
    private let disposeBag = DisposeBag()
    
    func startCountdown() {
        // 保存原始样式
        let originalTitle = title(for: .normal)
        let originalBorderColor = layer.borderColor
        
        // 更新UI为倒计时样式
        layer.borderWidth = 0
        
        // 创建和启动定时器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.countdown -= 1
            if self.countdown <= 0 {
                // 倒计时结束，恢复原始样式
                self.timer?.invalidate()
                self.timer = nil
                self.countdown = 60
                self.setTitle(originalTitle, for: .normal)
                self.layer.borderWidth = 1
                self.layer.borderColor = originalBorderColor
            } else {
                // 更新倒计时显示
                self.setTitle("\(self.countdown)s", for: .normal)
            }
        }
    }
    
    // 释放定时器资源
    deinit {
        timer?.invalidate()
    }
}
