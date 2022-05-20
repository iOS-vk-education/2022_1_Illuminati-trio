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

final class DetailsViewController: UIViewController {
    
    private let number: String
    private var htmlUslovie: String = ""
    private var htmlSolution: String = ""
    private let solutionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private lazy var isFav = FavouriteManager.shared.isFavourite(with: number)
    
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

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
        
        print(isFav)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createFavButton())
                
        solutionButton.configuration = setupSolButton()
        solutionButton.applyShadow(cornerRadius: 5)
        
        webViewSolution.isOpaque = false
        webViewSolution.backgroundColor = .clear
        webViewSolution.navigationDelegate = self
        webViewSolution.isHidden = true
        
        webViewUslovie.isHidden = true
        webViewUslovie.isOpaque = false
        webViewUslovie.backgroundColor = .clear
        webViewUslovie.navigationDelegate = self
        
        view.addSubview(activityIndicator)
        
        print(webViewUslovie.frame.height)

        
        [webViewUslovie,webViewSolution,solutionButton].forEach{
            self.view.addSubview($0)}
        
//        webView.contentMode = .scaleAspectFit
//        webView.pageZoom = 3
        
        loadInfo()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        solutionButton.pin.center().sizeToFit()
//
//        solutionButton.isHidden = false
        
        webViewUslovie.pin
            .top()
            .left()
            .right()
//            .above(of: solutionButton)
        
//        webViewUslovie.isHidden = false

        
        webViewSolution.pin
            .below(of: solutionButton)
            .left()
            .right()
            .bottom()
        
        activityIndicator.pin.center()
        
        setupShowSolutionLayout()
        
    }
    
    @objc
    private func pressFavourite() {
        if !isFav {
        FavouriteManager.shared.markAsFavourite(with: self.number)
        } else {
            FavouriteManager.shared.deleteFromFavourite(with: self.number)
        }
        isFav = !isFav
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createFavButton())
    }
    
    @objc
    private func goBack()
    {
        let check = self.navigationController?.viewControllers.count ?? 0
        if check == 2 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    func setupShowSolutionLayout() {
        webViewUslovie.evaluateJavaScript("document.documentElement.scrollHeight") { (height, error) in
            let height2 = height as? CGFloat ?? 200
            
            self.webViewUslovie.pin.height(self.view.pin.safeArea.top + height2)
            self.webViewUslovie.isHidden = false

            self.solutionButton.pin
                .below(of: self.webViewUslovie)
                .left(self.view.pin.safeArea.left + 5)
                .sizeToFit()
            
            self.solutionButton.isHidden = false
        }
    }
    
    func createFavButton() -> UIButton {
        var systemImageName: String = ""
        let favButton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 20.0)
        isFav == true ? (systemImageName = "star.fill") : (systemImageName = "star")
        let image = UIImage(systemName: systemImageName, withConfiguration: config)
        favButton.setImage(image, for: .normal)

        favButton.addTarget(self, action: #selector(pressFavourite), for: .touchUpInside)
        return favButton
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
        
        let cssSttring = ":root {color-scheme: light dark;}@media (prefers-color-scheme: dark) {img {filter: invert(100%)}}"
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssSttring)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(jsString, completionHandler: nil)
        
        setupShowSolutionLayout()
        
    }
}
