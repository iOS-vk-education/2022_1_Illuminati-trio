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
//        tableView.backgroundColor = .systemGray6
        
        [tableView,activityIndicator].forEach{self.view.addSubview($0)}

        tableView.separatorStyle = .none
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        
        getInformation()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))

        tableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil), forCellReuseIdentifier: "UIViewTableViewCell")
        
    }
    
    @objc
    private func goBack()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ExerciseNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIViewTableViewCell", for: indexPath)
                as? UIViewTableViewCell else { return .init() }
        if FavouriteManager.shared.isFavourite(with: ExerciseNumbers[indexPath.row]) {
            cell.starIcon.isHidden = false
        }
        cell.textLabel?.text = "Задача № " + ExerciseNumbers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Section \(indexPath.section) Row: \(indexPath.row )")
        let viewC = DetailsViewController(number: "\(ExerciseNumbers[indexPath.row])")
        navigationController?.pushViewController(viewC, animated: true)
    }
}
