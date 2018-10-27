//
//  PageboyTests.swift
//  PageboyTests
//
//  Created by Merrick Sapsford on 04/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyTests: XCTestCase {
    
    typealias AsyncTest = (@escaping TestCompletion) -> Void
    typealias TestCompletion = () -> Void
    
    var pageboyViewController: TestPageBoyViewController!
    var dataSource: TestPageboyDataSource!
    var delegate: TestPageboyDelegate!
    
    private var expectations = [XCTestExpectation]()
    
    // MARK: Environment
    
    override func setUp() {
        super.setUp()
        
        self.pageboyViewController = TestPageBoyViewController()
        self.dataSource = TestPageboyDataSource()
        self.delegate = TestPageboyDelegate()
        
        self.pageboyViewController.delegate = delegate
        
        let bounds = UIScreen.main.bounds
        self.pageboyViewController.view.frame = bounds
        
        if #available(iOS 9.0, *) {
            self.pageboyViewController.loadViewIfNeeded()
        } else {
            self.pageboyViewController.loadView()
        }
    }
    
    override func tearDown() {
        
//        self.pageboyViewController = nil
//        self.dataSource = nil
//        self.delegate = nil
        
        super.tearDown()
    }
    
    // MARK: Tests
    
    private func testInit() {
        XCTAssert(self.pageboyViewController != nil,
                  "PageBoyViewController initialization failed")
    }

    func performAsyncTest(timeout: TimeInterval = 0.3,
                          test: AsyncTest) {
        let exp = expectation(description: "Async test")
        let index = expectations.count
        expectations.append(exp)
        test { [unowned self] in
            exp.fulfill()
            self.expectations.remove(at: index)
        }
        waitForExpectations(timeout: timeout) { (error) in
            guard let error = error else {
                return
            }
            
            XCTFail("Expectation failed with \(error)")
        }
    }
}
