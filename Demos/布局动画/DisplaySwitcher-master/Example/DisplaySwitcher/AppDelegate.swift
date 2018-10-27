//
//  AppDelegate.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 23.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = ([NSFontAttributeName: UIFont(name: "Dosis-SemiBold", size: 21)!,
                NSForegroundColorAttributeName: UIColor.navigationBarTintColor()])
        UINavigationBar.appearance().barTintColor = UIColor.navigationBarBackgroundColor()
        navigationBarAppearace.isTranslucent = false
        
        UIApplication.shared.statusBarStyle = .lightContent
      
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .lightGray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .lightGray
        
        return true
    }
    
}
