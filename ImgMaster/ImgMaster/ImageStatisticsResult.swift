//
//  ImageStatisticsResult.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ImageStatisticsResultJSONParsingKeys {
    static let kStatisticsIDKey = "st_id"
    static let kImageIDKey      = "i_id"
    static let kTagIDKey        = "t_id"
    static let kNumberKey       = "num"
    static let kTagNameKey      = "t_name"
}

class ImageStatisticsResult: NSObject {
    let statisticsID: Int!
    let imageID: Int!
    let number: Int!
    let tag: Tag!
    
    init(JSON: Dictionary<String, JSON>) {
        self.statisticsID = JSON[ImageStatisticsResultJSONParsingKeys.kStatisticsIDKey]!.int!
        self.imageID      = JSON[ImageStatisticsResultJSONParsingKeys.kImageIDKey]!.int!
        self.number       = JSON[ImageStatisticsResultJSONParsingKeys.kNumberKey]!.int!
        let tagName       = JSON[ImageStatisticsResultJSONParsingKeys.kTagNameKey]!.string!
        let tagID         = JSON[ImageStatisticsResultJSONParsingKeys.kTagIDKey]!.int!
        self.tag          = Tag(tagID: tagID, tagName: tagName)
    }
}
