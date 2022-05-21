//
//  ExerciseDetModel.swift
//  EGEKit
//
//  Created by user on 20.05.2022.
//

import Foundation

final class ExerciseDetModel {

    func loadExNumbers(with title: String, completion: @escaping ([String]) -> Void) {
        Task {
            let numbers = await NetworkManager.shared.loadExercises(with: title, type: "Numbers")
            
            DispatchQueue.main.async {
                completion(numbers)
            }
        }
    }
    
    func isFavourite(with number: String) -> Bool {
        FavouriteManager.shared.isFavourite(with: number)
    }
}
