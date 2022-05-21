//
//  ExercisePresenter.swift
//  EGEKit
//
//  Created by user on 20.05.2022.
//

import Foundation

final class ExercisePresenter {
    private let model = ExerciseModel()
    weak var viewController: ExerciseViewController?
    
    var sections = [Section]()
    
    func didLoadView() {
        model.loadEverythingEx{ [weak self] sections in
            self?.sections = sections
            self?.viewController?.reloadData()
            self?.viewController?.stopActivityIndicator()
        }
    }
    
    func giveCellText(at indexPath: IndexPath) -> String {
        var cellText = ""
        if indexPath.row == 0 {
            cellText = "\(indexPath.section + 1). " + sections[indexPath.section].title
        }
        else {
            cellText = " - " + sections[indexPath.section].options[indexPath.row - 1]
        }
        return cellText
    }
    
    func didSelectTable(at indexPath: IndexPath) {
        viewController?.deselectRow(at: indexPath)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            viewController?.reloadSections(at: [indexPath.section])
        } else {
            viewController?.loadExerciseDetails(with: sections[indexPath.section].options[indexPath.row - 1])
        }
    }
}
