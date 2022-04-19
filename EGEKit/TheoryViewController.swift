//
//  TheoryViewController.swift
//  EGEKit
//
//  Created by user on 13.04.2022.
//

import Foundation
import UIKit
import PinLayout

class TheoryViewController: UIViewController {
    
    private let titleOfScreen = UILabel()
    private let titleInfo = UILabel()
    private var tableView = UITableView()
    let urlTheory = "https://math-ege.sdamgia.ru/page/theory"
    var theoryAll:[Theory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theoryAll = NetworkManager.shared.loadTheory(with: urlTheory)
        
        titleOfScreen.text = "Полезный материал"
        titleOfScreen.font = .boldSystemFont(ofSize: 20)
        
        titleInfo.text = "Теоретический материал, разделенный по типам задач, который необходим для их решения"
        titleInfo.textColor = .systemGray
        titleInfo.numberOfLines = 2
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        view.addSubview(titleOfScreen)
        view.addSubview(titleInfo)
        
        tableView.tableFooterView = UIView()
        
        view.backgroundColor = .systemBackground
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
    
    func open(with urlString: String, title: String) {
        
        let viewC = TheoryDetailsViewController(urlString: urlString,title0: title)
        let navC = UINavigationController(rootViewController: viewC)
        present(navC, animated: true, completion: nil)
        
    }
}

extension TheoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.open(with: theoryAll[indexPath.row].urlString, title: theoryAll[indexPath.row].name)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        theoryAll.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
            
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var defaultConf = cell.defaultContentConfiguration()
        defaultConf.text = theoryAll[indexPath.row].name
        cell.contentConfiguration = defaultConf
        
        return cell
    }

}
