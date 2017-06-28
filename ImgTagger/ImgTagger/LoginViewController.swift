//
//  LoginViewController.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/28.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        let homeViewController                 = ImgTaggerUtil.mainStoryborad.instantiateViewController(withIdentifier: ConstantStroyboardIdentifier.kHomeViewControllerIdentifier)
        let appDelegate                        = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = homeViewController
    }
}
