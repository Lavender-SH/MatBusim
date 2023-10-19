//
//  SceneDelegate.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //써도 되고 안써도 됨
//        let savedTheme = UserDefaults.standard.string(forKey: "appTheme") ?? "light"
//        window?.overrideUserInterfaceStyle = savedTheme == "light" ? .light : .dark
 
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let vc = MainViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        
        //탭바
        let tabBarVC = UITabBarController()
        let vc1 = UINavigationController(rootViewController: MainViewController())
        let vc2 = UINavigationController(rootViewController: MapViewController())
        let vc3 = UINavigationController(rootViewController: SettingsViewController())
        
        // ...

        // 탭바 설정 부분 아래에 추가
//        if let navigationController = vc1 as? UINavigationController {
//            navigationController.navigationBar.overrideUserInterfaceStyle = .light
//        }
//        if let navigationController = vc2 as? UINavigationController {
//            navigationController.navigationBar.overrideUserInterfaceStyle = .light
//        }
//        if let navigationController = vc3 as? UINavigationController {
//            navigationController.navigationBar.overrideUserInterfaceStyle = .light
//        }
//
//        tabBarVC.tabBar.overrideUserInterfaceStyle = .light

        // ...

        
        
        //vc1.title = "검색"
        //vc2.title = "좋아요"

        
        tabBarVC.setViewControllers([vc1, vc2, vc3], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = UIColor(cgColor: .init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))
        tabBarVC.tabBar.tintColor = UIColor(named: "gold")
        tabBarVC.tabBar.unselectedItemTintColor = UIColor.gray
        tabBarVC.tabBar.isTranslucent = false
        tabBarVC.tabBar.barTintColor = UIColor(cgColor: .init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))//UIColor(named: "TabBarTintColor") //⭐️
        //tabBarVC.tabBarItem.title = "검색"
        
        

        
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "house")
        items[1].image = UIImage(systemName: "map")
        items[2].image = UIImage(systemName: "gearshape")
        
        for item in items {
            item.title = nil
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

        
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()

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
extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}


