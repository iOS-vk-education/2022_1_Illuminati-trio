//
//  FavouriteModel.swift
//  EGEKit
//
//  Created by user on 19.05.2022.
//

import Foundation

final class FavouriteModel {
    
    var lastSeen: [String]{
        get{
            (UserDefaults.standard.array(forKey: FavouriteManager.recentsKey) as? [String]) ?? []
        } set{
            UserDefaults.standard.set(newValue, forKey: FavouriteManager.recentsKey)
        }
    }
    
    var favouriteNumber: [String]{
        get{
            (UserDefaults.standard.array(forKey: FavouriteManager.favouritesKey) as? [String]) ?? []
        } set {
            UserDefaults.standard.set(newValue, forKey: FavouriteManager.favouritesKey)
        }
    }
    
    func addLastSeen(with favouriteNumber: String) {
        FavouriteManager.shared.addLastSeen(with: favouriteNumber)
    }
    
    func eraseFavourites() {
        FavouriteManager.shared.eraseFavourites()
    }
    
}
