//
//  FavouriteViewController.swift
//  EGEKit
//
//  Created by Ilia Kosov on xx.04.2022.
//

import Foundation
import UIKit
import PinLayout
import WebKit

class FavouriteViewController: UIViewController {
    
    private let presenter = FavouritePresenter()
    private let titleOfScreen = UILabel()
    private let hCollectionTitle = UILabel()
    
    lazy var cellsToDisplay: CGFloat = {
        let cells: CGFloat
        if UIDevice.current.orientation.isPortrait == true {
            cells = 5
        } else {
            cells = 9
        }
        return cells
    }()

    private let hCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    }()
    private let exerciseTableView = UITableView()
    private let tableViewLabel = UILabel()
    private let eraseFav = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        byPassDdos()
        view.backgroundColor = .systemBackground
        
        titleOfScreen.text = "Избранное"
        titleOfScreen.font = .boldSystemFont(ofSize: 20)
        
        tableViewLabel.text = "Ваши любимые задачи"
        tableViewLabel.textColor = .label
        
        var config: UIButton.Configuration = .plain()
        config.title = "Очистить список"
        eraseFav.configuration = config
        
        eraseFav.addTarget(self, action: #selector(eraseFavourites), for: .touchUpInside)
        
        hCollectionTitle.text = "Недавно просмотренные"
        hCollectionTitle.font = .systemFont(ofSize: 16)
    
        hCollectionView.delegate = self
        hCollectionView.dataSource = self
        hCollectionView.register(.init(nibName: "HorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HorizontalCollectionViewCell")

        exerciseTableView.separatorStyle = .none
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        exerciseTableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil), forCellReuseIdentifier: "UIViewTableViewCell")

        [eraseFav,tableViewLabel,titleOfScreen,hCollectionView,hCollectionTitle,exerciseTableView].forEach{
            self.view.addSubview($0)}
        
        presenter.viewController = self
        presenter.didLoadView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FavouriteManager.shared.getFavourites()
    }
    
    override func viewDidLayoutSubviews() {
        
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "sweet4")
        let blur = UIBlurEffect(style: .systemChromeMaterial)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurView)
        
        exerciseTableView.backgroundView = backgroundImageView
        
        titleOfScreen.pin
            .top(view.pin.safeArea.top + 10)
            .hCenter()
            .sizeToFit()
        
        hCollectionTitle.pin
            .below(of: titleOfScreen)
            .marginTop(8)
            .left(view.pin.safeArea.left + 8)
            .sizeToFit()
        
        hCollectionView.pin
            .below(of: hCollectionTitle)
            .left(view.pin.safeArea.left)
            .right(view.pin.safeArea.right)
            .height(120)
        
        exerciseTableView.pin
            .below(of: hCollectionView)
            .marginTop(30)
            .left(view.pin.safeArea.left)
            .right(view.pin.safeArea.right)
            .bottom(view.pin.safeArea.bottom)
        
        tableViewLabel.pin
            .above(of: exerciseTableView)
            .marginBottom(8)
            .left(view.pin.safeArea.left + 8)
            .sizeToFit()
        
        eraseFav.pin
            .above(of: exerciseTableView)
            .right(view.pin.safeArea.right + 8)
            .sizeToFit()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isPortrait == true {
            cellsToDisplay = 5
        } else {
            cellsToDisplay = 9
        }
        hCollectionView.reloadData()
    }
    
    func byPassDdos() {
        let webViewDdos: WKWebView = {
            return WKWebView(frame: .zero)
        }()
        view.addSubview(webViewDdos)
        if let url = URL(string: "https://ege.sdamgia.ru/") {
            let request = URLRequest(url: url)
            webViewDdos.load(request)
        }
    }
    
    func reloadRecents() {
        hCollectionView.reloadData()
    }
    
    func reloadFavourites() {
        exerciseTableView.reloadData()
    }
    
    @objc
    private func eraseFavourites() {
        presenter.didPressErase()
    }
    
    func openExercise(with number: String) {
        let viewC = DetailsViewController(number: "\(number)")
        let navC = UINavigationController(rootViewController: viewC)
        present(navC, animated: true)
    }
}

extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.lastSeen.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectLastSeen(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let avaliableWidth = collectionView.frame.width - (cellsToDisplay - 1)
        let cellSizeLength = avaliableWidth / cellsToDisplay
        
        return CGSize(width: floor(cellSizeLength), height: floor(cellSizeLength))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HorizontalCollectionViewCell", for: indexPath) as? HorizontalCollectionViewCell else { return .init() }
        
        cell.numberLabel.text = presenter.lastSeen[indexPath.row]
        
        return cell
    }

}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.favouriteNumber.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIViewTableViewCell", for: indexPath) as? UIViewTableViewCell else { return .init() }

        cell.textLabel?.text = "Задача № " + presenter.favouriteNumber[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectFavRow(at: indexPath.row)
    }
}


        
