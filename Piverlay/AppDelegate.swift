//
//  AppDelegate.swift
//  Piverlay
//
//  Created by Woncheol Heo on 2021/03/06.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainVC = UINavigationController(rootViewController: PhotoAlbumViewController())
        mainVC.isNavigationBarHidden = true
        window?.rootViewController = mainVC
        
        return true
    }
}

