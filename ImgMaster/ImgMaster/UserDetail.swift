//
//  UserDetail.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct UserDetailJSONParsingKeys {
    static let kGeneralKey   = "General"
    static let kUserIDKey    = "userId"
    static let kUsernamekey  = "username"
    static let kEmailKey     = "email"
    static let kIdentityKey  = "identity"
    static let kDetailKey    = "Detail"
    static let kNameKey      = "name"
    static let kAvatarURLKey = "avatar"
    static let kFinishNumKey = "finish_num"
    static let kScoreKey     = "score"
    static let kHobbiesKey   = "hobbies"
}

class UserDetail: NSObject {
    let userID: Int!
    let username: String!
    let email: String!
    let identity: UserIdentity!
    let name: String!
    let avatarURL: String!
    let finishedNumber: Int!
    let score: Int!
    let hobbies: [Hobby]
    
    init(JSON: Dictionary<String, JSON>) {
        let generalPartJSON = JSON[UserDetailJSONParsingKeys.kGeneralKey]!.dictionary!
        self.userID         = generalPartJSON[UserDetailJSONParsingKeys.kUserIDKey]!.int!
        self.username       = generalPartJSON[UserDetailJSONParsingKeys.kUsernamekey]!.string!
        self.email          = generalPartJSON[UserDetailJSONParsingKeys.kEmailKey]!.string!
        self.identity       = UserIdentity(rawValue: generalPartJSON[UserDetailJSONParsingKeys.kIdentityKey]!.int!)
        
        let detailPartJSON  = JSON[UserDetailJSONParsingKeys.kDetailKey]!.dictionary!
        self.name           = detailPartJSON[UserDetailJSONParsingKeys.kNameKey]!.string!
        self.avatarURL      = detailPartJSON[UserDetailJSONParsingKeys.kAvatarURLKey]!.string!
        self.finishedNumber = detailPartJSON[UserDetailJSONParsingKeys.kFinishNumKey]!.int!
        self.score          = detailPartJSON[UserDetailJSONParsingKeys.kScoreKey]!.int!
        
        let hobbiesPartJSON  = JSON[UserDetailJSONParsingKeys.kHobbiesKey]!.array!
        var hobbies: [Hobby] = []
        for hobbyJSON in hobbiesPartJSON {
            let hobby        = Hobby(JSON: hobbyJSON.dictionary!)
            hobbies.append(hobby)
        }
        self.hobbies         = hobbies
    }
}
