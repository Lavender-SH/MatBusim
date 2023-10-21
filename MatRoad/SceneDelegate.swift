//
//  SceneDelegate.swift
//  MatRoad
//
//  Created by 이승현 on 2023/09/25.
//

import UIKit
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let navigationBarAppearance = UINavigationBar.appearance()
        //navigationBarAppearance.tintColor = UIColor(named: "gold")
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.backgroundColor = .clear //UIColor(named: "TabBarTintColor") //⭐️슬라이드 메뉴바 네비게이션바 부분 색
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor(named: "gold")
        tabBarAppearance.unselectedItemTintColor = UIColor.gray
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.backgroundColor = UIColor(named: "TabBarTintColor") //⭐️ 탭바배경색
        
        // iOS 15.0 이상에서 동작하는 코드 스크롤에 상관없이 탭바의 색을 유지
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()

            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "TabBarTintColor")
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "gold")!
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray

            tabBarAppearance.scrollEdgeAppearance = appearance
            tabBarAppearance.standardAppearance = appearance
        }



        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let vc = MainViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        
        // Tab bar
        let tabBarVC = UITabBarController()
        let vc1 = UINavigationController(rootViewController: MainViewController())
        let vc2 = UINavigationController(rootViewController: MapViewController())
        let vc3 = UINavigationController(rootViewController: SettingsViewController())
        
        window?.backgroundColor = UIColor(named: "White")
        
        tabBarVC.setViewControllers([vc1, vc2, vc3], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "house")
        items[1].image = UIImage(systemName: "map")
        items[2].image = UIImage(systemName: "gearshape")
        
        for item in items {
            item.title = nil
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)
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



