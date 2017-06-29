//
//  TextFieldTableViewCell.swift
//  ImgTagger
//
//  Created by SeaHub on 2017/6/29.
//  Copyright © 2017年 SeaCluster. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
