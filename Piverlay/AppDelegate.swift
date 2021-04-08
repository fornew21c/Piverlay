//
//  AppDelegate.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/06.
//

import UIKit

//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let photoAlbumVC = UINavigationController(rootViewController: PhotoAlbumViewController())
        let photoAlbumVC = PhotoAlbumViewController()
        let lottieTestVC = LottieTestViewController()
        
        let nvc1 = UINavigationController(rootViewController: photoAlbumVC)
        let nvc2 = UINavigationController(rootViewController: lottieTestVC)
       
        nvc1.isNavigationBarHidden = true
        nvc2.isNavigationBarHidden = true

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nvc1, nvc2]

        let tabBar: UITabBar? = tabBarController.tabBar
        UITabBar.appearance().tintColor = UIColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1)
      
        let tabBarItem1: UITabBarItem? = tabBar?.items?[0]
        let tabBarItem2: UITabBarItem? = tabBar?.items?[1]
        
        tabBarItem1?.title = "PhotoFun"
        tabBarItem1?.image = UIImage(named:"gallery")
        
        tabBarItem2?.title = "AniFun"
        tabBarItem2?.image = UIImage(named: "animation")

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = tabBarController

        tabBarController.tabBar.barTintColor = PLUtil.UIColorFromRGB(rgbValue: 0x494651)
        tabBarController.tabBar.backgroundColor = PLUtil.UIColorFromRGB(rgbValue: 0x000000)
        tabBarController.delegate = self
        window!.makeKeyAndVisible()
        
        return true
    }
}

