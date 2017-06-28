//
//  TaggingViewController.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class TaggingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkNetworkStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func checkNetworkStatus() {
        ImgTaggerUtil.checkNetworkStatus(reachable: nil) {
            let banner = StatusBarNotificationBanner(title: "Network Break!", style: .danger)
            banner.show()
        }
    }

    @IBAction func backButtonClickec(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
