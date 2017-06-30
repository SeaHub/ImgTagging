//
//  AdminListViewController.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/30.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PopupDialog

class AdminListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var maskView: UIView!
    fileprivate var dataSource: [UserInfo] = []
    fileprivate let indicator = NVActivityIndicatorView(frame: CGRect(x: 100, y: 100, width: 200, height: 100), type: .orbit, color: .white, padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    func fetchData() {
        self.indicatorStartAnimating()
        APIManager.getAdminInfoList(token: ImgMasterUtil.userToken!, success: { (userInfos) in
            self.dataSource = userInfos
            self.tableView.reloadData()
            self.indicatorStopAnimating()
            
        }) { (error) in
            debugPrint(error)
            self.dataSource = []
            self.indicatorStopAnimating()
        }
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
}

extension AdminListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kLabelTableViewCellIdentifier, for: indexPath) as! LabelTableViewCell
        cell.cellLabel.text = ("\(indexPath.row). username: \(self.dataSource[indexPath.row].username!), mail: \(self.dataSource[indexPath.row].email!)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
