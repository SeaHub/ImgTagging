//
//  ImageUploadViewController.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/27.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker
import NVActivityIndicatorView

class ImageUploadViewController: UIViewController {

    @IBOutlet weak var uploadImageView: UIImageView!
    private let indicator = NVActivityIndicatorView(frame: CGRect(x: 100, y: 100, width: 200, height: 100), type: .orbit, color: .white, padding: 0)
    var maskView: UIView?
    var selectedUploadImages: [UIImage] = []
    let group                           = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func indicatorStartAnimating() {
        UIView.animate(withDuration: 0.5) {
            guard self.maskView == nil else { return }
            self.maskView                  = UIView(frame: self.view.frame)
            self.maskView!.backgroundColor = .black
            self.maskView!.alpha           = 0.8
            self.view.addSubview(self.maskView!)
            self.configureIndicator()
        }
    }
    
    private func indicatorStopAnimating() {
        UIView.animate(withDuration: 0.5) {
            guard self.maskView != nil else { return }
            self.maskView?.removeFromSuperview()
            self.maskView = nil
            self.indicator.stopAnimating()
        }
    }
    
    private func configureIndicator() {
        self.indicator.center = self.maskView!.center
        self.maskView!.addSubview(self.indicator)
        self.indicator.startAnimating()
    }

    private func configureGesture() {
        let tapGesture                                = UITapGestureRecognizer(target: self,
                                                                               action: #selector(uploadImageViewDidClciked))
        tapGesture.numberOfTapsRequired               = 1
        self.uploadImageView.isUserInteractionEnabled = true
        self.uploadImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func uploadImageViewDidClciked() {
        self.indicatorStartAnimating()

        let imagePickerViewController = BSImagePickerViewController()
        
        bs_presentImagePickerController(imagePickerViewController, animated: true, select: nil, deselect: nil, cancel: { (_) in
            
            DispatchQueue.main.async {
                self.indicatorStopAnimating()
            }
            
        }, finish: { (assets) in

            DispatchQueue.main.async(execute: {
                for asset in assets {
                    let aImage   = ImgMasterUtil.getUIImage(asset: asset)
                    if let image = aImage {
                        self.selectedUploadImages.append(image)
                    }
                }
                
                self.uploadImagesInBackground(images: self.selectedUploadImages, completionHandler: { (errors) in
                    if errors.count > 0 {
                        debugPrint((errors.first)!) // TODO: show msg
                    }
                    self.indicatorStopAnimating()
                })
            })
            
        }, completion: nil)
    }
    
    private func uploadImagesInBackground(images: [UIImage], completionHandler:((_ errors: [Error]) -> ())?) {
        DispatchQueue.global().async {
            
            let token           = ImgMasterUtil.userToken!
            var errors: [Error] = []
        
            for image in self.selectedUploadImages {
                self.group.enter()

                DispatchQueue.main.async {
                    
                    APIManager.uploadImage(token: token, image: image, success: {
                        self.group.leave()
                    
                    }, failure: { (error) in
                        errors.append(error)
                        self.group.leave()
                    })
                }

            }
            
            self.group.notify(queue: DispatchQueue.main) {
                if let completionHandler = completionHandler {
                    completionHandler(errors)
                }
            }
        }
    }
}
