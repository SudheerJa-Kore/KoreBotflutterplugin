//
//  NewListTrannsActionCell.swift
//  KoreBotSDKFrameWork
//
//  Created by Kartheek.Pagidimarri on 31/08/21.
//  Copyright © 2021 Kartheek.Pagidimarri. All rights reserved.
//

import UIKit

class NewListTrannsActionCell: UITableViewCell {
    @IBOutlet var bgView: UIView!
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLabl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var underlineLbl: UILabel!
    @IBOutlet weak var dateTopConstaint: NSLayoutConstraint!
    @IBOutlet weak var dateHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var priceLblWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateLbl.font =  UIFont(name: "29LTBukra-Semibold", size: 16.0)
        titleLabl.font = UIFont(name: "29LTBukra-Regular", size: 14.0)
        priceLbl.font = UIFont(name: "29LTBukra-Semibold", size: 14.0)
        underlineLbl.backgroundColor = UIColor.init(hexString:"#DDE0E9")
        
//        dateLbl.textColor = UIColor.init(hexString:"#313131")
//        titleLabl.textColor = UIColor.init(hexString:"#4A5052")
//        priceLbl.textColor = UIColor.init(hexString:"#313131")
        
                dateLbl.textColor = BubbleViewBotChatTextColor
                titleLabl.textColor = BubbleViewBotChatTextColor
                priceLbl.textColor = BubbleViewBotChatTextColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
