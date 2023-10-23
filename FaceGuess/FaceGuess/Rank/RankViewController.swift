//
//  RankViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
class RankViewController: WebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
            make.bottom.equalToSuperview().offset(-(kTabBarHeight))
        }
        customNavBar.isHidden = true

    }
}
