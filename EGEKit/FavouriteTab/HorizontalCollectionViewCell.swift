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
    
    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.systemCyan.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor
        ]
        gradient.locations = [0, 0.3, 0.8]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        gradient.frame = midView.bounds
        gradient.cornerRadius = midView.frame.size.height / 4
        midView.layer.insertSublayer(gradient, at: 0)

        
//        midView.applyShadow(cornerRadius: midView.frame.size.height / 4)
        
    }

}
