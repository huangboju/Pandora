//
//  UIApplicationExtensionTests.swift
//  XRouter_Tests
//
//  Created by Reece Como on 21/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import UIKit
@testable import XRouter

/**
 UIApplication Extension Tests
 */
class UIApplicationExtensionTests: XCTestCase {
    
    /// Get top view controller.
    func testTopViewControllerIsPresentedViewController() {
        let presentingViewController = UIViewController()
        let presentedViewController = UIViewController()
        
        UIApplication.shared.keyWindow?.rootViewController = presentingViewController
        presentingViewController.present(presentedViewController, animated: false)
        
        let topViewController = UIApplication.shared.getTopViewController(for: presentingViewController)
        
        XCTAssertEqual(presentedViewController, topViewController)
    }
    
}
