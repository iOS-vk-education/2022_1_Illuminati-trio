//
//  TheoryViewController.swift
//  EGEKit
//
//  Created by user on 13.04.2022.
//

import Foundation
import UIKit
import PinLayout

final class TheoryViewController: UIViewController {
    private let model = TheoryModel()
    
    private let titleOfScreen = UILabel()
    private let titleInfo = UILabel()
    private var tableView = UITableView()
    private var fontSize: CGFloat = 16
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleOfScreen.text = "Полезный материал"
        titleOfScreen.font = .boldSystemFont(ofSize: 20)
        
        titleInfo.text = "Теоретический материал, разделенный по типам задач, который необходим для их решения"
        titleInfo.textColor = .systemGray
        titleInfo.numberOfLines = 2
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil), forCellReuseIdentifier: "UIViewTableViewCell")
        tableView.separatorStyle = .none
        
        [tableView,titleOfScreen,titleInfo,activityIndicator].forEach{self.view.addSubview($0)}
        
        activityIndicator.startAnimating()
        
        view.backgroundColor = .systemBackground
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        view.addGestureRecognizer(pinchRecognizer)
        
        model.getNamesUrls { [weak self] in
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "theory")
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
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
            .left()
            .right()
            .marginHorizontal(10)
            .height(60)
        
        tableView.pin
            .below(of: titleInfo)
            .left()
            .right()
            .bottom()
    }
    
    @objc
    private func handlePinch(gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.state == .began || gestureRecognizer.state == .changed else {
            return
        }
        self.fontSize = fontSize * gestureRecognizer.scale
        gestureRecognizer.scale = 1

        tableView.reloadData()
    }
    
    private func open(with urlString: String, title: String) {
        
        let viewC = TheoryDetailsViewController(urlString: urlString,title0: title)
        let navC = UINavigationController(rootViewController: viewC)
        present(navC, animated: true, completion: nil)
        
    }
}

extension TheoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.open(with: model.theoryUrls[indexPath.row], title: model.theoryNames[indexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.theoryNames.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
            
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIViewTableViewCell", for: indexPath)
        let font = UIFont.systemFont(ofSize: self.fontSize, weight: .regular)
        
        cell.textLabel?.text = model.theoryNames[indexPath.row]
        cell.textLabel?.font = font
        
        return cell
    }

}
