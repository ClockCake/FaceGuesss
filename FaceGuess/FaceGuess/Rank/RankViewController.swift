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
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kStatusBarHeight)
        }
        customNavBar.isHidden = true

    }
}
