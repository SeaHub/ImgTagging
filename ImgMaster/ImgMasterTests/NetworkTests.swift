//
//  NetworkTests.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/24.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

@testable import ImgMaster
import XCTest
import UIKit
import Alamofire

class NetworkTests: XCTestCase {
    let kExceptionWaitingTime = 5.0
    let kAdminAccountUsername = ""
    let kAdminAccountPassword = ""
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Token Related
    func testLogin() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
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
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
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

    // MARK: - Admin Management
    func testGetUserInfo() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.getAdminAccountInfo(token: user.token, success: { (userInfo) in
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
    
    func testGetUserInfoList() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.getUserInfoList(token: user.token, success: { (userInfos) in
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
    
    func testGetAdminInfoList() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.getAdminInfoList(token: user.token, success: { (userInfos) in
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
    
    func testGetUserDetail() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.getUserDetail(token: user.token, userID: "6", success: { (userDetail) in
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
