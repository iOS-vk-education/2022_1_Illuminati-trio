//
//  HorizontalCollectionViewCell.swift
//  EGEKit
//
//  Created by user on 05.05.2022.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        midView.applyShadow(cornerRadius: 12)
        
        typeLabel.transform = CGAffineTransform(rotationAngle: Double.pi/4)
        typeLabel.adjustsFontSizeToFitWidth = true

    }

}