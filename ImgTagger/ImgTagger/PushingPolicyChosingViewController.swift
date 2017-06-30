//
//  PushingPolicyChosingViewController.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import PopupDialog
import NotificationBannerSwift

enum PushingPolicy: Int {
    case sequently = 0
    case onHobbies = 1
    case onScores  = 2
}

class PushingPolicyChosingViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var pushingSequentlyView: UIImageView!
    @IBOutlet weak var pushingOnHobbiesView: UIImageView!
    @IBOutlet weak var pushingOnScoresView: UIImageView!
    private var pushingPolicy: PushingPolicy = .sequently
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addGestures() {
        let tapGesture                  = UITapGestureRecognizer(target: self, action: #selector(showConfirmAlert(tapGestureRecognizer:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = true
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showConfirmAlert(tapGestureRecognizer: UITapGestureRecognizer) {
        let points = tapGestureRecognizer.location(in: self.view)
        if self.pushingSequentlyView.frame.minY <= points.y
            && self.pushingSequentlyView.frame.maxY >= points.y {
            self.pushingPolicy = .sequently
            
        } else if self.pushingOnHobbiesView.frame.minY <= points.y
            && self.pushingOnHobbiesView.frame.maxY >= points.y  {
            self.pushingPolicy = .onHobbies
            
        } else if self.pushingOnScoresView.frame.minY <= points.y
            && self.pushingOnScoresView.frame.maxY >= points.y {
            self.pushingPolicy = .onScores
            
        } else {
            debugPrint("Undefined")
        }
        
        let alert         = PopupDialog(title: "Tips", message: "Are you sure to start tagging using this policy?", image: nil)
        let cancelButton  = CancelButton(title: "CANCEL") { }
        let confirmButton = DefaultButton(title: "SURE") {
            self.performSegue(withIdentifier: ConstantStoryboardSegue.kShowTaggingViewControllerSegue,
                              sender: self.pushingPolicy)
        }
        alert.addButtons([confirmButton, cancelButton])
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ConstantStoryboardSegue.kShowTaggingViewControllerSegue {
            let taggingViewController           = segue.destination as! TaggingViewController
            taggingViewController.pushingPolicy = self.pushingPolicy
        }
    }
}
