//
//  SettingsModel.swift
//  EGEKit
//
//  Created by user on 26.05.2022.
//

import Foundation
import UIKit

struct SectionTitle {
    let title: String
    let options: [SectionOption]
}

struct SectionOption {
    let name: String
    let handler: (() -> Void)
}

class SettingsModel {
    var Sections: [SectionTitle] = []
    
    init() {
        
        Sections.append(SectionTitle(title: "Внешний вид", options: [
            SectionOption(name: "Текущая тема:", handler: {})
        ]))
                      
        Sections.append(SectionTitle(title: "Пользователь", options: [
            SectionOption(name: "Ваш email:", handler: {}),
            SectionOption(name: "Очистить историю задач", handler: {}),
            SectionOption(name: "Очистить избранное", handler: {}),
            SectionOption(name: "Выйти", handler: {})
        ]))
        
        Sections.append(SectionTitle(title: "Дополнительно", options: [
            SectionOption(name: "О приложении", handler: {})
        ]))
        
    }
}

class SettingsTableViewCell: UITableViewCell {
    static let id = "CustomTableViewCell"
    let rightText = UILabel()
    let midText = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemGroupedBackground
        rightText.isHidden = true
        midText.isHidden = true
        midText.textColor = .systemRed
//        midText.font = .boldSystemFont(ofSize: 14)
        addSubview(rightText)
        addSubview(midText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rightText.pin
            .centerRight()
            .sizeToFit()
            .marginRight(20)
        
        midText.pin
            .center()
            .sizeToFit()
    }
    
    
}


