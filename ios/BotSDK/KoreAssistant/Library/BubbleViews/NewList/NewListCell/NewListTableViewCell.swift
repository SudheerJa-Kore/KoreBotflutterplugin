//
//  NewListTableViewCell.swift
//  KoreBotSDKDemo
//
//  Created by MatrixStream_01 on 13/05/20.
//  Copyright © 2020 Kore. All rights reserved.
//

import UIKit

class NewListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subTitleLabel2: KREAttributedLabel!
    @IBOutlet weak var tagBtn: UIButton!
    @IBOutlet weak var underlineLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var priceLbl: KREAttributedLabel!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var subTitleLblTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var valueLabelWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageVLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titlaLblTopConstriant: NSLayoutConstraint!
    
    @IBOutlet weak var subTitleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var subTitle2HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var priceLblTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var tagBtnWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 6
//        bgView.layer.borderWidth = 1
//        bgView.layer.borderColor = UIColor.lightGray.cgColor
        
//        bgView.layer.shadowColor = UIColor.darkGray.cgColor
//        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        bgView.layer.shadowOpacity = 0.5
//        bgView.layer.shadowRadius = 2
//        bgView.clipsToBounds = true
        
        underlineLbl.isHidden = true
        bgView.layer.masksToBounds = false
        
        //bgView?.clipsToBounds = true
        bgView?.layer.masksToBounds = false
        bgView?.layer.shadowColor = UIColor.lightGray.cgColor
        bgView?.layer.shadowOffset =  CGSize.zero
        bgView?.layer.shadowOpacity = 0.08
        bgView?.layer.shadowRadius = 2
        bgView?.clipsToBounds = false
        
        
        titleLabel.font =  UIFont(name: "29LTBukra-Semibold", size: 13.5)
        subTitleLabel.font = UIFont(name: "29LTBukra-Regular", size: 12.0)
        subTitleLabel2.font = UIFont(name: "29LTBukra-Regular", size: 12.3)
        priceLbl.font = UIFont(name: "29LTBukra-Semibold", size: 14.0)
        tagBtn.titleLabel?.font =  UIFont(name: "29LTBukra-Semibold", size: 9)
        
        
//        titleLabel.textColor = UIColor.init(hexString:"#313131")
//        subTitleLabel.textColor = UIColor.init(hexString:"#313131")
//        subTitleLabel2.textColor = UIColor.init(hexString:"#313131")
//        priceLbl.textColor = UIColor.init(hexString:"#313131")
//        priceLbl.alpha = 0.7
        
        titleLabel.textColor = BubbleViewBotChatTextColor
        subTitleLabel.textColor = BubbleViewBotChatTextColor
        subTitleLabel2.textColor = BubbleViewBotChatTextColor
        priceLbl.textColor = BubbleViewBotChatTextColor
        
//        let shadows = UIView()
//        let screenRect = UIScreen.main.bounds
//        shadows.frame = CGRect(x: 2, y: bgView.frame.origin.y, width: screenRect.size.width - 40 - 4, height: bgView.frame.size.height - 2)
//        shadows.clipsToBounds = false
//        bgView.addSubview(shadows)
//        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 6)
//        let layer0 = CALayer()
//        layer0.shadowPath = shadowPath0.cgPath
//        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
//        layer0.shadowOpacity = 0.08
//        layer0.shadowRadius = 12
//        layer0.shadowOffset = CGSize(width: 0, height: 8)
//        layer0.bounds = shadows.bounds
//        layer0.position = shadows.center
//        shadows.layer.addSublayer(layer0)
//        let shapes = UIView()
//        shapes.frame = CGRect(x:2, y: bgView.frame.origin.y, width: screenRect.size.width - 40 - 4, height: bgView.frame.size.height - 2)
//        shapes.clipsToBounds = true
//        bgView.addSubview(shapes)
//        let layer1 = CALayer()
//        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        layer1.bounds = shapes.bounds
//        layer1.position = shapes.center
//        shapes.layer.addSublayer(layer1)
//        shapes.layer.cornerRadius = 6
        
//        self.bgView.bringSubviewToFront(titleLabel)
//        self.bgView.bringSubviewToFront(subTitleLabel)
//        self.bgView.bringSubviewToFront(subTitleLabel2)
//        self.bgView.bringSubviewToFront(priceLbl)
//        self.bgView.bringSubviewToFront(tagBtn)
//        self.bgView.bringSubviewToFront(imgView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
