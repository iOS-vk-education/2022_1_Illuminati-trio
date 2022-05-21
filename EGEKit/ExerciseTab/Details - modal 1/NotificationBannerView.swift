//
//  NotificationBannerView.swift
//  EGEKit
//
//  Created by user on 21.05.2022.
//

import Foundation
import UIKit

final class NotificationBannerView: UIView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(label)
        label.font = .systemFont(ofSize: 16)
        label.text = "Ссылка скопирована в буфер обмена"
        label.textColor = .systemIndigo
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 24
        self.applyShadow(cornerRadius: 24)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.pin
            .center()
            .sizeToFit()
    }
}
