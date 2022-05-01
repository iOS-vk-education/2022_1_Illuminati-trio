//
//  ExericiseDetViewCotroller.swift
//  EGEKit
//
//  Created by user on 19.04.2022.
//

import Foundation
import UIKit
import WebKit

final class ExerciseDetViewController: UIViewController {
    
    private let title0: String
    private var tableView = UITableView()
    private var ExerciseNumbers: [String] = [String]()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let webView: WKWebView = {
        return WKWebView(frame: .zero)
    }()
    
    
    init(title0: String) {
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
        view.addSubview(activityIndicator)
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        
        getInformation()
        
        let backbutton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backbutton.setImage(image, for: .normal)
        backbutton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)

        tableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil), forCellReuseIdentifier: "UIViewTableViewCell")
        
    }

    
    @objc
    func goBack()
    {
        self.navigationController?.dismiss(animated: true)
    }
    
    func getInformation() {
        Task {
            let numbers = await NetworkManager.shared.loadExercises(with: title0, type: "Numbers")
            ExerciseNumbers = numbers
            tableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
    
}

extension ExerciseDetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ExerciseNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIViewTableViewCell", for: indexPath)
                as? UIViewTableViewCell else { return .init() }
        cell.mainLabel.text = "Задача № " + ExerciseNumbers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Section \(indexPath.section) Row: \(indexPath.row )")
        let viewC = DetailsViewController(number: "\(ExerciseNumbers[indexPath.row])")
        navigationController?.pushViewController(viewC, animated: true)
    }
}
