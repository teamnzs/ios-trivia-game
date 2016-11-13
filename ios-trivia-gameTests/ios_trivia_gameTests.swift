//
//  ios_trivia_gameTests.swift
//  ios-trivia-gameTests
//
//  Created by Savio Tsui on 11/12/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import XCTest
import Nimble
@testable import ios_trivia_game

class ios_trivia_gameTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_jServiceClient_categories() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        waitUntil { done in
            JServiceClient.instance.categories(success: { (response) in
                expect(response).toEventuallyNot(beNil())
                done()
            }, failure: { (error) in
                expect(error).to(beNil())
                done()
            })

        }
    }
    
}
