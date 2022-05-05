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
        
        setupTable()
        
        view.backgroundColor = .systemBackground
        
        titleOfScreen.text = "Каталог заданий"
        titleOfScreen.font = .boldSystemFont(ofSize: 20)
        
        titleInfo.text = "Здесь представлен список задач, разделенный по типам"
        titleInfo.textColor = .systemGray
        titleInfo.numberOfLines = 2
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil), forCellReuseIdentifier: "UIViewTableViewCell")
        tableView.separatorStyle = .none
        
        [tableView,titleOfScreen,titleInfo,activityIndicator].forEach{self.view.addSubview($0)}
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.pin
            .center()
        
        titleOfScreen.pin
            .topCenter(60)
            .sizeToFit()
        
        titleInfo.pin.below(of: titleOfScreen)
            .left().right().marginHorizontal(10).height(60)
        
        tableView.pin.below(of: titleInfo).left().right().bottom()
    }
    
    private func setupTable() {
        Task {
            let result = await NetworkManager.shared.loadNamesSubNames()
                
            sectionNames = result.map{$0.typeName}
            subExNames = result.map{$0.subTypeNames}
            subExNames[23] = subExNames[23].map{
                $0.replacingOccurrences(of: "\\.\\s", with: " ", options: .regularExpression)
            }
                
            for i in 0..<sectionNames.count {
                sections.append(Section(title: sectionNames[i], options: subExNames[i] ) )
            }
                
            tableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
    
}

extension ExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
            
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
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
        if indexPath.row == 0 {
            let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            cell.containerView.layer.borderColor = UIColor.systemGray4.cgColor
            cell.containerView.layer.borderWidth = 0.5
//            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.font = font
            cell.textLabel?.text = "\(indexPath.section + 1). " + sections[indexPath.section].title
            return cell
        }
        else {
            cell.containerView.layer.borderWidth = 0.0
            let font = UIFont.systemFont(ofSize: 15, weight: .light)
            cell.textLabel?.font = font
            cell.textLabel?.text = " - " + sections[indexPath.section].options[indexPath.row - 1]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Section \(indexPath.section) Row: \(indexPath.row )")
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .fade)
        } else {
            let viewC = ExerciseDetViewController(title0: sections[indexPath.section].options[indexPath.row - 1])
            let navC = UINavigationController(rootViewController: viewC)
            present(navC, animated: true, completion: nil)
        }
    }
    
    
}
