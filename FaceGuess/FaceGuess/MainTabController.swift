//
//  MainTabController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxSwift
class MainTabController: UITabBarController {
    private var thirdVC:RankViewController!
    private let viewModel = ViewModel()
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBar.isTranslucent = false

        // 创建各个页面的UIViewController
        let firstVC =  HomeViewController(title: "",isShowBack: false)
        let secondVC = ActivityViewController(title: "",isShowBack: false)
        let thirdVC = RankViewController(title: "", isShowBack: false, url: "")
        let fourthVC = PersonalViewController(title: "",isShowBack: false)
        
        // 为UIViewController设置标题、图标等
        let clearImage = UIImage()

        firstVC.tabBarItem = UITabBarItem(title: "脸猜", image: clearImage.withRenderingMode(.alwaysOriginal), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "连猜", image: clearImage.withRenderingMode(.alwaysOriginal), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "榜单", image: clearImage.withRenderingMode(.alwaysOriginal), tag: 2)
        fourthVC.tabBarItem = UITabBarItem(title: "我的", image: clearImage.withRenderingMode(.alwaysOriginal), tag: 3)
        
        self.thirdVC = thirdVC
        // 将UIViewController添加到TabBarController
        let viewControllerList = [firstVC, secondVC, thirdVC, fourthVC]
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
        // 设置 TabBar 背景色
        self.tabBar.backgroundColor = .black.withAlphaComponent(0.05)

        // 设置 TabBarItem 字体颜色和字号
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.colorWithHexString("#999999")
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.colorWithHexString("#4272D7")
        ]
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)

        if #available(iOS 13.0, *){
            let standardAppearance = self.tabBar.standardAppearance.copy()
            let inlineLayoutAppearance = UITabBarItemAppearance.init()
            inlineLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor.colorWithHexString("#999999") ,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]
            inlineLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor :UIColor.colorWithHexString("#4272D7") ,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)]

            standardAppearance.stackedLayoutAppearance = inlineLayoutAppearance

            self.tabBar.standardAppearance = standardAppearance
        }
        // 选择默认显示的tab
        if let index = Int(UserManager.shared.settingModel?.tab ?? "0") , index == 1{
            selectedIndex = 2
        }else{
            selectedIndex = 0
        }

    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var selectIndex = 0
        guard let tabItems = tabBar.items else {
            // 在 tabBar 中没有 items
            return
        }
        
        // 在这里，我们通过遍历 tabBar 的 items，找出我们点击的 item 在数组里的 index。
        for (index, tabItem) in tabItems.enumerated() {
            if tabItem == item {
                selectIndex = index
                break
            }
        }
        
        if selectIndex == 2 {
            if let key = UserManager.shared.key,key.count > 0 {
                self.viewModel.getHtmlRequest(key: UserManager.shared.key ?? "", kefu: UserManager.shared.kefu ?? "")
                    .withUnretained(self)
                    .subscribe(onNext: { result in
                        self.thirdVC.currentUrl = result.1
                    })
                    .disposed(by: self.viewModel.disposeBag)
            }else{
                let loginVC = LoginViewController(title: "",isShowBack: false)
                let nav = UINavigationController(rootViewController: loginVC)
                UIApplication.shared.windows.first?.rootViewController = nav
            }
        }
    }
}
