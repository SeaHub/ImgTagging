//
//  ImgTaggerUtil.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/27.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import Alamofire

class ImgTaggerUtil: NSObject {
    
    public class func checkNetworkStatus(reachable:(() -> ())?, notReachable:(() -> ())?) {
        let manager = NetworkReachabilityManager(host: "http://114.115.152.250:8080")
        
        manager?.listener = { status in
            switch status {
            case .notReachable:
                if let notReachable = notReachable {
                    notReachable()
                    manager?.stopListening()
                }
            case .unknown:
                fallthrough
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                fallthrough
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                if let reachable = reachable {
                    reachable()
                    manager?.stopListening()
                }
            }
        }
        
        manager?.startListening()
    }

    public class var mainStoryborad: UIStoryboard! {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    public class var userToken: String? {
        return UserDefaults.standard.object(forKey: AppConstant.kUserTokenIdentifier) as! String?
    }
}
