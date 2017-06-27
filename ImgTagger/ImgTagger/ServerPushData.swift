//
//  ServerPushData.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/27.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ServerPushDataJSONParsingKeys {
    static let kImageIDKey     = "i_id"
    static let kImageURLKey    = "url"
    static let kFilenamekey    = "filename"
    static let kCreatedAtKey   = "created_at"
    static let kUpadatedAtKey  = "updated_at"
    static let kImageKey       = "finalTag"
}

class ServerPushData: NSObject {
    let imageID: Int!
    let imageURL: String!
    let filename: String!
    let image: Image!
    var createdAt: String? = nil
    var updatedAt: String? = nil
    
    init(JSON: Dictionary<String, JSON>) {
        self.imageID = JSON[ServerPushDataJSONParsingKeys.kImageIDKey]!.int!
        self.imageURL = JSON[ServerPushDataJSONParsingKeys.kImageURLKey]!.string!
        self.filename = JSON[ServerPushDataJSONParsingKeys.kFilenamekey]!.string!
        self.image = Image(JSON: JSON[ServerPushDataJSONParsingKeys.kImageKey]!.dictionary!)
        self.createdAt = JSON[ServerPushDataJSONParsingKeys.kCreatedAtKey]!.string
        self.updatedAt = JSON[ServerPushDataJSONParsingKeys.kUpadatedAtKey]!.string
    }
}
