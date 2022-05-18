//
//  FavouriteViewController.swift
//  EGEKit
//
//  Created by Ilia Kosov on xx.04.2022.
//

import Foundation
import UIKit
import PinLayout

class FavouriteViewController: UIViewController {
    
    private let titleOfScreen = UILabel()
    private let hCollectionTitle = UILabel()
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
        view.backgroundColor = .systemBackground
        
        print(NetworkManager.userEmail)
        titleOfScreen.text = "Избранное"
        titleOfScreen.font = .boldSystemFont(ofSize: 20)
        
        tableViewLabel.text = "Ваши любимые задачи"
        tableViewLabel.textColor = .black
        
        var config: UIButton.Configuration = .plain()
        config.title = "Очистить список"
        eraseFav.configuration = config
        
        eraseFav.addTarget(self, action: #selector(eraseFavourites), for: .touchUpInside)
        
        hCollectionTitle.text = "Недавно просмотренные"
        hCollectionTitle.font = .systemFont(ofSize: 16)
    
        hCollectionView.delegate = self
        hCollectionView.dataSource = self
        hCollectionView.register(HorizontalCollectionViewCell1.self, forCellWithReuseIdentifier: "HorizontalCollectionViewCell1")
        hCollectionView.register(.init(nibName: "HorizontalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HorizontalCollectionViewCell")

        exerciseTableView.separatorStyle = .none
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
        exerciseTableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil), forCellReuseIdentifier: "UIViewTableViewCell")

        [eraseFav,tableViewLabel,titleOfScreen,hCollectionView,hCollectionTitle,exerciseTableView].forEach{
            self.view.addSubview($0)}
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateTable),
                                               name: FavouriteManager.favouritesNotificationKey,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateCollection),
                                               name: FavouriteManager.recentsNotificationKey,
                                               object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        titleOfScreen.pin
            .top(view.pin.safeArea.top)
            .hCenter()
            .sizeToFit()
        
        hCollectionTitle.pin
            .below(of: titleOfScreen)
            .margin(8)
            .left()
            .sizeToFit()
        
        hCollectionView.pin
            .below(of: hCollectionTitle)
            .marginTop(5)
            .left()
            .right()
            .height(15%)
        
        exerciseTableView.pin
            .below(of: hCollectionView)
            .marginTop(50)
            .left()
            .right()
            .bottom(view.pin.safeArea.bottom)
        
        tableViewLabel.pin
            .above(of: exerciseTableView)
            .margin(8)
            .left().sizeToFit()
        
        eraseFav.pin
            .above(of: exerciseTableView)
            .right().sizeToFit()
    }
    
    @objc
    private func didUpdateTable() {
        exerciseTableView.reloadData()
    }
    
    @objc
    private func didUpdateCollection() {
        hCollectionView.reloadData()
    }
    
    @objc
    private func eraseFavourites() {
        FavouriteManager.shared.eraseFavourites()
    }
    
    private func openExercise(with number: String) {
        let viewC = DetailsViewController(number: "\(number)")
        let navC = UINavigationController(rootViewController: viewC)
        present(navC, animated: true)
    }
}

extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastSeen: [String] = (UserDefaults.standard.array(forKey: FavouriteManager.recentsKey) as? [String]) ?? []

        openExercise(with: lastSeen[indexPath.row])
        FavouriteManager.shared.addLastSeen(with: lastSeen[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let lastSeen: [String] = (UserDefaults.standard.array(forKey: FavouriteManager.recentsKey) as? [String]) ?? []

        return lastSeen.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let avaliableWidth = collectionView.frame.width - 3
        let cellSizeLength = avaliableWidth / 4
        
        return CGSize(width: cellSizeLength, height: cellSizeLength)
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
        
        let lastSeen: [String] = (UserDefaults.standard.array(forKey: FavouriteManager.recentsKey) as? [String]) ?? []
        
        cell.typeLabel.text = "Задача"
        cell.numberLabel.text = lastSeen[indexPath.row]
        
        return cell
    }

}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let favouriteNumber: [String] = (UserDefaults.standard.array(forKey: FavouriteManager.favouritesKey) as? [String]) ?? []
        
        return favouriteNumber.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIViewTableViewCell", for: indexPath) as? UIViewTableViewCell else { return .init() }
        let favouriteNumber: [String] = (UserDefaults.standard.array(forKey: FavouriteManager.favouritesKey) as? [String]) ?? []

        cell.textLabel?.text = "Задача № " + favouriteNumber[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let favouriteNumber: [String] = (UserDefaults.standard.array(forKey: FavouriteManager.favouritesKey) as? [String]) ?? []
        
        openExercise(with: favouriteNumber[indexPath.row])
        FavouriteManager.shared.addLastSeen(with: favouriteNumber[indexPath.row])

    }

}



class HorizontalCollectionViewCell1: UICollectionViewCell {

    private var cellLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
//        backgroundColor = .systemIndigo
        let grayView: UIView = .init(frame: frame)
        grayView.backgroundColor = .red
        cellLabel.text = "Test"
        cellLabel.textColor = .white
        self.addSubview(grayView)
        self.addSubview(cellLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cellLabel.pin
            .bottomCenter()
            .sizeToFit()

//        grayView.pin.center()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


        
