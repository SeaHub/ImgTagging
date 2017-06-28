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
                             failure: ((_ error: Error) -> ())?) { // Need to filled Phone
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: "", zone: "86") { (error) in
            guard error == nil else {
                if let failure = failure {
                    debugPrint(error!)
                    failure(error!)
                }
                
                return
            }
            
            if let success = success {
                success()
            }
        }
    }
    
    // MARK: - Push Related
    
    /// 顺序推送
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - number: 推送数量
    ///   - success: 成功回调函数（注意可能因所有图片已推送因而获得空图片）
    ///   - failure: 失败回调函数
    public class func getServerPushedDataSequently(token: String,
                                                  number: Int,
                                                 success: ((_ pushedData: [ServerPushData]?) -> ())?,
                                                 failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params = [
            "number": number
        ]
        
        Alamofire.request("\(kBaseURL)/Push/getSequence", method: .get, parameters: params, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let success  = success {
                    let json    = JSON(value)

                    if let datas = json[APIJSONParsingKeys.kDataKey].array {
                        var pushedDatas: [ServerPushData] = []
                        for aData in datas {
                            let pushedData = ServerPushData(JSON: aData.dictionary!)
                            pushedDatas.append(pushedData)
                        }
                        success(pushedDatas)
                    
                    } else {
                        success(nil)
                    }
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    /// 根据兴趣推送
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - number: 推送数量
    ///   - success: 成功回调函数（注意可能因所有图片已推送因而获得空图片）
    ///   - failure: 失败回调函数（注意失败可能由于用户没有设置兴趣导致）
    public class func getServerPushedDataOnHobbies(token: String,
                                                  number: Int,
                                                 success: ((_ pushedData: [ServerPushData]?) -> ())?,
                                                 failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params = [
            "number": number
        ]
        
        Alamofire.request("\(kBaseURL)/Push/byHobby", method: .get, parameters: params, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json   = JSON(value)
                    
                    if let datas = json[APIJSONParsingKeys.kDataKey].array {
                        var pushedDatas: [ServerPushData] = []
                        for aData in datas {
                            let pushedData = ServerPushData(JSON: aData.dictionary!)
                            pushedDatas.append(pushedData)
                        }
                        success(pushedDatas)
                        
                    } else {
                        success(nil)
                    }
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    /// 根据用户打分推送
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - number: 推送数量
    ///   - minPoint: 最低推送分数
    ///   - success: 成功回调函数（注意可能因所有图片已推送因而获得空图片）
    ///   - failure: 失败回调函数（注意失败可能由于用户没有设置兴趣导致）
    public class func getServerPushedDataOnScores(token: String,
                                                  number: Int,
                                                  minPoint: ScorePoint,
                                                  success: ((_ pushedData: [ServerPushData]?) -> ())?,
                                                  failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params = [
            "number": number,
            "min": minPoint.rawValue
        ]
        
        Alamofire.request("\(kBaseURL)/Push/byScore", method: .get, parameters: params, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json   = JSON(value)
                    
                    if let datas = json[APIJSONParsingKeys.kDataKey].array {
                        var pushedDatas: [ServerPushData] = []
                        for aData in datas {
                            let pushedData = ServerPushData(JSON: aData.dictionary!)
                            pushedDatas.append(pushedData)
                        }
                        success(pushedDatas)
                        
                    } else {
                        success(nil)
                    }
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    // MARK: - User Tag Related
    
    /// 给推送的图片打标签
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - tags: 标签数组
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func tagPushedData(token: String,
                                     tags: [TaggedPushedData],
                                  success: (() -> ())?,
                                  failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params  = [
            "Tags": tags.map{ $0.toJSON() }
        ]
        
        Alamofire.request("\(kBaseURL)/Tag/add", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
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
    
    /// 给推送的图片评分
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - scores: 分值数组
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func markPushedData(token: String,
                                    scores: [Score],
                                   success: (() -> ())?,
                                   failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params  = [
            "Scores": scores.map { $0.toJSON() }
        ]
        
        Alamofire.request("\(kBaseURL)/Tag/mark", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
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
    
    // MARK: - User Account Management Related
    
    /// 获取用户详细信息
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func getUserInfo(token: String,
                                success: ((_ userInfo: UserInfo) -> ())?,
                                failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kBaseURL)/getInfo", method: .get, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let success   = success {
                    let json     = JSON(value)
                    let userInfo = UserInfo(JSON: json[APIJSONParsingKeys.kDataKey].dictionary!)
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
    
    /// 更改个人信息
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - name: 名字（可选）
    ///   - avatarImage: 头像地址（可选）
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func modifyInfo(token: String,
                                  name: String?,
                           avatarImage: UIImage?,
                               success: (() -> ())?,
                               failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        var params: [String: Any] = [:]
        if let name = name {
            params["name"] = name
        }
        if let image = avatarImage {
            let imageData          = UIImagePNGRepresentation(image)
            let base64OfImageData  = imageData!.base64EncodedString()
            params["avatar"] = "data:image/png;base64,\(base64OfImageData)"
        }
        
        Alamofire.request("\(kBaseURL)/modifyInfo", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
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
    
    /// 更改密码(500)
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - newPassword: 新密码
    ///   - vcode: 验证码
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func changePassword(token: String,
                               newPassword: String,
                                     vcode: String,
                                   success: (() -> ())?,
                                   failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params = [
            "newPass": newPassword,
            "vcode": vcode
        ]
        
        Alamofire.request("\(kBaseURL)/setPwd", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
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
    
    // MARK: - Hobby Related
    
    /// 删除兴趣
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - hobbyID: 兴趣 ID
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func deleteHobby(token: String,
                                hobbyID: Int,
                                success: (() -> ())?,
                             	failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params  = [
            "h_id": hobbyID
        ]
        
        Alamofire.request("\(kBaseURL)/hobby/delete", method: .delete, parameters: params, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
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
    
    /// 获取兴趣
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func getHobbies(token: String,
                               success: ((_ hobbies: [Hobby]) -> ())?,
                               failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kBaseURL)/hobby/get", method: .get, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json             = JSON(value)
                    let datas            = json[APIJSONParsingKeys.kDataKey].array!
                    var hobbies: [Hobby] = []
                    for data in datas {
                        let hobby = Hobby(JSON: data.dictionary!)
                        hobbies.append(hobby)
                    }
                    success(hobbies)
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    /// 添加兴趣
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - hobbies: 兴趣数组（只需提供 name 与 weight 字段）
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func addHobbies(token: String,
                               hobbies: [Hobby],
                               success: (() -> ())?,
                               failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params  = [
            "hobbies": hobbies.map { $0.toJSON() }
        ]

        Alamofire.request("\(kBaseURL)/hobby/add", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
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
    
    /// 修改兴趣
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - hobbyID: 兴趣 ID
    ///   - hobbyName: 兴趣名称（可选）
    ///   - hobbyWeight: 兴趣权值（可选）
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func modifyHobby(token: String,
                                  hobbyID: Int,
                                hobbyName: String?,
                              hobbyWeight: Int?,
                                  success: (() -> ())?,
                                  failure: ((_ error: Error) -> ())?) {
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        var params: [String: Any] = [
            "h_id": hobbyID
        ]
        
        if let hobbyName = hobbyName {
            params["hobby_name"] = hobbyName
        }
        
        if let hobbyWeight = hobbyWeight{
            params["weight"] = hobbyWeight
        }
        
        Alamofire.request("\(kBaseURL)/hobby/modify", method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
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
}
