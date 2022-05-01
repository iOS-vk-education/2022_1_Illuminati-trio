//
//  DetailsViewController.swift
//  EGEKit
//
//  Created by user on 20.04.2022.
//

import Foundation
import UIKit
import WebKit
import PinLayout

final class DetailsViewController: ViewController {
    
    let number: String
    var htmlUslovie: String = ""
    var htmlSolution: String = ""
    let solutionButton = UIButton()
    
    private let webViewUslovie: WKWebView = {
        return WKWebView(frame: .zero)
    }()
    
    private let webViewSolution: WKWebView = {
        return WKWebView(frame: .zero)
    }()

    
    init(number: String) {
        self.number = number
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Задача № \(number)"
        solutionButton.setTitle("Показать решение", for: .normal)
        solutionButton.setTitleColor(.black, for: .normal)
        
        let backbutton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backbutton.setImage(image, for: .normal)
        backbutton.setTitle("Назад", for: .normal)
        backbutton.setTitleColor(.systemBlue, for: .normal)
        backbutton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        solutionButton.addTarget(self, action: #selector(hideUnhide), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        webViewSolution.isHidden = true
        
        view.addSubview(webViewUslovie)
        view.addSubview(webViewSolution)
        view.addSubview(solutionButton)
        view.backgroundColor = .systemBackground
        
//        webView.contentMode = .scaleAspectFit
//        webView.pageZoom = 3
        
        loadInfo()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        solutionButton.pin
            .center()
            .sizeToFit()
        
        webViewUslovie.pin
            .top()
            .left()
            .right()
            .above(of: solutionButton)
        
        webViewSolution.pin
            .below(of: solutionButton)
            .left()
            .right()
            .bottom()
    }
    
    func loadInfo() {
        Task {
            let result = await NetworkManager.shared.loadUslovieAndSolution(at: number)
            let align = "<meta name=\"viewport\" content=\"width=device-width\">"
            htmlUslovie = align + result.0
            htmlSolution = align + result.1
            
            webViewUslovie.loadHTMLString(htmlUslovie, baseURL: .none)
            webViewSolution.loadHTMLString(htmlSolution, baseURL: .none)
        }
    }
    
    @objc
    func hideUnhide() {
        webViewSolution.isHidden = !webViewSolution.isHidden
        if webViewSolution.isHidden {
            solutionButton.setTitle("Показать решение", for: .normal)
        } else {
        solutionButton.setTitle("Скрыть решение", for: .normal)
        }
    }
    
    @objc
    func goBack()
    {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
