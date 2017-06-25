//
//  Image.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ImageJSONParsingKeys {
    static let kImageIDKey   = "i_id"
    static let kURLKey       = "url"
    static let kFilenameKey  = "filename"
    static let kCreatedAtKey = "created_at"
    static let kUpdatedAtKey = "update_at"
}

class Image: NSObject {
    let imageID: Int!
    let url: String!
    let filename: String!
    let createdAt: String?
    let updatedAt: String?
    
    init(JSON: Dictionary<String, JSON>) {
        self.imageID   = JSON[ImageJSONParsingKeys.kImageIDKey]!.int!
        self.url       = JSON[ImageJSONParsingKeys.kURLKey]!.string!
        self.filename  = JSON[ImageJSONParsingKeys.kFilenameKey]?.string!
        self.createdAt = JSON[ImageJSONParsingKeys.kCreatedAtKey]!.string
        self.updatedAt = JSON[ImageJSONParsingKeys.kUpdatedAtKey]!.string
    }
}
