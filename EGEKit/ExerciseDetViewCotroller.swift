//
//  ExericiseDetViewCotroller.swift
//  EGEKit
//
//  Created by user on 19.04.2022.
//

import Foundation
import UIKit
import WebKit


class ExpandableCell {
    var title: String
    let options: String
    var isOpened: Bool = false
    
    init(title: String,options: String,isOpened: Bool = false) {
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}


class ExerciseDetViewController: UIViewController {
    
    private let title0: String
    private let urlString: String
    private var tableView = UITableView()
    private var ExerciseNumbers: [String] = [String]()
    var ExerciseHtml: [String] = [String]()
    private var ExpCells = [ExpandableCell]()
    
    private let webView: WKWebView = {
        return WKWebView(frame: .zero)
    }()
    
    
    init(urlString: String, title0: String) {
        self.urlString = urlString
        self.title0 = title0
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = title0
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        let backbutton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backbutton.setImage(image, for: .normal)
        backbutton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)

        tableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil), forCellReuseIdentifier: "UIViewTableViewCell")
        
        ExerciseNumbers = NetworkManager.shared.getExerciseNumbers(with: urlString)
    
        self.ExerciseHtml = NetworkManager.shared.getExercise(with: self.urlString)
        
        let counter: Int = ExerciseHtml.count < ExerciseNumbers.count ? ExerciseHtml.count : ExerciseNumbers.count

        for i in 0..<counter {
            print("NumbersCount = \(ExerciseNumbers.count), HtmlCount = \(ExerciseHtml.count)")
            ExpCells.append(ExpandableCell(title: "Задача № \(ExerciseNumbers[i])", options: ExerciseHtml[i] ) )
        }
        
        print("Expcells = \(ExpCells.count)")
        
    }
    
    @objc
    func goBack()
    {
        self.navigationController?.dismiss(animated: true)
    }
    
}

extension ExerciseDetViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 44
        }
        else {
            return 80
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        ExerciseHtml.count < ExerciseNumbers.count ? ExerciseHtml.count : ExerciseNumbers.count
    }
            
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section2 = ExpCells[section]
        
        if section2.isOpened {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIViewTableViewCell", for: indexPath) as? UIViewTableViewCell else {return .init()}
        if indexPath.row == 0 {
            cell.mainLabel.text = ExpCells[indexPath.section].title
            return cell
        }
        else {
            cell.mainLabel.text = ""
            cell.mainView.addSubview(webView)

            webView.frame = cell.mainView.bounds
            webView.pageZoom = 3
            webView.loadHTMLString(ExpCells[indexPath.section].options, baseURL: .none)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Section \(indexPath.section) Row: \(indexPath.row )")
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            ExpCells[indexPath.section].isOpened = !ExpCells[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            
            let viewC = DetailsViewController(htmlString: ExpCells[indexPath.section].options,
                                              name: "Задача № \(ExerciseNumbers[indexPath.section])")
//            let navC = UINavigationController(rootViewController: viewC)
            
//            present(navC, animated: true, completion: nil)
            navigationController?.pushViewController(viewC, animated: true)
            
        }
    }
    
    
    
}
