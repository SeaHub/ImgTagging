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
    let kAdminAccountUsername = ""   // Need to be filled with
    let kAdminAccountPassword = "123456"  // Need to be filled with
    
    
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
    
    func testLogout() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.logout(token: user.token, success: {
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
        
        wait(for: [exception], timeout: kExceptionWaitingTime)
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
    
    // MARK: - Photo Handler
    func testGetImageList() { // 1st step
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.getImageList(token: user.token, currentPage: "1", perPage: "1", success: { (user) in
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
    
    func testDoStatistics() { // 2nd step
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.doStatistics(token: user.token, imageID: 1, success: { 
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
    
    func testGetStatistics() { // 3rd step
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.getImageStatisticsResult(token: user.token, imageID: 1, success: { (imageStatisticsResultList) in
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
    
    func testUpdateModel() { // 4th step
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.updateModel(token: user.token, imageID: 1, tagID: 12, success: {
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
    
    func testGetImageResult() { // 5th step
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            APIManager.getImageResult(token: user.token, imageID: 1, success: { (imageResultList) in
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
    
    func testUploadImage() { // Ext step
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kAdminAccountUsername, password: kAdminAccountPassword, success: { (user) in
            
            let image = UIImage(named: "test")
            APIManager.uploadImage(token: user.token, image: image!, success: {
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
