//
//  UserInfo.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct UserInfoJSONParsingKeys {
    static let kScoreKey         = "score"
    static let kFinishedNumKey   = "finish_num"
    static let kAvatarURLKey     = "avatar"
    static let kUserIDKey        = "userId"
    static let kNameKey          = "name"
}

class UserInfo: NSObject {
    let score: Int!
    let userID: Int!
    let finishNum: Int!
    var avatarURL: String? = nil
    var name: String?      = nil
    
    init(JSON: Dictionary<String, JSON>) {
        self.score     = JSON[UserInfoJSONParsingKeys.kScoreKey]!.int!
        self.finishNum = JSON[UserInfoJSONParsingKeys.kFinishedNumKey]!.int!
        self.avatarURL = JSON[UserInfoJSONParsingKeys.kAvatarURLKey]!.string
        self.userID    = JSON[UserInfoJSONParsingKeys.kUserIDKey]!.int!
        self.name      = JSON[UserInfoJSONParsingKeys.kNameKey]!.string
    }
}
