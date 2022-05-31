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
    func eraseRecents()
}

final class FavouriteManager: FavouriteManagerDescription {
    let model = FavouriteModel()
    
    static let favouritesKey: String = "IlumintatiTrio.EGEKit.Favourites"
    static let recentsKey: String = "IlumintatiTrio.EGEKit.Recents"
    
    static let favouritesNotificationKey = NSNotification.Name("IlumintatiTrio.EGEKit.Favourite.notifyFav")
    static let recentsNotificationKey = NSNotification.Name("IlumintatiTrio.EGEKit.Favourite.notifyRecents")
    
    static let shared: FavouriteManagerDescription = FavouriteManager()
    
    let db = NetworkManager.shared.db

    private init(){}
    
    func getFavourites() {
        Task {
            let favNumbers = await NetworkManager.shared.loadFavourites(with: NetworkManager.userEmail)
            
            DispatchQueue.main.async {
            self.model.favouriteNumber = favNumbers
            NotificationCenter.default.post(name: FavouriteManager.favouritesNotificationKey, object: nil)
            }

        }
    }
    
    func eraseRecents() {
        model.lastSeen.removeAll()
        
        NotificationCenter.default.post(name: Self.recentsNotificationKey, object: nil)

    }
    
    func addLastSeen(with number: String) {
                
        var lastSeen = model.lastSeen
        
        let fixedSize: Int = 15
        
        if lastSeen.count == fixedSize {
            lastSeen.remove(at: fixedSize - 1)
        }
        
        if lastSeen.contains(number) {
            if let indexToRemove = lastSeen.firstIndex(of: number) {
                lastSeen.remove(at: indexToRemove)
            }
            lastSeen.insert(number, at: 0)
        } else {
            lastSeen.insert(number, at: 0)
        }
        
        model.lastSeen = lastSeen
                
        NotificationCenter.default.post(name: Self.recentsNotificationKey, object: nil)
    }
    
    func isFavourite(with number: String) -> Bool {
        return model.favouriteNumber.contains(number)
    }
    
    func markAsFavourite(with number: String) {
        
        model.favouriteNumber.insert(number, at: 0)
                        
        NotificationCenter.default.post(name: Self.favouritesNotificationKey, object: nil)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.db!.collection("users").document(NetworkManager.userEmail).updateData(["fav": self?.model.favouriteNumber])
        }
        
    }
    
    func deleteFromFavourite(with number: String) {
        if let indexToRemove = model.favouriteNumber.firstIndex(of: number) {
            model.favouriteNumber.remove(at: indexToRemove)
        }
                
        NotificationCenter.default.post(name: Self.favouritesNotificationKey, object: nil)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.db!.collection("users").document(NetworkManager.userEmail).updateData(["fav": self?.model.favouriteNumber])
        }
    }
    
    func eraseFavourites() {
        model.favouriteNumber.removeAll()
        
        NotificationCenter.default.post(name: Self.favouritesNotificationKey, object: nil)
        
        db!.collection("users").document(NetworkManager.userEmail).setData(["fav": model.favouriteNumber])

    }
    
}
