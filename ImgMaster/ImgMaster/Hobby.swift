//
//  Hobby.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct HobbyJSONParsingKeys {
    static let kHIDKey       = "h_id"
    static let kHobbyNameKey = "hobby_name"
    static let kWeightKey    = "weight"
}

class Hobby: NSObject {
    let hobbyID: Int!
    let name: String!
    let weight: Int!
    
    init(JSON: Dictionary<String, JSON>) {
        self.hobbyID = JSON[HobbyJSONParsingKeys.kHIDKey]!.int!
        self.name    = JSON[HobbyJSONParsingKeys.kHobbyNameKey]!.string!
        self.weight  = JSON[HobbyJSONParsingKeys.kWeightKey]!.int!
    }
}
