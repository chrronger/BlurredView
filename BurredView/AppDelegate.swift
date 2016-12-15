//
//  AppDelegate.swift
//  BurredView
//
//  Created by 希 Guan on 2016/12/15.
//  Copyright © 2016年 ower[]. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    //添加模糊效果，进入后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        let view = BlurredEffect(frame: window?.frame ?? UIScreen.main.bounds)
        view.tag = 999
        UIApplication.shared.windows.forEach { (window) in
            if window.windowLevel == UIWindowLevelNormal {
                window.addSubview(view)
            }
        }

    }
    //移除模糊效果，进入前台
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.windows.forEach { (window) in
            if window.windowLevel == UIWindowLevelNormal {
                let view = window.viewWithTag(999)
                view?.removeFromSuperview()
            }
        }

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

