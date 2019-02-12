//
//  PathPatternTests.swift
//  XRouter_Tests
//
//  Created by Reece Como on 21/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import UIKit
@testable import XRouter

/**
 PathPattern Tests
 */
class PathPatternTests: XCTestCase {
    
    /// Test component matching
    func testPathPatternComponentMatchingWorksAsExpected() {
        let pathPattern: PathPattern = "/fixed/*/{parameter}/"
        
        /// Exact match component
        XCTAssert(pathPattern.components[0].matches("fixed"))
        XCTAssertFalse(pathPattern.components[0].matches("wrong"))
        
        /// Wildcard component matches anything
        XCTAssert(pathPattern.components[1].matches("anything"))
        
        /// Named component matches anything
        XCTAssert(pathPattern.components[2].matches("something"))
    }
    
    /// Test named parameter component.
    func testPathPatternParameterComponent() {
        let pathPattern: PathPattern = "/abc/*/{def}/"
        
        if case let PathPattern.Component.exact(string) = pathPattern.components[0] {
            XCTAssertEqual(string, "abc")
        } else {
            XCTFail("Failed to get exact match string.")
        }
        
        if case PathPattern.Component.wildcard = pathPattern.components[1] {
            // Do nothing
        } else {
            XCTFail("Failed to get named parameter.")
        }
        
        if case let PathPattern.Component.parameter(name) = pathPattern.components[2] {
            XCTAssertEqual(name, "def")
        } else {
            XCTFail("Failed to get named parameter.")
        }
    }
    
}
