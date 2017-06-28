//
//  RegisterNumber.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct RegisterNumberJSONParsingKeys {
    static let kTotalKey = "total"
    static let kMonthKey = "month"
    static let kTodayKey = "today"
}

class RegisterNumber: NSObject {
    let total: Int!
    let today: Int!
    let month: Int!
    
    init(JSON: Dictionary<String, JSON>) {
        self.total = JSON[RegisterNumberJSONParsingKeys.kTotalKey]!.int!
        self.today = JSON[RegisterNumberJSONParsingKeys.kTodayKey]!.int!
        self.month = JSON[RegisterNumberJSONParsingKeys.kMonthKey]!.int!
    }
}
