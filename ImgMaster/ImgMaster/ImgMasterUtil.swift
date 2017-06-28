//
//  ImgMasterUtil.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/27.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import Photos
import Alamofire

class ImgMasterUtil: NSObject {
    public class func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager           = PHImageManager.default()
        let options           = PHImageRequestOptions()
        options.version       = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    public class func checkNetworkStatus(reachable:(() -> ())?, notReachable:(() -> ())?) {
        let manager = NetworkReachabilityManager(host: "http://114.115.152.250:8080")
        
        manager?.listener = { status in
            switch status {
            case .notReachable:
                fallthrough
            case .unknown:
                if let notReachable = notReachable {
                    notReachable()
                    manager?.stopListening()
                }
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
    
    public class var userToken: String! {
        return UserDefaults.standard.object(forKey: AppConstant.kUserTokenIdentifier) as! String
    }
}
