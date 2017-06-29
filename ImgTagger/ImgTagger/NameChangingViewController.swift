//
//  NameChangingViewController.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/30.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PopupDialog

class NameChangingViewController: UIViewController {

    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    private var indicator: NVActivityIndicatorView! = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballScaleRippleMultiple, color: .white, padding: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureIndicator()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func indicatorStartAnimating() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0.5
        }
    }
    
    private func indicatorStopAnimating() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
            self.indicator.stopAnimating()
        }
    }
    
    private func configureIndicator() {
        self.indicator.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        self.maskView.addSubview(self.indicator)
        self.indicator.startAnimating()
    }
    
    private func showErrorAlert() {
        let alert         = PopupDialog(title: "Tips", message: "An error occured, please retry later!", image: nil)
        let cancelButton  = CancelButton(title: "OK") { }
        alert.addButtons([cancelButton])
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func commitButtonClicked(_ sender: Any) {
        if let name = self.nameTextField.text {
            
            self.indicatorStopAnimating()
            APIManager.modifyInfo(token: ImgTaggerUtil.userToken!, name: name, avatarImage: nil, success: { 
                self.indicatorStopAnimating()
                let alert         = PopupDialog(title: "Tips", message: "Change successfully", image: nil)
                let cancelButton  = DefaultButton(title: "OK") {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addButtons([cancelButton])
                self.present(alert, animated: true, completion: nil)
                
            }, failure: { (error) in
                self.indicatorStopAnimating()
                debugPrint(error.localizedDescription)
                self.showErrorAlert()
            })
        }
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Keyboard Related
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
