//
//  XRouter_UITests.swift
//  XRouter_UITests
//
//  Created by Reece Como on 19/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

class UITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    /// The interface runs itself
    func testRoutes() {
        sleep(10)
    }

}
