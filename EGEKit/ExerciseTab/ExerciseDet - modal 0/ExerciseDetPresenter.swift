//
//  ExerciseDetPresenter.swift
//  EGEKit
//
//  Created by user on 20.05.2022.
//

import Foundation

final class ExerciseDetPresenter {
    private let model = ExerciseDetModel()
    weak var viewController: ExerciseDetViewController?
    var numbers: [String] = []
    
    func didLoadView(with title: String) {
        model.loadExNumbers(with: title) { [weak self] numbers in
            self?.numbers = numbers
            self?.viewController?.reloadData()
            self?.viewController?.stopActivityIndicator()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UpdateTable),
                                               name: FavouriteManager.favouritesNotificationKey,
                                               object: nil)
    }
    
    @objc
    func UpdateTable() {
        self.viewController?.reloadData()
    }
    
    func isFavourite(at indexPath: IndexPath) -> Bool {
        model.isFavourite(with: numbers[indexPath.row])
    }
    
    func didSelectTable(at indexPath: IndexPath) {
        viewController?.deselectRow(at: indexPath)
        viewController?.loadExercise(with: numbers[indexPath.row])
    }
}
