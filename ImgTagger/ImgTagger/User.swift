//
//  User.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/24.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct UserJSONParsingKeys {
    static let kEmailKey            = "email"
    static let kExpiredAtKey        = "expired_at"
    static let kIdentityKey         = "identity"
    static let kLastLoginedTimeKey  = "last_logined_time"
    static let kRefreshExpiredAtKey = "refresh_expired_at"
    static let kTokenKey            = "token"
    static let kUserIDKey           = "userId"
    static let kUsernameKey         = "username"
}

enum UserIdentity: Int {
    case normal = 0
    case Admin  = 1
}

class User: NSObject {
    let userID: Int!
    let email: String!
    let token: String!
    let username: String!
    let expiredAt: String!
    let identity: UserIdentity!
    let lastLoginedTime: String!
    let refreshExpiredAt: String!

    init(JSON: Dictionary<String, JSON>) {
        self.userID           = JSON[UserJSONParsingKeys.kUserIDKey]!.int!
        self.email            = JSON[UserJSONParsingKeys.kEmailKey]!.string!
        self.token            = JSON[UserJSONParsingKeys.kTokenKey]!.string!
        self.username         = JSON[UserJSONParsingKeys.kUsernameKey]!.string!
        self.expiredAt        = JSON[UserJSONParsingKeys.kExpiredAtKey]!.string!
        self.identity         = UserIdentity(rawValue: JSON[UserJSONParsingKeys.kIdentityKey]!.int!)
        self.lastLoginedTime  = JSON[UserJSONParsingKeys.kLastLoginedTimeKey]!.string!
        self.refreshExpiredAt = JSON[UserJSONParsingKeys.kRefreshExpiredAtKey]!.string!
    }
}
