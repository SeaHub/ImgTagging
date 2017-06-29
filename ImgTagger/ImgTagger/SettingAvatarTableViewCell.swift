//
//  SettingAvatarTableViewCell.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/30.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit
import Kingfisher

class SettingAvatarTableViewCell: UITableViewCell {

    @IBOutlet weak var scoreDescrptionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    func configureCell(userInfo: UserInfo) {
        if let imageURL = userInfo.avatarURL {
        let url = URL(string: "http://\(imageURL)")!
        debugPrint(url)
        _ = avatarImageView.kf.setImage(with: url,
                                 placeholder: UIImage(named: "defaultAvatar"),
                                     options: [.transition(ImageTransition.fade(1))],
                               progressBlock: nil,
                           completionHandler: nil)
        } else {
            avatarImageView.image      = UIImage(named: "defaultAvatar")
        }
        
        let token                      = ImgTaggerUtil.userToken!
        let subStringIndex             = token.index(token.startIndex, offsetBy: 5)
        self.usernameLabel.text        = userInfo.name ?? token.substring(to: subStringIndex)
        self.scoreLabel.text           = "\(judgeLevel(score: userInfo.score!))\(userInfo.score!) Points"
        self.scoreDescrptionLabel.text = "You have been tagged \(userInfo.finishNum!) photo(s)!"
    }
    
    func judgeLevel(score: Int) -> String {
        if score > 10 {
            return "Level 1  - "
        } else if score > 20 {
            return "Level 2  - "
        } else if score > 40 {
            return "Level 3  - "
        } else if score > 80 {
            return "Level 4  - "
        } else if score > 160 {
            return "Level 5  - "
        }
        
        return "Level 0 - "
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
