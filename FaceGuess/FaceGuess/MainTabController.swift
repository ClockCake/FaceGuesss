//
//  MainTabController.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBar.isTranslucent = false

        // 创建各个页面的UIViewController
        let firstVC = HomeViewController(title: "",isShowBack: false)
        let secondVC = ActivityViewController(title: "",isShowBack: false)
        let thirdVC = RankViewController(title: "", isShowBack: false, url: "https://www.jd.com")
        let fourthVC = PersonalViewController(title: "",isShowBack: false)
        
        // 为UIViewController设置标题、图标等
        let clearImage = UIImage()

        firstVC.tabBarItem = UITabBarItem(title: "脸猜", image: clearImage.withRenderingMode(.alwaysOriginal), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "连猜", image: clearImage.withRenderingMode(.alwaysOriginal), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "榜单", image: clearImage.withRenderingMode(.alwaysOriginal), tag: 2)
        fourthVC.tabBarItem = UITabBarItem(title: "我的", image: clearImage.withRenderingMode(.alwaysOriginal), tag: 3)
        
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
        // 选择默认显示的tab
        selectedIndex = 0
       
  
    }
}
