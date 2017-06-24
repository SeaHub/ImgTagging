//
//  APIManager.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/24.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct APIJSONParsingKeys {
    static let kDataKey    = "data"
    static let kGeneralKey = "general"
    static let kAdminKey   = "admin"
}

class APIManager: NSObject {
    private static let kBaseURL  = "http://114.115.152.250:8080/api/v1"
    private static let kAdminURL = "http://114.115.152.250:8080/api/v1/Admin"
    
    // MARK: - Token Related
    public class func login(username: String, password: String,
                            success: ((_ user: User) -> ())?,
                            failure: ((_ error: Error) -> ())?) {
        let params = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request("\(kBaseURL)/login", method: .post, parameters: params, encoding: JSONEncoding.default).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json = JSON(value)
                    let data = json[APIJSONParsingKeys.kDataKey].dictionary!
                    let user = User(JSON: data)
                    success(user)
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    public class func updateToken(token: String,
                                success: (() -> ())?,
                                failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kBaseURL)/updateToken", method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(_):
                if let success = success {
                    success()
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    // MARK: - Admin Management
    public class func getAdminAccountInfo(token: String,
                                          success: ((_ userInfo: UserInfo) -> ())?,
                                          failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kAdminURL)/getInfo", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json = JSON(value)
                    let data = json[APIJSONParsingKeys.kDataKey].dictionary!
                    let userInfo = UserInfo(generalJSON: data[APIJSONParsingKeys.kGeneralKey]!.dictionary!,
                                            adminJSON: data[APIJSONParsingKeys.kAdminKey]!.dictionary)
                    success(userInfo)
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    public class func getUserInfoList(token: String,
                                      success: ((_ userInfo: [UserInfo]) -> ())?,
                                      failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kAdminURL)/getUserList", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json  = JSON(value)
                    let datas = json[APIJSONParsingKeys.kDataKey].array!
                    var userInfoList: [UserInfo] = []
                    for data in datas {
                        let userInfo = UserInfo(generalJSON: data.dictionary!,
                                                adminJSON: nil)
                        userInfoList.append(userInfo)
                    }
                    
                    success(userInfoList)
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    public class func getAdminInfoList(token: String,
                                       success: ((_ userInfo: [UserInfo]) -> ())?,
                                       failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kAdminURL)/getAdminList", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json  = JSON(value)
                    let datas = json[APIJSONParsingKeys.kDataKey].array!
                    var userInfoList: [UserInfo] = []
                    for data in datas {
                        let userInfo = UserInfo(generalJSON: data.dictionary!,
                                                adminJSON: nil)
                        userInfoList.append(userInfo)
                    }
                    
                    success(userInfoList)
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    public class func getUserDetail(token: String,
                                    userID: String,
                                    success: ((_ userDetail: UserDetail) -> ())?,
                                    failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kAdminURL)/getUserDetail?userId=\(userID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json       = JSON(value)
                    let data       = json[APIJSONParsingKeys.kDataKey].dictionary!
                    let userDetail = UserDetail(JSON: data)
                    success(userDetail)
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
}
