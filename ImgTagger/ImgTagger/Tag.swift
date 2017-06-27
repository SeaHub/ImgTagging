//
//  Tag.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit

class Tag: NSObject {
    let tagID: Int!
    let name: TagName!
    
    init(tagID: Int, tagName: TagName) {
        self.tagID = tagID
        self.name  = tagName
    }
}
