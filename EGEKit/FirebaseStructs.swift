//
//  FirebaseStructs.swift
//  EGEKit
//
//  Created by user on 25.04.2022.
//

public struct Types: Codable {
    var exerciseTypes: [ExerciseType]
    
    init(name: [String], subNames: [[String]]) {
        exerciseTypes = [ExerciseType]()
        for i in 0..<name.count {
        let firstType = ExerciseType(typeName: name[i], subTypeNames: subNames[i])
            exerciseTypes.append(firstType)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case exerciseTypes
    }
}

public struct ExerciseType: Codable {
    let typeName: String
    let subTypeNames: [String]
    
    enum CodingKeys: String, CodingKey {
        case typeName
        case subTypeNames
    }
}
