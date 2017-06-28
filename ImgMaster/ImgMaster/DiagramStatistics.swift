//
//  DiagramStatistics.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SwiftyJSON

struct DiagramStatisticsParsingKeys {
    static let kRegisterNumberKey   = "RegisterNum"
    static let kNewImageNumberKey   = "AddImageNum"
    static let kNewTagNumberKey     = "AddTagNum"
    static let kImageTagNumberKey   = "ImageAndTag"
    static let kUserTagNumberKey    = "UserAndTag"
}

class DiagramStatistics: NSObject {
    let registerNumber: RegisterNumber!
    let newImageNumber: NewImageNumber!
    let newTagNumber: NewTagNumber!
    let imageTagNumber: ImageTagNumber!
    let userTagNumber: UserTagNumber!
    
    init(JSON: Dictionary<String, JSON>) {
        self.registerNumber = RegisterNumber(JSON: JSON[DiagramStatisticsParsingKeys.kRegisterNumberKey]!.dictionary!)
        self.newImageNumber = NewImageNumber(JSON: JSON[DiagramStatisticsParsingKeys.kNewImageNumberKey]!.dictionary!)
        self.newTagNumber   = NewTagNumber(JSON: JSON[DiagramStatisticsParsingKeys.kNewTagNumberKey]!.dictionary!)
        self.imageTagNumber = ImageTagNumber(JSON: JSON[DiagramStatisticsParsingKeys.kImageTagNumberKey]!.dictionary!)
        self.userTagNumber  = UserTagNumber(JSON: JSON[DiagramStatisticsParsingKeys.kUserTagNumberKey]!.dictionary!)
    }
}
