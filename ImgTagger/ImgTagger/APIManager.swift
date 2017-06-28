//
//  APIManager.swift
//  ImgTagger
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
    
    // MARK: - Token Related
    /// 注册
    ///
    /// - Parameters:
    ///   - username: 手机号
    ///   - password: 密码(6-15位)
    ///   - email: 邮箱（可选）
    ///   - vcode: 验证码
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func register(username: String,
                               password: String,
                               email: String?,
                               vcode: String,
                             success: (() -> ())?,
                             failure: ((_ error: Error) -> ())?) {
        let params = [
            "username": username,
            "password": password,
            "email"   : email ?? "seahubc@qq.com",
            "vcode"   : vcode
        ]
        
        Alamofire.request("\(kBaseURL)/register", method: .post, parameters: params, encoding: JSONEncoding.default).validate(statusCode: 200 ..< 300).responseJSON { (response) in

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
    
    /// 通用 - 登出
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func logout(token: String,
                           success: (() -> ())?,
                           failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kBaseURL)/logout", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
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
    
    /// 通用 - 登录
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 密码
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
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
    
    /// 通用 - 更新令牌
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
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

    /// 获取验证码
    ///
    /// - Parameters:
    ///   - phone: 手机号
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func getVCode(phone: String,
                             success: (() -> ())?,
                             failure: ((_ error: Error) -> ())?) {
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: "18933932386", zone: "86") { (error) in
            guard error == nil else {
                if let failure = failure {
                    failure(error!)
                }
                
                return
            }
            
            if let success = success {
                success()
            }
        }
    }
    
    // MARK: - Push Related - TODO
}
