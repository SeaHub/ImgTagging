//
//  SettingViewController.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PopupDialog

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var maskView: UIView!
    private var indicator: NVActivityIndicatorView! = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballClipRotateMultiple, color: .white, padding: nil)
    private var userInfo: UserInfo? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.indicatorStartAnimating()
        APIManager.getUserInfo(token: ImgTaggerUtil.userToken!, success: { (userInfo) in
            self.indicatorStopAnimating()
            self.userInfo = userInfo
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            
        }) { (error) in
            self.indicatorStopAnimating()
            self.showErrorAlert()
            debugPrint(error.localizedDescription)
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
    
    @objc private func showImagePicker() {
        debugPrint("TODO")
    }
    
    // MARK: - UITableView Related
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell: SettingAvatarTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kStaticSettingAvatarTableViewCell, for: indexPath) as! SettingAvatarTableViewCell
            let tapGesutre                       = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
            tapGesutre.numberOfTapsRequired               = 1
            tapGesutre.cancelsTouchesInView               = false
            cell.selectionStyle                           = .none
            cell.avatarImageView.isUserInteractionEnabled = true
            cell.avatarImageView.addGestureRecognizer(tapGesutre)
            
            if let userInfo = self.userInfo {
                cell.configureCell(userInfo: userInfo)
            }
            
            return cell
            
        case (1, 0):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kStaticSettingResetPasswordTableViewCell, for: indexPath)
            return cell
            
        case (1, 1):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kStaticSettingChangeNameTableViewCell, for: indexPath)
            return cell
            
        case (1, 2):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kStaticSettingChangeHobbiesTableViewCell, for: indexPath)
            return cell
            
        case (2, 0):
            let cell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kStaticLogoutTableViewCell, for: indexPath)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 130.0
        default:
            return 44.0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            self.performSegue(withIdentifier: ConstantStoryboardSegue.kShowPasswordResetingViewControllerSegue, sender: self)
        case (1, 1):
            self.performSegue(withIdentifier: ConstantStoryboardSegue.kShowNameChangingViewControllerSegue, sender: self)
        case (1, 2):
            self.performSegue(withIdentifier: ConstantStoryboardSegue.kShowHobbiesChangingViewControllerSegue, sender: self)
        case (2, 0):
            self.logout()
        default:
            debugPrint(indexPath)
        }
    }
    
    private func logout() {
        let alert         = PopupDialog(title: "Tips", message: "Are you confirm to do so?", image: nil)
        let confirmButton = DefaultButton(title: "Confirm") {
            self.indicatorStartAnimating()
            APIManager.logout(token: ImgTaggerUtil.userToken!, success: {
                self.indicatorStopAnimating()
                UserDefaults.standard.setValue(nil, forKey: AppConstant.kUserTokenIdentifier)
                let authenticationViewController       = ImgTaggerUtil.mainStoryborad.instantiateViewController(withIdentifier: ConstantStroyboardIdentifier.kAuthenticationViewControllerIdentifier)
                let appDelegate                        = UIApplication.shared.delegate as! AppDelegate
                UIView.animate(withDuration: 0.5, animations: {
                    appDelegate.window?.rootViewController = authenticationViewController
                })
                
            }, failure: { (error) in
                self.indicatorStopAnimating()
                debugPrint(error.localizedDescription)
                self.showErrorAlert()
            })
        }
        let cancelButton  = CancelButton(title: "Cancel") { }
        alert.addButtons([confirmButton, cancelButton])
        self.present(alert, animated: true, completion: nil)
    }
}
