//
//  FavouriteManager.swift
//  EGEKit
//
//  Created by user on 06.05.2022.
//

import Foundation

protocol FavouriteManagerDescription {
    func markAsFavourite(with number: String)
}

final class FavouriteManager: FavouriteManagerDescription {
    
    static let key: String = "IlumintatiTrio.EGEKit.Favourite"
    
    static let notificationKey: NSNotification.Name = NSNotification.Name("IlumintatiTrio.EGEKit.Favourite.notify")
    
    static let shared = FavouriteManager()
    
    private init(){}
    
    func isFavourite(with number: String) -> Bool {
        let favouriteNumber: [String] = (UserDefaults.standard.array(forKey: Self.key) as? [String]) ?? []
        
        return favouriteNumber.contains(number)
    }
    
    func markAsFavourite(with number: String) {
        var favouriteNumber: [String] = (UserDefaults.standard.array(forKey: Self.key) as? [String]) ?? []
        
        favouriteNumber.append(number)
        
        UserDefaults.standard.set(favouriteNumber, forKey: Self.key)
        
        NotificationCenter.default.post(name: Self.notificationKey, object: nil)
    }
    
    func deleteFromFavourite(with number: String) {
        var favouriteNumber: [String] = (UserDefaults.standard.array(forKey: Self.key) as? [String]) ?? []
        
        if let indexToRemove = favouriteNumber.firstIndex(of: number) {
            favouriteNumber.remove(at: indexToRemove)
        }
        
        UserDefaults.standard.set(favouriteNumber, forKey: Self.key)
        
        NotificationCenter.default.post(name: Self.notificationKey, object: nil)
    }
    
    func eraseFavourites() {
        var favouriteNumber: [String] = (UserDefaults.standard.array(forKey: Self.key) as? [String]) ?? []
        
        favouriteNumber.removeAll()
        
        UserDefaults.standard.set(favouriteNumber, forKey: Self.key)
        
        NotificationCenter.default.post(name: Self.notificationKey, object: nil)
    }
    
}
