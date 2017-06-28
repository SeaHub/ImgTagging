//
//  UserTagNumber.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct UserTagNumberJSONParsingKeys {
    static let kTagNumberKey  = "tag"
    static let kUserNumberKey = "user"
}

class UserTagNumber: NSObject {
    let tagNumber: Int!
    let userNumber: Int!
    
    init(JSON: Dictionary<String, JSON>) {
        self.tagNumber  = JSON[UserTagNumberJSONParsingKeys.kTagNumberKey]!.int!
        self.userNumber = JSON[UserTagNumberJSONParsingKeys.kUserNumberKey]!.int!
    }
}
