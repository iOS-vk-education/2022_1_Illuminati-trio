//
//  DetailsModel.swift
//  EGEKit
//
//  Created by user on 21.05.2022.
//

import Foundation

final class DetailsModel {
    private let networkManager = NetworkManager.shared
    private let favouriteManager = FavouriteManager.shared
    private var htmlUslovie: String = ""
    private var htmlSolution: String = ""
    
    func loadInfo(with number: String, completion:@escaping (String,String) -> Void) {
        Task{
        let result = await networkManager.loadUslovieAndSolution(at: number)
        let align = "<meta name=\"viewport\" content=\"width=device-width\">"
        htmlUslovie = align + result.0
        htmlSolution = align + result.1
        DispatchQueue.main.async {
            completion(self.htmlUslovie,self.htmlSolution)
            }
        }
    }
    
    func markAsFavourite(with number: String) {
        favouriteManager.markAsFavourite(with: number)
    }
    
    func deleteFromFavourite(with number: String) {
        favouriteManager.deleteFromFavourite(with: number)
    }
    
    func isFavoutire(with number: String) -> Bool {
        favouriteManager.isFavourite(with: number)
    }
    
}

