//
//  HorizontalCollectionViewCell.swift
//  EGEKit
//
//  Created by user on 05.05.2022.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var typeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        typeLabel.transform = CGAffineTransform(rotationAngle: Double.pi/4)

    }

}
