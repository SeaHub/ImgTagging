//
//  ImageResult.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias TagName = String

struct ImageResultListJSONParsingKeys {
    static let kImageIDKey     = "i_id"
    static let kTagKey         = "tag"
    static let kAlternationKey = "Alternation"
}

class ImageResultList: NSObject {
    let imageID: Int!
    let tagNames: [TagName]!
    let alternation: Int!
    
    init(JSON: Dictionary<String, JSON>) {
        self.imageID            = JSON[ImageResultListJSONParsingKeys.kImageIDKey]!.int!
        self.alternation        = JSON[ImageResultListJSONParsingKeys.kAlternationKey]!.int!
        var tagDatas: [TagName] = []
        for idx in 1 ... 5 {
            let key             = "\(ImageResultListJSONParsingKeys.kTagKey)\(idx)"
            let aTagName        = JSON[key]!.string!
            tagDatas.append(aTagName)
        }
        self.tagNames           = tagDatas
    }
}
