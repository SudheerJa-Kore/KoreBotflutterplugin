//
//  CustomDropDownCell.swift
//  KoreBotSDKFrameWork
//
//  Created by Kartheek Pagidimarri on 02/01/23.
//  Copyright © 2023 Kartheek.Pagidimarri. All rights reserved.
//

import UIKit

class CustomDropDownCell: UITableViewCell {

    @IBOutlet var imagVWidthConstaint: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLbl.font = UIFont(name: "29LTBukra-Regular", size: 14.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
