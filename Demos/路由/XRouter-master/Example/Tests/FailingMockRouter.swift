//
//  FailingMockRouter.swift
//  XRouter_Tests
//
//  Created by Reece Como on 22/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import XRouter

/**
 Failing mocked router
 */
class FailingMockRouter<Route: RouteProvider>: Router<Route> {
    
    /// No current top view controller set
    override public var currentTopViewController: UIViewController? {
        return nil
    }
    
    convenience init(rootViewController: UIViewController? = UIApplication.shared.rootViewController) {
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
        self.init()
    }
    
}
