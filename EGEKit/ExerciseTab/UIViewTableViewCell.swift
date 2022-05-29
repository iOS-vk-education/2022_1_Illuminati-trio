//
//  UIViewTableViewCell.swift
//  EGEKit
//
//  Created by user on 19.04.2022.
//

import UIKit

class UIViewTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var starIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 8
        self.containerView.layer.masksToBounds = true
        applyShadow(cornerRadius: 8)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension UIView {
func applyShadow(cornerRadius: CGFloat) {
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = false
    
    layer.shadowRadius = 8.0
    layer.shadowOpacity = 0.30
    layer.shadowColor = UIColor.gray.cgColor
    
    layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
