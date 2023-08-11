//
//  CardSelectionCellTableViewCell.swift
//  KoreBotSDKFrameWork
//
//  Created by Kartheek.Pagidimarri on 27/05/22.
//  Copyright © 2022 Kartheek.Pagidimarri. All rights reserved.
//

import UIKit

class CardSelectionCellTableViewCell: UITableViewCell {
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var bgV: UIView!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cardnoLbl: KREAttributedLabel!
    @IBOutlet weak var tiltlLblHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet var cardLblWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var cardTypeLbl: KREAttributedLabel!
    @IBOutlet var cardTypeLblWidthConstraint: NSLayoutConstraint!
    @IBOutlet var titleLblHeightConstarint: NSLayoutConstraint!
    
    
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
        titleLbl.font =  UIFont(name: "29LTBukra-Regular", size: 14.0) //Semibold
        cardTypeLbl.font =  UIFont(name: "29LTBukra-Regular", size: 14.0) //Semibold
        cardnoLbl.font = UIFont(name: "29LTBukra-Regular", size: 12.0)
        cardnoLbl.textColor = UIColor.init(hexString: "#7C7C7C")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
