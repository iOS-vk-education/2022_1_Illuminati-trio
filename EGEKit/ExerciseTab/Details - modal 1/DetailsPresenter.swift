//
//  DetailsPresenter.swift
//  EGEKit
//
//  Created by user on 21.05.2022.
//

import Foundation

final class DetailsPresenter {
    private let model = DetailsModel()
    weak var viewController: DetailsViewController?
    var htmlUslovie: String = ""
    var htmlSolution: String = ""
    
    func isFavourite(with number: String) -> Bool {
        model.isFavoutire(with: number)
    }
    
    func favButtonPressed(with number: String) {
        if !isFavourite(with: number) {
            model.markAsFavourite(with: number)
        } else {
            model.deleteFromFavourite(with: number)
        }
        viewController?.isFav = !viewController!.isFav
        viewController?.reloadFavButton()
    }
    
    func backButtonPressed() {
        let check = viewController?.navigationController?.viewControllers.count ?? 0
        if check == 2 {
            viewController?.navigationController?.popToRootViewController(animated: true)
        } else {
            viewController?.navigationController?.dismiss(animated: true)
        }
    }
    
    func didLoadView(with number: String) {
        model.loadInfo(with: number) { [weak self] (Uslovie,Solution) in
            self?.htmlUslovie = Uslovie
            self?.htmlSolution = Solution
            self?.viewController?.loadWebViews()
        }
    }
    
    func webViewFinishedLoading() {
        viewController?.stopActivityIndicator()
        viewController?.webViewDarkModeSupport()
        viewController?.setDynamicHeight()
    }
}
