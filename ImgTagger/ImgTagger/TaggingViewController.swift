//
//  TaggingViewController.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView
import Kingfisher
import PopupDialog

class TaggingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var pushingPolicy: PushingPolicy?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var maskView: UIView!
    
    private var indicator: NVActivityIndicatorView! = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .pacman, color: .white, padding: nil)
    private var pushedDatas: [ServerPushData]   = []
    private var resultDatas: [TaggedPushedData] = []
    private var currentData: ServerPushData?    = nil
    private var currentTaggingIndex             = 0
    private var userCustomAnswerTextField: UITextField!
    private let kDefaultColors                  = [
        UIColor(colorLiteralRed: 0.0 / 255.0, green: 255.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0),
        UIColor(colorLiteralRed: 255.0 / 255.0, green: 88.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0),
        UIColor(colorLiteralRed: 204.0 / 255.0, green: 255.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    ]
    private let kDefaultTitles                  = ["A. ", "B. ", "C. ", "D. ", "E. "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureIndicator()
        self.configureTableView()
    }
    
    private func configureTableView() {
        let tableVC = UITableViewController.init(style: .plain)
        tableVC.tableView = self.tableView
        self.addChildViewController(tableVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getPushData()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func indicatorStartAnimating() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.backgroundColor = self.kDefaultColors[self.pushingPolicy!.rawValue]
            self.maskView.alpha           = 0.5
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
    
    private func getPushData() {
        switch self.pushingPolicy ?? .sequently {
        case .sequently:
            self.getPushDataSequently()
        case .onHobbies:
            self.getPushDataOnHobbies()
        case .onScores:
            self.getPushDataOnScores()
        }
    }
        
    private func getPushDataSequently() {
        debugPrint("getPushDataSequently")
        
        self.indicatorStartAnimating()
        APIManager.getServerPushedDataSequently(token: ImgTaggerUtil.userToken!, number: 10, success: { (pushedDatas) in
            self.indicatorStopAnimating()
            self.currentTaggingIndex = 0;
            if let pushedDatas = pushedDatas {
                self.pushedDatas = pushedDatas
                self.currentData = self.pushedDatas[self.currentTaggingIndex]
                self.tableView.reloadData()
                
            } else {
                self.pushedDatas = []
                self.currentData = nil
                let banner       = StatusBarNotificationBanner(title: "The mission has been completed!", style: .success)
                banner.show()
            }
            
        }) { (error) in
            self.indicatorStopAnimating()
            self.pushedDatas = []
            self.currentData = nil
            let banner       = StatusBarNotificationBanner(title: "An error occurred, please retry a moment after!", style: .danger)
            banner.show()
        }
    }
    
    private func getPushDataOnHobbies() {
        debugPrint("getPushDataOnHobbies")
        
        self.indicatorStartAnimating()
        APIManager.getServerPushedDataOnHobbies(token: ImgTaggerUtil.userToken!, number: 10, success: { (pushedDatas) in
            self.currentTaggingIndex = 0;
            self.indicatorStopAnimating()
            if let pushedDatas = pushedDatas {
                self.pushedDatas = pushedDatas
                self.currentData = self.pushedDatas[self.currentTaggingIndex]
                self.tableView.reloadData()
                
            } else {
                self.pushedDatas = []
                let banner       = StatusBarNotificationBanner(title: "The mission has been completed!", style: .success)
                banner.show()
            }
            
        }) { (error) in
            self.indicatorStopAnimating()
            self.pushedDatas = []
            let banner       = StatusBarNotificationBanner(title: "An error occurred, please retry a moment after!", style: .danger)
            banner.show()
        }
    }
    
    private func getPushDataOnScores() {
        debugPrint("getPushDataOnScores")
        
        self.indicatorStartAnimating()
        APIManager.getServerPushedDataOnScores(token: ImgTaggerUtil.userToken!, number: 10, minPoint: .levelEE, success: { (pushedDatas) in
            self.currentTaggingIndex = 0;
            self.indicatorStopAnimating()
            if let pushedDatas = pushedDatas {
                self.pushedDatas = pushedDatas
                self.currentData = self.pushedDatas[self.currentTaggingIndex]
                self.tableView.reloadData()
                
            } else {
                self.pushedDatas = []
                let banner       = StatusBarNotificationBanner(title: "The mission has been completed!", style: .success)
                banner.show()
            }
            
        }) { (error) in
            self.indicatorStopAnimating()
            self.pushedDatas = []
            let banner       = StatusBarNotificationBanner(title: "An error occurred, please retry a moment after!", style: .danger)
            banner.show()
        }
    }

    @IBAction func backButtonClickec(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableView Related
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.pushedDatas.count > 0 else { return UITableViewCell() }
        if indexPath.row == 0 {
            let imageTableViewCell: ImageTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kImageViewTableViewCellIdentifier, for: indexPath) as! ImageTableViewCell
            if let currentData = self.currentData, let imageURL = currentData.imageURL {
                let url = URL(string: "http://\(imageURL)?imageView2/1/w/304/h/270")!
                self.indicatorStartAnimating()
                _ = imageTableViewCell.cellImageView.kf.setImage(with: url,
                                                                 placeholder: nil,
                                                                 options: [.transition(ImageTransition.fade(1))], progressBlock: nil,
                                                                 completionHandler: { (_, _, _, _) in
                                                                    self.indicatorStopAnimating()
                })
            }
            return imageTableViewCell
        
        } else if indexPath.row >= 1 && indexPath.row <= 5 {
            let labelTableViewCell: LabelTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kLabelTableViewCellIdentifier, for: indexPath) as! LabelTableViewCell
            if let currentData = self.currentData, let imageData = currentData.image {
                labelTableViewCell.cellLabel.text      = "\(self.kDefaultTitles[indexPath.row - 1])\(String(describing: imageData.tagNames[indexPath.row - 1]))"
            } else {
                labelTableViewCell.cellLabel.text      = ""
            }
            return labelTableViewCell
        
        } else if indexPath.row == 6 {
            let textFieldTableViewCell: TextFieldTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kTextFieldTableViewCellIdentifier, for: indexPath) as! TextFieldTableViewCell
            self.userCustomAnswerTextField                     = textFieldTableViewCell.cellTextField
            return textFieldTableViewCell
        
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 286.0
        default:
            return 50.0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard self.pushedDatas.count > 0 else {
                return 0
            }
            
            if let imageData = self.pushedDatas[self.currentTaggingIndex].image, let tagNames = imageData.tagNames {
                return 1 + tagNames.count + 1
            } else {
                return 2
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row >= 1 && indexPath.row <= 5 {
            if self.currentTaggingIndex < self.pushedDatas.count - 1 {
                if let currentData = self.currentData, let imageData = currentData.image {
                    debugPrint(imageData.tagNames[indexPath.row - 1])
                    let taggedData = TaggedPushedData(imageID: currentData.imageID, tagName: imageData.tagNames[indexPath.row - 1])
                    self.resultDatas.append(taggedData)
                }
                
                self.currentTaggingIndex += 1
                debugPrint("\(self.currentTaggingIndex) / \(self.pushedDatas.count)")
                self.currentData          = self.pushedDatas[self.currentTaggingIndex]
                UIView.transition(with: self.tableView,
                                  duration: 0.35,
                                  options: .transitionCrossDissolve,
                                  animations: { self.tableView.reloadData() })
            
            } else {
                self.indicatorStartAnimating()
                APIManager.tagPushedData(token: ImgTaggerUtil.userToken!, tags: self.resultDatas, success: {
                    debugPrint(self.resultDatas)
                    self.indicatorStopAnimating()
                    self.performSegue(withIdentifier: ConstantStoryboardSegue.kShowCompletionViewControllerSegue, sender: self)
                    
                }, failure: { (error) in
                    self.indicatorStopAnimating()
                    self.showErrorAlert()
                })
            }
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if self.currentTaggingIndex < self.pushedDatas.count - 1 {
            if let currentData = self.currentData, let answer = self.userCustomAnswerTextField.text {
                
                let taggedData = TaggedPushedData(imageID: currentData.imageID, tagName: answer)
                self.resultDatas.append(taggedData)
                self.userCustomAnswerTextField.text = ""
            }
            
            self.currentTaggingIndex += 1
            debugPrint("\(self.currentTaggingIndex) / \(self.pushedDatas.count)")
            self.currentData          = self.pushedDatas[self.currentTaggingIndex]
            UIView.transition(with: self.tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
            
        } else {
            self.indicatorStartAnimating()
            APIManager.tagPushedData(token: ImgTaggerUtil.userToken!, tags: self.resultDatas, success: {
                debugPrint(self.resultDatas)
                self.indicatorStopAnimating()
                self.performSegue(withIdentifier: ConstantStoryboardSegue.kShowCompletionViewControllerSegue, sender: self)
                
            }, failure: { (error) in
                self.indicatorStopAnimating()
                self.showErrorAlert()
            })
        }
    }
    
    private func showErrorAlert() {
        let alert         = PopupDialog(title: "Tips", message: "An error occured, please retry later!", image: nil)
        let cancelButton  = CancelButton(title: "OK") { }
        alert.addButtons([cancelButton])
        self.present(alert, animated: true, completion: nil)
    }
}
