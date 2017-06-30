//
//  AuthenticationViewController.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import NVActivityIndicatorView

enum AMLoginSignupViewMode {
    case login
    case signup
}

class AuthenticationViewController: UIViewController {
    
    let animationDuration           = 0.25
    var mode: AMLoginSignupViewMode = .signup
    
    
    // MARK: - Constraints
    @IBOutlet weak var backImageLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupContentView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButtomInSingupConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgotPassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialsView: UIView!
    @IBOutlet weak var loginEmailInputView: AMInputView!
    @IBOutlet weak var loginPasswordInputView: AMInputView!
    @IBOutlet weak var signupEmailInputView: AMInputView!
    @IBOutlet weak var signupPasswordInputView: AMInputView!
    @IBOutlet weak var signupPasswordConfirmInputView: AMInputView!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var sendVcodeButton: UIButton!
    private let indicator = NVActivityIndicatorView(frame: CGRect(x: 100, y: 100, width: 200, height: 100), type: .orbit, color: .white, padding: 0)
    
    // MARK: - controller
    override func viewDidLoad() {
        super.viewDidLoad()
        configureIndicator()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboarFrameChange(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - button actions
    @IBAction func loginButtonTouchUpInside(_ sender: AnyObject) {
        self.indicatorStartAnimating()
        
        self.indicatorStartAnimating()
        APIManager.login(username: loginEmailInputView.textFieldView.text!, password: loginPasswordInputView.textFieldView.text!, success: { (user) in
            self.indicatorStopAnimating()
            
            if user.identity == .normal {
                let banner = StatusBarNotificationBanner(title: "An error occurer, only administrator can login ImgMaster!", style: .danger)
                banner.show()
                
            } else {
                UserDefaults.standard.setValue(user.token, forKey: AppConstant.kUserTokenIdentifier)
                let homeViewController                 = ImgMasterUtil.mainStoryborad.instantiateViewController(withIdentifier: ConstantStroyboardIdentifier.kHomeViewControllerIdentifier)
                let appDelegate                        = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = homeViewController
            }
            
        }) { (error) in
            self.indicatorStopAnimating()
            let banner = StatusBarNotificationBanner(title: "Please input phone and password correctly!", style: .danger)
            banner.show()
        }

    }
    
    // MARK: - keyboard
    func keyboarFrameChange(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        
        // get top of keyboard in view
        let topOfKetboard = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue .origin.y
        
        
        // get animation curve for animate view like keyboard animation
        var animationDuration: TimeInterval = 0.25
        var animationCurve: UIViewAnimationCurve = .easeOut
        if let animDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            animationDuration = animDuration.doubleValue
        }
        
        if let animCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationCurve =  UIViewAnimationCurve.init(rawValue: animCurve.intValue)!
        }
        
        
        // check keyboard is showing
        let keyboardShow = topOfKetboard != self.view.frame.size.height
        
        
        //hide logo in little devices
        let hideLogo = self.view.frame.size.height < 667
        
        // set constraints
        logoTopConstraint.constant        = keyboardShow ? (hideLogo ? 0:20):50
        logoHeightConstraint.constant     = keyboardShow ? (hideLogo ? 0:40):60
        logoBottomConstraint.constant     = keyboardShow ? 20:32
        forgotPassTopConstraint.constant  = keyboardShow ? 30:45
        loginButtonTopConstraint.constant = keyboardShow ? 25:30
        loginButton.alpha                 = keyboardShow ? 1:0.7
        
        // animate constraints changes
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        
        self.view.layoutIfNeeded()
        
        UIView.commitAnimations()
    }
    
    // MARK: - hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Custom
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
}
