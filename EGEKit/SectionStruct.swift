//
//  SectionStruct.swift
//  EGEKit
//
//  Created by user on 25.04.2022.
//

import Foundation

struct Section {
    var title: String
    let options: [String]
    var isOpened: Bool = false
    
    init(title: String,options: [String],isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}

struct Theory {
    let name: String
    let urlString: String
}
