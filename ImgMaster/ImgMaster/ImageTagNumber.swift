//
//  ImageTagNumber.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ImageTagNumberJSONParsingKeys {
    static let kTagNumberKey   = "tag"
    static let kImageNumberKey = "image"
}

class ImageTagNumber: NSObject {
    let tagNumber: Int!
    let imageNumber: Int!
    
    init(JSON: Dictionary<String, JSON>) {
        self.tagNumber   = JSON[ImageTagNumberJSONParsingKeys.kTagNumberKey]!.int!
        self.imageNumber = JSON[ImageTagNumberJSONParsingKeys.kImageNumberKey]!.int!
    }
}
