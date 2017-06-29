//
//  Constants.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/24.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit

struct ConstantStoryboardSegue {
    static let kPresentSideMenuViewSegue                = "kPresentSideMenuViewSegue"
    static let kEmbedNavigationControllerSegue          = "kEmbedNavigationControllerSegue"
    static let kShowTaggingViewControllerSegue          = "kShowTaggingViewControllerSegue"
    static let kShowCompletionViewControllerSegue       = "kShowCompletionViewControllerSegue"
    static let kShowPasswordResetingViewControllerSegue = "kShowPasswordResetingViewControllerSegue"
    static let kShowNameChangingViewControllerSegue     = "kShowNameChangingViewControllerSegue"
    static let kShowHobbiesChangingViewControllerSegue  = "kShowHobbiesChangingViewControllerSegue"
}

struct ConstantStroyboardIdentifier {
    static let kHomeViewControllerIdentifier             = "kHomeViewControllerIdentifier"
    static let kMainViewControllerIdentifier             = "kMainViewControllerIdentifier"
    static let kAboutUsViewControllerIdentifier          = "kAboutUsViewControllerIdentifier"
    static let kSettingViewControllerIdentifier          = "kSettingViewControllerIdentifier"
    static let kAuthenticationViewControllerIdentifier   = "kAuthenticationViewControllerIdentifier"
}

struct AppConstant {
    static let kUserTokenIdentifier = "kUserTokenIdentifier"
}

struct ConstantUITableViewCellIdentifier {
    static let kImageViewTableViewCellIdentifier     = "kImageViewTableViewCellIdentifier"
    static let kLabelTableViewCellIdentifier         = "kLabelTableViewCellIdentifier"
    static let kTextFieldTableViewCellIdentifier     = "kTextFieldTableViewCellIdentifier"
    static let kNormalUITableViewCellIdentifier      = "kNormalUITableViewCellIdentifier"
    // Following static cells means not reuse
    static let kStaticSettingAvatarTableViewCell        = "kStaticSettingAvatarTableViewCell"
    static let kStaticSettingResetPasswordTableViewCell = "kStaticSettingResetPasswordTableViewCell"
    static let kStaticSettingChangeNameTableViewCell    = "kStaticSettingChangeNameTableViewCell"
    static let kStaticSettingChangeHobbiesTableViewCell = "kStaticSettingChangeHobbiesTableViewCell"
    static let kStaticLogoutTableViewCell               = "kStaticLogoutTableViewCell"
}
