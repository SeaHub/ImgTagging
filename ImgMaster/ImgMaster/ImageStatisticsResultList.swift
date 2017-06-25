//
//  ImageStatisticsResult.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/25.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ImageStatisticsResultListJSONParsingKeys {
    static let kSumKey  = "sum"
    static let kDataKey = "data"
}

class ImageStatisticsResultList: NSObject {
    let sum: Int!
    let results: [ImageStatisticsResult]!
    
    init(JSON: Dictionary<String, JSON>) {
        self.sum       = JSON[ImageStatisticsResultListJSONParsingKeys.kSumKey]!.int!
        let datas      = JSON[ImageStatisticsResultListJSONParsingKeys.kDataKey]!.array!
        var resultDatas: [ImageStatisticsResult] = []
        for aData in datas {
            let result = ImageStatisticsResult(JSON: aData.dictionary!)
            resultDatas.append(result)
        }
        self.results   = resultDatas
    }
}
