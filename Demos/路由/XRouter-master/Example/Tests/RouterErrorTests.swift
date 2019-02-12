//
//  XRouterErrorTests.swift
//  XRouter_Tests
//
//  Created by Reece Como on 7/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import UIKit
@testable import XRouter

/**
 RouteProvider Tests
 */
class RouterErrorTests: XCTestCase {
    
    /// Test custom transition is triggered
    func testErrorFormatting() {
        let mockTransition: RouteTransition = .push
        
        assertExpectedFormat(for: .missingSourceViewController)
        assertExpectedFormat(for: .missingRequiredNavigationController(for: mockTransition))
        assertExpectedFormat(for: .missingRequiredParameterWhileUnwrappingURLRoute(parameter: "test"))
        assertExpectedFormat(for: .requiredIntegerParameterWasNotAnInteger(parameter: "test", stringValue: "test"))
        assertExpectedFormat(for: .missingCustomTransitionDelegate)
    }
    
    private func assertExpectedFormat(for error: RouterError) {
        XCTAssertNotNil(error.errorDescription)
        XCTAssertNotNil(error.failureReason)
        XCTAssertNotNil(error.recoverySuggestion)
        
        // Help anchor not provided
        XCTAssertNil(error.helpAnchor)
    }
    
}
