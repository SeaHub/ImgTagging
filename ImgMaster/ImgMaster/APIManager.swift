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
    
    // MARK: - Admin Management
    /// 获取管理员账号信息
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
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
    
    /// 获取用户列表
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
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
    
    /// 获取管理员列表
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
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
    
    /// 获取用户详情
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - userID: 用户 ID
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
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
    
    // MARK: - Photo Handler
    /// 获取包含所有图片的列表 - 图片处理第一步
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - currentPage: 当前页
    ///   - perPage: 每页图片数
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func getImageList(token: String,
                             currentPage: String,
                                 perPage: String,
                                 success: ((_ imageList: ImageList) -> ())?,
                                 failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kAdminURL)/Image/getList?page=\(currentPage)&perPage=\(perPage)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json       = JSON(value)
                    let data       = json[APIJSONParsingKeys.kDataKey].dictionary!
                    let imageList  = ImageList(JSON: data)
                    success(imageList)
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }

    /// 对图片库中的数据执行统计操作 - 图片处理第二步
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - imageID: 图片 ID
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func doStatistics(token: String,
                                   imageID: String,
                                   success: (() -> ())?,
                                   failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kAdminURL)/Image/statistics?i_id=\(imageID)", method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
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
    
    /// 获取图片统计结果列表 - 图片处理第三步
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - imageID: 图片 ID
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func getImageStatisticsResult(token: String,
                                             imageID: String,
                                             success: ((_ imageStatisticsList: ImageStatisticsResultList) -> ())?,
                                             failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kAdminURL)/Image/getStatisticsResult?i_id=\(imageID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json                = JSON(value)
                    let data                = json[APIJSONParsingKeys.kDataKey].dictionary!
                    let imageStatisticsList = ImageStatisticsResultList(JSON: data)
                    success(imageStatisticsList)
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }

    /// 更新模型（注意调用此 API 并不会立即更新）- 图片处理第四步
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - imageID: 图片 ID
    ///   - tagID: 标签 ID
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func updateModel(token: String,
                                  imageID: String,
                                  tagID: String,
                                  success: (() -> ())?,
                                  failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kAdminURL)/Image/updateModel?i_id=\(imageID)&t_id=\(tagID)", method: .put, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
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
    
    /// 获取图片最终处理结果（此步骤会运行输出模型） - 图片处理第五步（最终步）
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - imageID: 图片 ID
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func getImageResult(token: String,
                                   imageID: String,
                                   success: ((_ imageResultList: ImageResultList) -> ())?,
                                   failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request("\(kAdminURL)/Image/getResult?i_id=\(imageID)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                if let success = success {
                    let json            = JSON(value)
                    let data            = json[APIJSONParsingKeys.kDataKey].dictionary!
                    let imageResultList = ImageResultList(JSON: data)
                    success(imageResultList)
                }
            case .failure(let error):
                debugPrint(error)
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
    
    /// 上传图片至图片库 - 非主要图片处理流程
    ///
    /// - Parameters:
    ///   - token: 令牌
    ///   - image: 图片
    ///   - success: 成功回调函数
    ///   - failure: 失败回调函数
    public class func uploadImage(token: String,
                                  image: UIImage,
                                success: (() -> ())?,
                                failure: ((_ error: Error) -> ())?) {
        
        let headers = [
            "Authorization": "Bearer \(token)",
        ]
        
        let imageData          = UIImagePNGRepresentation(image)
        let base64OfImageData  = imageData!.base64EncodedString()
        
        let params = [
            "image": "data:image/png;base64,\(base64OfImageData)"
        ]
        
        Alamofire.request("\(kAdminURL)/Image/add", method: .post, parameters: params, headers: headers).validate(statusCode: 200 ..< 300).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                debugPrint(JSON(value))
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
