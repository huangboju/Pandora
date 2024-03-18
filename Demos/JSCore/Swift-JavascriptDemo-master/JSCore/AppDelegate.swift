//
//  AppDelegate.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit

enum GoodsDetailDeeplinkHost: String, CaseIterable {
    case goodsDetail = "goods_detail"
    case miniGoodsDetail = "mini_goods_detail"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let link = "xhsdiscover://goods_detail/639c68f7af570300017e4c66?max_width=800&listing_image=https%3A%2F%2Fqimg.xiaohongshu.com%2Fmaterial_space%2F8b8a78e4-ea50-42cb-b902-c27d28f1854a%3FitemId%3D639c68f7af570300017e4c66%26imageView2%2F1%2Fw%2F620%2Fh%2F620%2Fq%2F90.jpeg&custom_backgroundColor=%23ffffff&prefetch-image=https%3A%2F%2Fqimg.xiaohongshu.com%2Fmaterial_space%2F8b8a78e4-ea50-42cb-b902-c27d28f1854a%3FitemId%3D639c68f7af570300017e4c66%26imageView2%2F2%2Fw%2F800%2Fq%2F90.jpeg&trackId=lns_lns@64abcc606c3563000d8c254e&max_height=800&source=mall_home&first_width=800&first_height=800&has_video=false"
        reportGoodsCardClickedIfNeeded(link)
        return true
    }

    func reportGoodsCardClickedIfNeeded(_ deeplink: String) {
        guard var com = URLComponents(string: deeplink) else { return }
        let hostSet = Set(GoodsDetailDeeplinkHost.allCases.map {
            $0.rawValue
        })
        print(com.scheme == "xhsdiscover")
        if let host = com.host, !hostSet.contains(host) {
            return
        }
        let ignoreKeySet = Self.ignoreKeySet
        let result = com.queryItems?.filter { !ignoreKeySet.contains($0.name) }
        com.queryItems = result
        let path = com.path.replacingOccurrences(of: "/", with: "")
        let query = com.query.map { $0 + "&goodsId=\(path)" } ?? ""
        print(query)
    }

    static var ignoreKeySet: Set<String> {
        [
            "key_raw_url",
            "statusBar",
            "needNewRootNavigation",
            "halfShadowCorner",
            "halfShadowHeight",
            "listing_image",
            "halfShadowColor",
            "first_width",
            "halfShadow",
            "prefetch-image",
            "first_height",
            "max_width",
            "background_transparent_v2",
            "max_height",
            "rnAnimated",
            "custom_backgroundColor"
        ]
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

