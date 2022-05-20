//
//  ExerciseModel.swift
//  EGEKit
//
//  Created by user on 20.05.2022.
//

import Foundation

final class ExerciseModel {
    private let networkManager = NetworkManager.shared
    
    var sections = [Section]()
    private var sectionNames = [String]()
    private var subExNames = [[String]]()
    
    func loadEverythingEx(completion: @escaping ([Section]) -> Void) {
        Task {
            let result = await NetworkManager.shared.loadNamesSubNames()
                
            sectionNames = result.map{$0.typeName}
            subExNames = result.map{$0.subTypeNames}
            subExNames[23] = subExNames[23].map{
                $0.replacingOccurrences(of: "\\.\\s", with: " ", options: .regularExpression)
            }
                
            for i in 0..<sectionNames.count {
                sections.append(Section(title: sectionNames[i], options: subExNames[i] ) )
            }
            
            DispatchQueue.main.async {
                completion(self.sections)
            }
        }
    }
}
