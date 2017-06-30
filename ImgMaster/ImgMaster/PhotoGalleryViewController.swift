//
//  PhotoGalleryViewController.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/27.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import Kingfisher
import PopupDialog
import NVActivityIndicatorView

class PhotoGalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var maskView: UIView!
    fileprivate var photos: [Image]       = []
    fileprivate var imageList: ImageList? = nil
    fileprivate var style: PhotoTagsViewControllerStyle = .tags
    private let indicator = NVActivityIndicatorView(frame: CGRect(x: 100, y: 100, width: 200, height: 100), type: .orbit, color: .white, padding: 0)
    
    lazy var sizes: [CGSize] = {
        return (0 ..< self.photos.count).map { _ in
            return CGSize(width: floor((UIScreen.main.bounds.width - (4 * 10)) / 3), height: floor((UIScreen.main.bounds.width - (4 * 10)) / 3))
        }
    }()
    
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
    
    private func fetchData() {
        self.indicatorStartAnimating()
        
        APIManager.getImageList(token: ImgMasterUtil.userToken!, currentPage: "1", perPage: "99999", success: { (imageList) in
            
            self.indicatorStopAnimating()
            self.imageList = imageList
            self.photos    = imageList.images
            self.collectionView.reloadData()
            
        }) { (error) in
            debugPrint(error)
            self.indicatorStopAnimating()
            self.showErrorAlert()
        }
    }
    
    fileprivate func showErrorAlert() {
        let alert         = PopupDialog(title: "Tips", message: "An error occured, please retry later!", image: nil)
        let cancelButton  = CancelButton(title: "OK") { }
        alert.addButtons([cancelButton])
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func indicatorStartAnimating() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0.5
        }
    }
    
    fileprivate func indicatorStopAnimating() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
            self.indicator.stopAnimating()
        }
    }
    
    fileprivate func configureIndicator() {
        self.indicator.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        self.maskView.addSubview(self.indicator)
        self.indicator.startAnimating()
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        self.fetchData()
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ConstantStoryboardSegue.kShowPhotoTagControllerSegue {
            let dvc   = segue.destination as! PhotoTagsViewController
            dvc.photo = sender! as! Image
            dvc.style = self.style
        }
    }
}

extension PhotoGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantUICollectionCellIdentifier.kCollectionImageViewCellIdentifier, for: indexPath) as! CollectionImageViewCell
        if let imageURLString = self.photos[indexPath.row].url {
            let httpURL       = "http://\(imageURLString)?imageView2/1/w/50/h/50"
            let url           = URL(string: httpURL)
            _                 = cell.imageView.kf.setImage(with: url,
                                                    placeholder: nil,
                                                        options: [.transition(ImageTransition.fade(1))],
                                                  progressBlock: nil,
                                              completionHandler: nil)
        }
        return cell
    }
    
}

extension PhotoGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint(indexPath)
        APIManager.doStatistics(token: ImgMasterUtil.userToken!, imageID: self.photos[indexPath.row].imageID, success: {
            let alert                = PopupDialog(title: "Tips", message: "What do you want to do?", image: nil)
            let seeCurrentTagsButton = DefaultButton(title: "See current tags") {
                self.style           = .tags
                self.performSegue(withIdentifier: ConstantStoryboardSegue.kShowPhotoTagControllerSegue, sender: self.photos[indexPath.row])
            }
            
            let seeResultButton      = DefaultButton(title: "See result") {
                self.style           = .result
                self.performSegue(withIdentifier: ConstantStoryboardSegue.kShowPhotoTagControllerSegue, sender: self.photos[indexPath.row])
            }
            let cancelButton  = CancelButton(title: "CANCEL") { }
            
            alert.addButtons([seeCurrentTagsButton, seeResultButton, cancelButton])
            self.present(alert, animated: true, completion: nil)
            
        }) { (error) in
            debugPrint(error)
            self.indicatorStopAnimating()
            self.showErrorAlert()
        }
    }
}

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizes[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
