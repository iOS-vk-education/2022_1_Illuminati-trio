//
//  CustomButton.swift
//  EGEKit
//
//  Created by user on 12.05.2022.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyShadow(cornerRadius: frame.height / 2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.applyShadow(cornerRadius: frame.height / 2)
    }
    
//    private func setRadiusAndShadow() {
//        layer.cornerRadius = 30
//        layer.masksToBounds = false
//        layer.shadowRadius = 10
//        layer.shadowOpacity = 0.3
//        layer.shadowColor = UIColor.gray.cgColor
//        layer.shadowOffset = CGSize(width: 3, height: 3)
//
//    }
}
