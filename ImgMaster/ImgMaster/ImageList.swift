//
//  ImageList.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ImageListJSONParsingKeys {
    static let kTotalKey       = "total"
    static let kPerPageKey     = "per_page"
    static let kCurrentPageKey = "current_page"
    static let kLastPageKey    = "last_page"
    static let kNextPageURLKey = "next_page_url"
    static let kPrevPageURLKey = "prev_page_url"
    static let kFromKey        = "from"
    static let kToKey          = "to"
    static let kDataKey        = "data"
}

class ImageList: NSObject {
    let totalPhotos: Int!
    let perPage: String!
    let currentPage: Int!
    let lastPage: Int!
    let nextPageURL: String?
    let prevPageURL: String?
    let from: Int!
    let to: Int!
    let images: [Image]!
    
    init(JSON: Dictionary<String, JSON>) {
        self.totalPhotos        = JSON[ImageListJSONParsingKeys.kTotalKey]!.int!
        self.perPage            = JSON[ImageListJSONParsingKeys.kPerPageKey]!.string!
        self.currentPage        = JSON[ImageListJSONParsingKeys.kCurrentPageKey]!.int!
        self.lastPage           = JSON[ImageListJSONParsingKeys.kLastPageKey]!.int!
        self.nextPageURL        = JSON[ImageListJSONParsingKeys.kNextPageURLKey]!.string
        self.prevPageURL        = JSON[ImageListJSONParsingKeys.kPrevPageURLKey]!.string
        self.from               = JSON[ImageListJSONParsingKeys.kFromKey]!.int!
        self.to                 = JSON[ImageListJSONParsingKeys.kTotalKey]!.int!
        let datas               = JSON[ImageListJSONParsingKeys.kDataKey]!.array!
        var imageDatas: [Image] = []
        for aData in datas {
            let aImage          = Image(JSON: aData.dictionary!)
            imageDatas.append(aImage)
        }
        self.images             = imageDatas
    }
}
