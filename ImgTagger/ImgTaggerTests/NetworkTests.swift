//
//  NetworkTests.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/24.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

@testable import ImgTagger
import XCTest
import UIKit
import Alamofire

class NetworkTests: XCTestCase {
    let kExceptionWaitingTime = 5.0
    let kUserAccountUsername = "Admin"   // Need to be filled with
    let kUserAccountPassword = "123456"  // Need to be filled with
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Token Related
    func testLogin() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            exception.fulfill()
        }) { (error) in
            exception.fulfill()
            debugPrint(error.localizedDescription)
            XCTAssert(false)
        }
        
        wait(for: [exception], timeout: kExceptionWaitingTime)
    }
    
    func testUpdateToken() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.updateToken(token: user.token, success: { 
                exception.fulfill()
            }, failure: { (error) in
                exception.fulfill()
                debugPrint(error.localizedDescription)
                XCTAssert(false)
            })
            
        }) { (error) in
            exception.fulfill()
            debugPrint(error.localizedDescription)
            XCTAssert(false)
        }
        
        wait(for: [exception], timeout: kExceptionWaitingTime * 2)
    }
}
