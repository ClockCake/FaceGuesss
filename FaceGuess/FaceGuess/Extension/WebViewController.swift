//
//  WebViewController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import WebKit
class WebViewController: BaseViewController {
    private var requestUrl: String
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadRequest()
    }
    
    private func setupWebView() {
        // 初始化 WKWebView
        webView = WKWebView(frame: .zero)
        webView.navigationDelegate = self  // 设置导航代理，如果需要
        webView.isOpaque = false
        webView.backgroundColor = .clear  // 设置背景色为透明
        // 添加 WKWebView 到视图层次结构
        view.addSubview(webView)
        
        // 使用 Auto Layout 来设置 WKWebView 的约束
//        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(customNavBar.snp.bottom)
        }
    }
    
    private func loadRequest() {
        // 根据提供的 URL 字符串创建 URL 请求
        if let url = URL(string: requestUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    init(title: String, isShowBack: Bool = true, url: String) {
        self.requestUrl = url
        super.init(title: title, isShowBack: isShowBack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 可选：实现 WKNavigationDelegate 方法来处理网页加载事件
extension WebViewController: WKNavigationDelegate {
    // 例如：在网页开始加载时显示活动指示器
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 显示活动指示器
    }
    
    // 例如：在网页加载完成时隐藏活动指示器
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 隐藏活动指示器

    }
 

    // ... 其他 WKNavigationDelegate 方法 ...
}
