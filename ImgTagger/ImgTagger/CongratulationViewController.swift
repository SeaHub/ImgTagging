//
//  CongratulationViewController.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/30.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit

class CongratulationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func nextButtoClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
