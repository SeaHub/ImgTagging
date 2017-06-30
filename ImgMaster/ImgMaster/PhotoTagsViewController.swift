//
//  PhotoTagsViewController.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/30.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView
import Kingfisher
import PopupDialog

enum PhotoTagsViewControllerStyle {
    case result
    case tags
}

class PhotoTagsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var photo: Image!
    var style: PhotoTagsViewControllerStyle = .tags
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var maskView: UIView!
    private let indicator = NVActivityIndicatorView(frame: CGRect(x: 100, y: 100, width: 200, height: 100), type: .orbit, color: .white, padding: 0)
    private var statisticsResultList: ImageStatisticsResultList? = nil
    private var tagsDataSource: [ImageStatisticsResult]          = []
    private var resultList: ImageResultList? = nil
    private var resultDataSource: [String]   = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configureTableView() {
        switch self.style {
        case .tags:
            self.tableView.allowsSelection = true
        case .result:
            self.tableView.allowsSelection = false
        }
    }
    
    private func fetchData() {
        self.indicatorStartAnimating()
        if self.style == .tags {
            APIManager.getImageStatisticsResult(token: ImgMasterUtil.userToken!, imageID: photo.imageID, success: { (resultList) in
                self.indicatorStopAnimating()
                self.statisticsResultList = resultList
                self.tagsDataSource       = resultList.results
                self.tableView.reloadData()
                
            }) { (error) in
                self.indicatorStopAnimating()
                self.showErrorAlert()
                debugPrint(error.localizedDescription)
            }
            
        } else {
            APIManager.getImageResult(token: ImgMasterUtil.userToken!, imageID: photo.imageID, success: { (resultList) in
                self.indicatorStopAnimating()
                self.resultList       = resultList
                self.resultDataSource = resultList.tagNames
                self.tableView.reloadData()
                
            }, failure: { (error) in
                self.indicatorStopAnimating()
                self.showErrorAlert()
                debugPrint(error.localizedDescription)
            })
        }

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
    
    
    @IBAction func backButtonClickec(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableView Related
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kImageViewTableViewCellIdentifier, for: indexPath) as! ImageTableViewCell
            if let imageURLString = self.photo.url {
                let httpURL       = "http://\(imageURLString)?imageView2/1/w/\(Int(cell.cellImageView.bounds.width))/h/\(Int(cell.cellImageView.bounds.height))"
                let url           = URL(string: httpURL)
                _                 = cell.cellImageView.kf.setImage(with: url,
                                                            placeholder: nil,
                                                            options: [.transition(ImageTransition.fade(1))],
                                                            progressBlock: nil,
                                                            completionHandler: nil)
            }
            return cell
            
        } else {
            switch style {
            case .tags:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kLabelTableViewCellIdentifier, for: indexPath) as! LabelTableViewCell
                
                cell.cellLabel.text            = self.tagsDataSource[indexPath.row - 1].tag.name
                cell.cellDescriptionLabel.text = "tagged \(String(self.tagsDataSource[indexPath.row - 1].number)) times"
                return cell
                
            case .result:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kLabelTableViewCellIdentifier, for: indexPath) as! LabelTableViewCell
                
                if indexPath.row == self.resultDataSource.count {
                    cell.cellLabel.text = "Update \(String(self.resultList!.alternation)) times totally"
                } else {
                    cell.cellLabel.text = self.resultDataSource[indexPath.row - 1]
                }
                return cell
            }
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
        switch self.style {
        case .tags:
            return 1 + self.tagsDataSource.count
        case .result:
            return 1 + self.resultDataSource.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row > 0 {
            let alert         = PopupDialog(title: "Tips", message: "Do you want to update model?", image: nil)
            let cancelButton  = CancelButton(title: "OK") { }
            let confirmButton = DefaultButton(title: "CONFIRM") {
                APIManager.updateModel(token: ImgMasterUtil.userToken!, imageID: self.photo.imageID, tagID: self.tagsDataSource[indexPath.row - 1].tag.tagID, success: {
                    self.indicatorStopAnimating()
                    let alert         = PopupDialog(title: "Tips", message: "Update successfully", image: nil)
                    let cancelButton  = CancelButton(title: "OK") {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    alert.addButtons([cancelButton])
                    self.present(alert, animated: true, completion: nil)
                    
                }, failure: { (error) in
                    debugPrint(error)
                    self.indicatorStopAnimating()
                    self.showErrorAlert()
                })
            }
            alert.addButtons([confirmButton, cancelButton])
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func showErrorAlert() {
        let alert         = PopupDialog(title: "Tips", message: "An error occured, please retry later!", image: nil)
        let cancelButton  = CancelButton(title: "OK") { }
        alert.addButtons([cancelButton])
        self.present(alert, animated: true, completion: nil)
    }
}
