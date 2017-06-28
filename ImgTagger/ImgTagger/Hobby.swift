//
//  Hobby.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

enum HobbyWeight: Int {
    case highest = 0
    case normal  = 1
    case low     = 2
    case lowest  = 3
}

struct HobbyJSONParsingKeys {
    static let kHIDKey       = "h_id"
    static let kUserIDKey    = "userId"
    static let kHobbyNameKey = "hobby_name"
    static let kWeightKey    = "weight"
}

class Hobby: NSObject {
    let hobbyID: Int!
    let userID: Int!
    let name: String!
    let weight: HobbyWeight!
    
    init(hobbyName: String, hobbyWeight: HobbyWeight) {
        self.hobbyID = -1
        self.userID  = -1
        self.name    = hobbyName
        self.weight  = hobbyWeight
    }
    
    init(JSON: Dictionary<String, JSON>) {
        self.hobbyID = JSON[HobbyJSONParsingKeys.kHIDKey]!.int!
        self.userID  = JSON[HobbyJSONParsingKeys.kUserIDKey]!.int!
        self.name    = JSON[HobbyJSONParsingKeys.kHobbyNameKey]!.string!
        self.weight  = HobbyWeight(rawValue: JSON[HobbyJSONParsingKeys.kWeightKey]!.int!)
    }
    
    func toJSON() -> [String: Any] {
        return [
            HobbyJSONParsingKeys.kHobbyNameKey: self.name,
            HobbyJSONParsingKeys.kWeightKey: NSNumber(integerLiteral: self.weight.rawValue)
        ]
    }
}
