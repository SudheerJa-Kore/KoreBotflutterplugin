//
//  AdvancedMultiCellTableViewCell.swift
//  KoreBotSDKFrameWork
//
//  Created by Kartheek.Pagidimarri on 03/08/22.
//  Copyright © 2022 Kartheek.Pagidimarri. All rights reserved.
//

import UIKit

class AdvancedMultiCellTableViewCell: UITableViewCell {
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cardnoLbl: UILabel!
    
    @IBOutlet var titleLblTopConstarint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgV.layer.cornerRadius = 5.0
//        bgV.clipsToBounds = true
//        bgV.layer.masksToBounds = false
//        bgV?.layer.shadowColor = UIColor.lightGray.cgColor
//        bgV?.layer.shadowOffset =  CGSize.zero
//        bgV?.layer.shadowOpacity = 0.5
//        bgV?.layer.shadowRadius = 10
        titleLbl.font =  UIFont(name: "29LTBukra-Semibold", size: 14.0)
        cardnoLbl.font = UIFont(name: "29LTBukra-Regular", size: 12.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
