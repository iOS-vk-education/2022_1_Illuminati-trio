//
//  ExerciseViewController.swift
//  EGEKit
//
//  Created by Ilia Kosov on xx.04.2022.
//

import Foundation
import UIKit
import PinLayout
import HTMLKit

class Section {
    var title: String
    let options: [String]
    var isOpened: Bool = false
    
    init(title: String,options: [String],isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}

class ExerciseViewController: UIViewController {
    
    private let titleOfScreen = UILabel()
    private let titleInfo = UILabel()
    private var tableView = UITableView()

    private var sections = [Section]()
    private var subExUrls = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sectionNames = NetworkManager.shared.getSectionsName()
        
        let subExNames = NetworkManager.shared.getSubExNames()
        subExUrls = NetworkManager.shared.getSubExUrls()
        
        for i in 0..<sectionNames.count {
            sections.append(Section(title: sectionNames[i], options: subExNames[i] ) )
        }
        
        
        view.backgroundColor = .systemBackground
        
        titleOfScreen.text = "Каталог заданий"
        titleOfScreen.font = .boldSystemFont(ofSize: 20)
        
        titleInfo.text = "Здесь представлен список задач, разделенный по типам"
        titleInfo.textColor = .systemGray
        titleInfo.numberOfLines = 2
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "LoreTableViewCell", bundle: nil), forCellReuseIdentifier: "LoreTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        view.addSubview(titleOfScreen)
        view.addSubview(titleInfo)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        titleOfScreen.pin
            .topCenter(60)
            .sizeToFit()
        
        titleInfo.pin.below(of: titleOfScreen)
            .left().right().marginHorizontal(10).height(60)
        
        tableView.pin.below(of: titleInfo).left().right().bottom()
    }
    
}

extension ExerciseViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            cell.textLabel?.font = font
            cell.textLabel?.text = sections[indexPath.section].title
            return cell
        }
        else {
            let font = UIFont.systemFont(ofSize: 15, weight: .light)
            cell.textLabel?.font = font
            cell.textLabel?.text = sections[indexPath.section].options[indexPath.row - 1]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Section \(indexPath.section) Row: \(indexPath.row )")
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            let viewC = ExerciseDetViewController(urlString: subExUrls[indexPath.section][indexPath.row - 1],
                                                  title0: sections[indexPath.section].options[indexPath.row - 1])
            let navC = UINavigationController(rootViewController: viewC)
            present(navC, animated: true, completion: nil)
        }
    }
    
    
}
