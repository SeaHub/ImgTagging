//
//  Image.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias TagName = String

struct ImageJSONParsingKeys {
    static let kImageIDKey     = "i_id"
    static let kTagKey         = "tag"
    static let kAlternationKey = "Alternation"
}

class Image: NSObject {
    let imageID: Int!
    let tagNames: [TagName]!
    let alternation: Int!
    
    init(JSON: Dictionary<String, JSON>) {
        self.imageID            = JSON[ImageJSONParsingKeys.kImageIDKey]!.int!
        self.alternation        = JSON[ImageJSONParsingKeys.kAlternationKey]!.int!
        var tagDatas: [TagName] = []
        for idx in 1 ... 5 {
            let key             = "\(ImageJSONParsingKeys.kTagKey)\(idx)"
            let aTagName        = JSON[key]!.string!
            tagDatas.append(aTagName)
        }
        self.tagNames           = tagDatas
    }
}
