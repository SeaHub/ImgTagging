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
    let kUserAccountUsername = "18933932386"   // Need to fill blanks while testing
    let kUserAccountPassword = "125800"   // Need to fill blanks while testing
    
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
    
    func testGetVcode() { // Need to fill blanks while testing
        let exception     = XCTestExpectation(description: "Waiting")
        let registerPhone = ""
        
        APIManager.getVCode(phone: registerPhone, success: { 
            exception.fulfill()

        }) { (error) in
            exception.fulfill()
            debugPrint(error.localizedDescription)
            XCTAssert(false)
        }
        
        wait(for: [exception], timeout: kExceptionWaitingTime)
    }
    
    func testRegister() { // Need to fill blanks while testing
        let exception     = XCTestExpectation(description: "Waiting")
        let registerPhone = ""
        let vcode         = ""
        
        APIManager.register(username: registerPhone, password: "", email: nil, vcode: vcode, success: {
            exception.fulfill()
            
        }) { (error) in
            exception.fulfill()
            debugPrint(error.localizedDescription)
            XCTAssert(false)
        }
        
        wait(for: [exception], timeout: kExceptionWaitingTime)
    }
    
    func testLogout() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
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
        
        wait(for: [exception], timeout: kExceptionWaitingTime * 2)
    }
    
    // MARK: - Push Related
    func testPushSequently() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.getServerPushedDataSequently(token: user.token, number: 100, success: { (pushedDatas) in
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
    
    func testPushedOnHobbies() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.getServerPushedDataOnHobbies(token: user.token, number: 100, success: { (pushedData) in
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
    
    func testPushedOnScores() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.getServerPushedDataOnScores(token: user.token!, number: 100, minPoint: .levelAA, success: { (pushedDATA) in
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
    
    // MARK: - User Tag Related
    func testTagPushedData() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            let tag = TaggedPushedData(imageID: 1, tagName: "Hello2")
            let tags: [TaggedPushedData] = [tag]
            APIManager.tagPushedData(token: user.token, tags: tags, success: { 
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
    
    func testMarkPushedData() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            let score = Score(imageID: 1, point: .levelAA)
            let scores = [score]
            
            APIManager.markPushedData(token: user.token, scores: scores, success: {
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
    
    // MARK: - User Account Management Related
    func testGetUserInfo() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.getUserInfo(token: user.token, success: { (userInfo) in
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
    
    func testModifyUserInfo() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.modifyInfo(token: user.token, name: "Seahub", avatarImage: nil, success: { 
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
    
    func testChangePassword() { // Need to fill blanks while testing
        let exception     = XCTestExpectation(description: "Waiting")
        let vcode         = ""
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.changePassword(token: user.token, newPassword: "1234567", vcode: vcode, success: {
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
    
    
    // MARK: - Hobby Related
    func testAddHobbies() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            let playingGuita = Hobby(hobbyName: "PlayingGuita2", hobbyWeight: .highest)
            let bookReading  = Hobby(hobbyName: "bookReading2", hobbyWeight: .normal)
            let hobbies: [Hobby] = [playingGuita, bookReading]
            
            APIManager.addHobbies(token: user.token, hobbies: hobbies, success: {
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

    func testGetHobbies() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.getHobbies(token: user.token, success: { (hobbies) in
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
    
    func testDeleteHobby() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.getHobbies(token: user.token, success: { (hobbies) in
                
                APIManager.deleteHobby(token: user.token, hobbyID: hobbies.first!.hobbyID, success: {
                    exception.fulfill()
                    
                }, failure: { (error) in
                    exception.fulfill()
                    debugPrint(error.localizedDescription)
                    XCTAssert(false)
                })
                
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
        
        wait(for: [exception], timeout: kExceptionWaitingTime * 3)
    }
    
    func testModifyHobby() {
        let exception = XCTestExpectation(description: "Waiting")
        
        APIManager.login(username: kUserAccountUsername, password: kUserAccountPassword, success: { (user) in
            
            APIManager.getHobbies(token: user.token, success: { (hobbies) in
                
                APIManager.modifyHobby(token: user.token, hobbyID: 4, hobbyName: "Flying", hobbyWeight: 2, success: { 
                    exception.fulfill()
                    
                }, failure: { (error) in
                    exception.fulfill()
                    debugPrint(error.localizedDescription)
                    XCTAssert(false)
                })
                
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
        
        wait(for: [exception], timeout: kExceptionWaitingTime * 3)
    }
}
