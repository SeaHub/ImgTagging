//
//  HobbyChangingViewController.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/30.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PopupDialog

class HobbyChangingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newHobbyTextField: UITextField!
    private var indicator: NVActivityIndicatorView! = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .ballScaleRippleMultiple, color: .white, padding: nil)
    private var hobbies: [Hobby]        = []
    private var addedHobbies: [Hobby]   = []
    private var deletedHobbies: [Hobby] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getHobbiesFromNetwork()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getHobbiesFromNetwork() {
        self.indicatorStartAnimating()
        APIManager.getHobbies(token: ImgTaggerUtil.userToken!, success: { (hobbies) in
            self.indicatorStopAnimating()
            self.hobbies = hobbies
            self.tableView.reloadData()
            
        }) { (error) in
            self.indicatorStopAnimating()
            self.showErrorAlert()
            debugPrint(error.localizedDescription)
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
    
    private func showErrorAlert() {
        let alert         = PopupDialog(title: "Tips", message: "An error occured, please retry later!", image: nil)
        let cancelButton  = CancelButton(title: "OK") { }
        alert.addButtons([cancelButton])
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveHobbyButtonClicked(_ sender: Any) {
        self.indicatorStartAnimating()
        APIManager.addHobbies(token: ImgTaggerUtil.userToken!, hobbies: self.addedHobbies, success: {
            self.indicatorStopAnimating()
            // 添加删除兴趣逻辑
            let alert         = PopupDialog(title: "Tips", message: "Save successfully", image: nil)
            let cancelButton  = DefaultButton(title: "OK") {
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addButtons([cancelButton])
            self.present(alert, animated: true, completion: nil)
            
        }) { (error) in
            self.indicatorStopAnimating()
            self.showErrorAlert()
            debugPrint(error.localizedDescription)
        }

    }

    @IBAction func addHobbyButtonClicked(_ sender: Any) {
        if let newHobbyName = self.newHobbyTextField.text {
            let hobby                   = Hobby(hobbyName: newHobbyName, hobbyWeight: .highest)
            self.newHobbyTextField.text = ""
            
            self.hobbies.append(hobby)
            self.addedHobbies.append(hobby)
            self.tableView.insertRows(at: [IndexPath(row: self.hobbies.count - 1, section: 0)], with: .fade)
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - UITableView Related
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ConstantUITableViewCellIdentifier.kNormalUITableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.hobbies[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hobbies.count
    }
    
    // MARK: - Keyboard Related
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
