//
//  MockRouter.swift
//  XRouter_Example
//
//  Created by Reece Como on 12/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import XRouter

/**
 Mocked router
 */
class MockRouter<Route: RouteProvider>: Router<Route> {
    
    private(set) var currentRoute: Route?
    
    convenience init(rootViewController: UIViewController? = UIApplication.shared.rootViewController) {
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        self.init()
    }
    
    /// Sets the `currentRoute` when `super.navigate(to:animated)` doesn't return an error
    override func navigate(to route: Route, animated: Bool = false, completion: ((Error?) -> Void)? = nil) {
        super.navigate(to: route, animated: animated) { (error) in
            if error == nil {
                self.currentRoute = route
            }
            
            completion?(error)
        }
    }
    
}
