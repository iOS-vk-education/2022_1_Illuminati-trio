//
//  FavouritePresenter.swift
//  EGEKit
//
//  Created by user on 19.05.2022.
//  go mvp

import Foundation

final class FavouritePresenter {
    private let favouriteManager = FavouriteManager.shared
    private let model = FavouriteModel()
    weak var viewController: FavouriteViewController?
    
    init(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UpdateTable),
                                               name: FavouriteManager.favouritesNotificationKey,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UpdateCollection),
                                               name: FavouriteManager.recentsNotificationKey,
                                               object: nil)
    }
    @objc
    func UpdateCollection() {
        self.viewController?.reloadRecents()
    }
    
    @objc
    func UpdateTable() {
        self.viewController?.reloadFavourites()
    }
    
    var lastSeen: [String] {
        return model.lastSeen
    }
    
    var favouriteNumber: [String] {
        return model.favouriteNumber
    }
    
    func didPressErase() {
        FavouriteManager.shared.eraseFavourites()
    }
    
    func didSelectFavRow(at index: Int) {
        self.viewController?.openExercise(with: favouriteNumber[index])
        favouriteManager.addLastSeen(with: favouriteNumber[index])
    }
    
    func didSelectLastSeen(at index: Int) {
        self.viewController?.openExercise(with: lastSeen[index])
        favouriteManager.addLastSeen(with: lastSeen[index])
    }
    
}
