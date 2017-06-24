//
//  UserInfo.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct UserInfoJSONParsingKeys {
    static let kIDKey            = "id"
    static let kUsernameKey      = "username"
    static let kEmailKey         = "email"
    static let kRememberTokenKey = "remember_token"
    static let kCreatedAtKey     = "created_at"
    static let kUpdatedAtKey     = "updated_at"
    static let kIdentityKey      = "identity"
    static let kAIDKey           = "a_id"
    static let kUserIDKey        = "userId"
    static let kNameKey          = "name"
}

class UserInfo: NSObject {
    let generalUserID: Int!
    let username: String!
    let email: String!
    let rememberToken: String?
    let createdAt: String!
    let updatedAt: String!
    let identity: UserIdentity!
    var adminID: Int? = nil
    var userID: Int?  = nil
    var name: String? = nil
    
    init(generalJSON: Dictionary<String, JSON>, adminJSON: Dictionary<String, JSON>?) {
        self.generalUserID = generalJSON[UserInfoJSONParsingKeys.kIDKey]!.int!
        self.username      = generalJSON[UserInfoJSONParsingKeys.kUsernameKey]!.string!
        self.email         = generalJSON[UserInfoJSONParsingKeys.kEmailKey]!.string!
        self.rememberToken = generalJSON[UserInfoJSONParsingKeys.kRememberTokenKey]?.string
        self.createdAt     = generalJSON[UserInfoJSONParsingKeys.kCreatedAtKey]?.string!
        self.updatedAt     = generalJSON[UserInfoJSONParsingKeys.kUpdatedAtKey]!.string!
        self.identity      = UserIdentity(rawValue: generalJSON[UserInfoJSONParsingKeys.kIdentityKey]!.int!)!
        
        if let adminJSON = adminJSON {
            self.adminID = adminJSON[UserInfoJSONParsingKeys.kAIDKey]!.int!
            self.userID  = adminJSON[UserInfoJSONParsingKeys.kUserIDKey]!.int!
            self.name    = adminJSON[UserInfoJSONParsingKeys.kNameKey]!.string!
        }
    }
}
