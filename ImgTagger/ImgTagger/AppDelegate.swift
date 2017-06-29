//
//  AppDelegate.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/24.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import NotificationBannerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.autoLogin()
        return true
    }
    
    private func autoLogin() {
        ImgTaggerUtil.checkNetworkStatus(reachable: {
            debugPrint("oldToken: \(ImgTaggerUtil.userToken!)")
            if let token = ImgTaggerUtil.userToken {
                APIManager.updateToken(token: token, success: { (newToken) in
                    UserDefaults.standard.setValue(newToken, forKey: AppConstant.kUserTokenIdentifier)
                    debugPrint("newToken: \(newToken)")
                    let banner = StatusBarNotificationBanner(title: "Auto login successfully", style: .success)
                    banner.show()
                    self.window?.rootViewController = ImgTaggerUtil.mainStoryborad.instantiateViewController(withIdentifier: ConstantStroyboardIdentifier.kHomeViewControllerIdentifier)
                    
                }, failure: { (error) in
                    let banner = StatusBarNotificationBanner(title: "Need to relogin", style: .warning)
                    banner.show()
                })
                
            } else {
                let banner = StatusBarNotificationBanner(title: "Need to login", style: .warning)
                banner.show()
            }
            
        }) {
            let banner = StatusBarNotificationBanner(title: "Network Break!", style: .danger)
            banner.show()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

