//
//  Score.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ScorePoint: Int {
    case levelAA = 0
    case levelA  = 1
    case levelBB = 2
    case levelB  = 4
    case levelCC = 5
    case levelC  = 6
    case levelDD = 7
    case levelD  = 8
    case levelEE = 9
    case levelE  = 10
}

struct ScoreJSONParsingKeys {
    static let kImageIDKey = "i_id"
    static let kScoreKey   = "score"
}

class Score: NSObject {
    let imageID: Int!
    let point: ScorePoint!
    
    init(imageID: Int!, point: ScorePoint!) {
        self.imageID = imageID
        self.point   = point
    }
    
    convenience init(JSON: Dictionary<String, JSON>) {
        self.init(imageID: JSON[ScoreJSONParsingKeys.kImageIDKey]!.int!,
                point: ScorePoint(rawValue: JSON[ScoreJSONParsingKeys.kScoreKey]!.int!))
    }
    
    func toJSON() -> [String: Any] {
        return [
            ScoreJSONParsingKeys.kImageIDKey: self.imageID,
            ScoreJSONParsingKeys.kScoreKey: self.point.rawValue
        ]
    }
}
