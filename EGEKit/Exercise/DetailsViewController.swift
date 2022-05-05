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
    
    private let number: String
    private var htmlUslovie: String = ""
    private var htmlSolution: String = ""
    private let solutionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
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
        view.backgroundColor = .systemBackground
        
        activityIndicator.startAnimating()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
                
        solutionButton.configuration = setupSolButton()
        
        webViewSolution.isHidden = true
        
        webViewUslovie.navigationDelegate = self
        webViewUslovie.addSubview(activityIndicator)
        
        [webViewUslovie,webViewSolution,solutionButton].forEach{
            self.view.addSubview($0)}
        
//        webView.contentMode = .scaleAspectFit
//        webView.pageZoom = 3
        
        loadInfo()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        solutionButton.pin
            .top(40%)
            .left(5)
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
        
        activityIndicator.pin.center()
    }
    
    func setupSolButton() -> UIButton.Configuration {
        solutionButton.isHidden = true
        solutionButton.addTarget(self, action: #selector(hideUnhide),
                                 for: .touchUpInside)
        var config: UIButton.Configuration = .filled()
        config.title = "Показать решение"
        config.baseBackgroundColor = .systemIndigo
        return config
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
    private func hideUnhide() {
        webViewSolution.isHidden = !webViewSolution.isHidden
        if webViewSolution.isHidden {
            solutionButton.setTitle("Показать решение", for: .normal)
        } else {
        solutionButton.setTitle("Скрыть решение", for: .normal)
        }
    }

}

extension DetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        solutionButton.isHidden = false
    }
}
