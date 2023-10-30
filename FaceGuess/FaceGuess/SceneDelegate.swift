//
//  SceneDelegate.swift
//  FaceGuess
//
//  Created by 黄尧栋 on 2023/10/21.
//

import UIKit
import RxSwift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let viewModel = ViewModel()
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        settingRequest { result in
            switch result {
            case .success(let model):
                self.dealLogic(model: model)
            case .failure(let error):
                print("失败，错误是：\(error)")
            }
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
extension SceneDelegate {
    func settingRequest(completion: @escaping (Result<SettingModel, Error>) -> Void) {
        // 执行你的网络请求或其他逻辑...
        let hh = self.viewModel.getSignatureTime()
        self.viewModel.mySettingRequest(key: UserManager.shared.key ?? "", signature: self.viewModel.md5(string:"bafacegs\(hh)"))
            .withUnretained(self)
            .subscribe(onNext: { result in
                completion(.success(result.1))
            }).disposed(by: self.viewModel.disposeBag)

    }
    func dealLogic(model:SettingModel) {
        UserManager.shared.settingModel = model
        if model.prelogin ?? "" == "0" {
            let mainTabBar = MainTabController()
            window?.rootViewController = mainTabBar
        }else{
            if let key = UserManager.shared.key, key.count > 0 {
                let mainTabBar = MainTabController()
                window?.rootViewController = mainTabBar
            }else{
                let loginVC =  AutoLoginVIewController.init(title: "", isShowBack: false)
//                LoginViewController(title: "",isShowBack: false)
                let nav = UINavigationController(rootViewController: loginVC)
                window?.rootViewController = nav
            }
        }
        window?.makeKeyAndVisible()
        
        if UserManager.shared.isAccpetAgree == false {
            let agreeVC = AgreementViewController(height: 430)
            agreeVC.modalPresentationStyle = .custom
            agreeVC.transitioningDelegate = agreeVC
    //        agreeVC.currentNavController = currentNavController
            window?.rootViewController?.present(agreeVC, animated: true, completion: nil)
        }


    }
}
