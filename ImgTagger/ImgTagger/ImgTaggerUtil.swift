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

    public class var mainStoryborad: UIStoryboard! {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    public class var userToken: String? {
        return UserDefaults.standard.object(forKey: AppConstant.kUserTokenIdentifier) as! String?
    }
    
    public class func makeImageToSize(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
