//
//  AppDelegate.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/8/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var storyboard = UIStoryboard(name: "Main", bundle: nil)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        UINavigationBar.appearance().barTintColor = UIColor(hexString: Constants.TRIVIA_NAVY)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        UISearchBar.appearance().tintColor = UIColor(hexString: Constants.TRIVIA_RED)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.userDidLogout), name: NSNotification.Name(rawValue: userDidLogoutNotification), object: nil)
        
        return true
    }
    
    func userDidLogout() {
        let vc = storyboard.instantiateInitialViewController()! as UIViewController
        window?.rootViewController = vc
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = SDKApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
    }

    public func application(_ application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
    {
        print("facebook launch")
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

