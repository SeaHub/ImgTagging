//
//  TaggedPushedData.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/28.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit

struct TaggedPushedDataJSONParsingKeys {
    static let kImageIDKey = "i_id"
    static let kTagNameKey = "t_name"
}

class TaggedPushedData: NSObject {
    let imageID: Int!
    let tagName: TagName!
    
    init(imageID: Int!, tagName: TagName) {
        self.imageID = imageID
        self.tagName = tagName
    }
    
    func toJSON() -> [String: Any] {
        return [
            TaggedPushedDataJSONParsingKeys.kImageIDKey: self.imageID,
            TaggedPushedDataJSONParsingKeys.kTagNameKey: self.tagName
        ]
    }
}
