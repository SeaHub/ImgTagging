//
//  HomeViewController.swift
//  ImgMaster
//
//  Created by SeaHub on 2017/6/24.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    fileprivate var selectedIndex = 0
    fileprivate var transitionPoint: CGPoint!
    fileprivate var aNavigationController: UINavigationController!
    
    lazy fileprivate var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (.some(ConstantStoryboardSegue.kPresentSideMenuViewSegue), let menuView as MenuViewController):
            menuView.selectedItem           = self.selectedIndex
            menuView.delegate               = self
            menuView.transitioningDelegate  = self
            menuView.modalPresentationStyle = .custom
        case (.some(ConstantStoryboardSegue.kEmbedNavigationControllerSegue), let aNavigationController as UINavigationController):
            self.aNavigationController          = aNavigationController
            self.aNavigationController.delegate = self
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension HomeViewController: MenuViewControllerDelegate {
    
    func menu(_: MenuViewController, didSelectItemAt index: Int, at point: CGPoint) {

        self.transitionPoint = point
        self.selectedIndex   = index

        var currentContentController: UIViewController! = nil
        switch index {
        case 0:
            currentContentController       = storyboard!.instantiateViewController(withIdentifier: ConstantStroyboardIdentifier.kDigramsViewControllerIdentifier)
        case 1:
            currentContentController       = storyboard!.instantiateViewController(withIdentifier: ConstantStroyboardIdentifier.kUploadViewControllerIdentifier)
        case 2:
            currentContentController       = storyboard!.instantiateViewController(withIdentifier: ConstantStroyboardIdentifier.kGalleryViewControllerIdentifier)
        case 3:
            currentContentController       = storyboard!.instantiateViewController(withIdentifier: ConstantStroyboardIdentifier.kAboutUsViewControllerIdentifier)
            
        default:
            debugPrint("Error index \(index)")
        }
        
        aNavigationController.setViewControllers([currentContentController], animated: true)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    func menuDidCancel(_: MenuViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: UINavigationControllerDelegate {
    
    func navigationController(_: UINavigationController, animationControllerFor _: UINavigationControllerOperation,
        from _: UIViewController, to _: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if let transitionPoint = transitionPoint {
            return CircularRevealTransitionAnimator(center: transitionPoint)
        }
        return nil
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
        source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return menuAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
}
