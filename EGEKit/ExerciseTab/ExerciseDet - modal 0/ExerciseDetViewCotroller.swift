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
    private let presenter = ExerciseDetPresenter()
    
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
        
        [tableView,activityIndicator].forEach{self.view.addSubview($0)}

        tableView.separatorStyle = .none
        
        tableView.frame = view.bounds
        tableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "UIViewTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        
        presenter.viewController = self
        presenter.didLoadView(with: title0)
                
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
    }
    
    @objc
    private func didUpdateTable() {
        tableView.reloadData()
    }
    
    @objc
    private func goBack()
    {
        self.navigationController?.dismiss(animated: true)
    }
    
    func loadExercise(with number: String) {
        FavouriteManager.shared.addLastSeen(with: number)
        let viewC = DetailsViewController(number: "\(number)")
        navigationController?.pushViewController(viewC, animated: true)
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

}

extension ExerciseDetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIViewTableViewCell", for: indexPath)
                as? UIViewTableViewCell else { return .init() }
        
        cell.starIcon.isHidden = !presenter.isFavourite(at: indexPath)
        
        cell.textLabel?.text = "Задача № " + presenter.numbers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectTable(at: indexPath)
    }
}
