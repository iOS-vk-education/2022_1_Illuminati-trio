//
//  FavouriteManager.swift
//  EGEKit
//
//  Created by user on 06.05.2022.
//

import Foundation
import FirebaseFirestore

protocol FavouriteManagerDescription {
    func getFavourites()
    func addLastSeen(with number: String)
    func markAsFavourite(with number: String)
    func deleteFromFavourite(with number: String)
    func isFavourite(with number: String) -> Bool
    func eraseFavourites()
}

final class FavouriteManager: FavouriteManagerDescription {
    
    static let favouritesKey: String = "IlumintatiTrio.EGEKit.Favourites"
    static let recentsKey: String = "IlumintatiTrio.EGEKit.Recents"
    
    static let favouritesNotificationKey = NSNotification.Name("IlumintatiTrio.EGEKit.Favourite.notifyFav")
    static let recentsNotificationKey = NSNotification.Name("IlumintatiTrio.EGEKit.Favourite.notifyRecents")
    
    static let shared = FavouriteManager()
    
    let db = NetworkManager.shared.db

    private init(){}
    
    func getFavourites() {
        Task {
            let favNumbers = await NetworkManager.shared.loadFavourites(with: NetworkManager.userEmail)
            
            UserDefaults.standard.set(favNumbers, forKey: FavouriteManager.favouritesKey)
            
            DispatchQueue.main.async {
            NotificationCenter.default.post(name: FavouriteManager.favouritesNotificationKey, object: nil)
            }

        }
    }
    
    func addLastSeen(with number: String) {
        var lastSeen: [String] = (UserDefaults.standard.array(forKey: Self.recentsKey) as? [String]) ?? []
        
        if lastSeen.count == 10 {
            lastSeen.remove(at: 9)
        }
        
        if lastSeen.contains(number) {
            if let indexToRemove = lastSeen.firstIndex(of: number) {
                lastSeen.remove(at: indexToRemove)
            }
            lastSeen.insert(number, at: 0)
        } else {
            lastSeen.insert(number, at: 0)
        }
        
        UserDefaults.standard.set(lastSeen, forKey: Self.recentsKey)
        
        NotificationCenter.default.post(name: Self.recentsNotificationKey, object: nil)
    }
    
    func isFavourite(with number: String) -> Bool {
        let favouriteNumber: [String] = (UserDefaults.standard.array(forKey: Self.favouritesKey) as? [String]) ?? []
        
        return favouriteNumber.contains(number)
    }
    
    func markAsFavourite(with number: String) {
        var favouriteNumber: [String] = (UserDefaults.standard.array(forKey: Self.favouritesKey) as? [String]) ?? []
        
        favouriteNumber.append(number)
        
        UserDefaults.standard.set(favouriteNumber, forKey: Self.favouritesKey)
                
        NotificationCenter.default.post(name: Self.favouritesNotificationKey, object: nil)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.db!.collection("users").document(NetworkManager.userEmail).setData(["fav":favouriteNumber])
        }
        
    }
    
    func deleteFromFavourite(with number: String) {
        var favouriteNumber: [String] = (UserDefaults.standard.array(forKey: Self.favouritesKey) as? [String]) ?? []
        
        if let indexToRemove = favouriteNumber.firstIndex(of: number) {
            favouriteNumber.remove(at: indexToRemove)
        }
                
        UserDefaults.standard.set(favouriteNumber, forKey: Self.favouritesKey)
                
        NotificationCenter.default.post(name: Self.favouritesNotificationKey, object: nil)
        
        db!.collection("users").document(NetworkManager.userEmail).setData(["fav":favouriteNumber])

    }
    
    func eraseFavourites() {
        var favouriteNumber: [String] = (UserDefaults.standard.array(forKey: Self.favouritesKey) as? [String]) ?? []
        
        favouriteNumber.removeAll()
        
        UserDefaults.standard.set(favouriteNumber, forKey: Self.favouritesKey)
                
        NotificationCenter.default.post(name: Self.favouritesNotificationKey, object: nil)
        
        db!.collection("users").document(NetworkManager.userEmail).setData(["fav":favouriteNumber])

    }
    
}
