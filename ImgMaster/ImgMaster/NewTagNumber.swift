//
//  NewTagNumber.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct NewTagNumberJSONParsingKeys {
    static let kTotalKey = "total"
    static let kMonthKey = "month"
    static let kTodayKey = "today"
}

class NewTagNumber: NSObject {
    let total: Int!
    let today: Int!
    let month: Int!
    
    init(JSON: Dictionary<String, JSON>) {
        self.total = JSON[NewTagNumberJSONParsingKeys.kTotalKey]!.int!
        self.today = JSON[NewTagNumberJSONParsingKeys.kTodayKey]!.int!
        self.month = JSON[NewTagNumberJSONParsingKeys.kMonthKey]!.int!
    }
}
