//
//  ExerciseViewController.swift
//  EGEKit
//
//  Created by Ilia Kosov on xx.04.2022.
//

import Foundation
import UIKit
import PinLayout

final class ExerciseViewController: UIViewController {
    private let presenter = ExercisePresenter()
    
    private let titleOfScreen = UILabel()
    private let titleInfo = UILabel()
    private var tableView = UITableView()

    private var sections = [Section]()
    
    private var sectionNames = [String]()
    private var subExNames = [[String]]()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
                
        view.backgroundColor = .systemBackground
        
        setupTable()
        setupLabels()
        
        [tableView,titleOfScreen,titleInfo,activityIndicator].forEach{self.view.addSubview($0)}
        
        presenter.viewController = self
        presenter.didLoadView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "spline3")
        let blur = UIBlurEffect(style: .systemChromeMaterial)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurView)
        
        tableView.backgroundView = backgroundImageView
        
        activityIndicator.pin
            .center()
        
        titleOfScreen.pin
            .top(view.pin.safeArea.top + 10)
            .hCenter()
            .sizeToFit()
        
        titleInfo.pin.below(of: titleOfScreen)
            .left().right().marginHorizontal(10).height(60)
        
        tableView.pin.below(of: titleInfo).left().right().bottom()
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil), forCellReuseIdentifier: "UIViewTableViewCell")
        tableView.separatorStyle = .none
    }
    
    private func setupLabels() {
        titleOfScreen.text = "Каталог заданий"
        titleOfScreen.font = .boldSystemFont(ofSize: 20)
        
        titleInfo.text = "Здесь представлен список задач, разделенный по типам"
        titleInfo.textColor = .systemGray
        titleInfo.numberOfLines = 2
    }
    
    func loadExerciseDetails(with title: String) {
        let viewC = ExerciseDetViewController(title0: title)
        let navC = UINavigationController(rootViewController: viewC)
        present(navC, animated: true, completion: nil)
    }
    
    func deselectRow(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func reloadSections(at indexs: IndexSet) {
        tableView.reloadSections(indexs, with: .fade)
    }
    
}

extension ExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.sections.count
    }
            
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = presenter.sections[section]
        
        if section.isOpened {
            return section.options.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIViewTableViewCell", for: indexPath)
                as? UIViewTableViewCell else { return .init() }
        
        cell.textLabel?.text = presenter.giveCellText(at: indexPath)
        
        if indexPath.row == 0 {
            let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            cell.textLabel?.font = font
        }
        else {
            cell.containerView.layer.borderWidth = 0.0
            let font = UIFont.systemFont(ofSize: 15, weight: .light)
            cell.textLabel?.font = font
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectTable(at: indexPath)
    }
    
}
