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
    private let presenter = DetailsPresenter()
    let banner = NotificationBannerView(frame: .zero)
    
    private let number: String
    private var htmlUslovie: String = ""
    private var htmlSolution: String = ""
    private let solutionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    lazy var isFav = presenter.isFavourite(with: number)
    
    private let webViewUslovie: WKWebView = {
        return WKWebView(frame: .zero)
    }()
    
    private let webViewSolution: WKWebView = {
        return WKWebView(frame: .zero)
    }()

    
    init(number: String) {
        self.number = number
        super.init(nibName: nil, bundle: nil)
        self.title = "Задача № \(number)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleView = UILabel()
        titleView.text = self.title
        titleView.font = .boldSystemFont(ofSize: 18)
        titleView.isUserInteractionEnabled = true
        self.navigationItem.titleView = titleView
        
        view.backgroundColor = .systemBackground
        
        supportDarkTheme()
                
        activityIndicator.startAnimating()
        
        setupWebViews()
        setupButtons()
        
        view.addSubview(activityIndicator)
        view.addSubview(banner)
        
        [webViewUslovie,webViewSolution,solutionButton].forEach{
            self.view.addSubview($0)}
        
        banner.isHidden = true
        
        let tapToCopy = UILongPressGestureRecognizer(target: self, action: #selector(copyUrl))
        titleView.addGestureRecognizer(tapToCopy)
        
        presenter.viewController = self
        presenter.didLoadView(with: number)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webViewUslovie.pin
            .top()
            .left()
            .right()

        webViewSolution.pin
            .below(of: solutionButton)
            .marginTop(15)
            .left()
            .right()
            .bottom()
        
        activityIndicator.pin
            .center()
        
        solutionButton.pin
            .left(view.pin.safeArea.left + 5)
        
        banner.pin
            .horizontally(10%)
            .height(48)
            .bottom(view.safeAreaInsets.bottom)
    }
    @objc
    private func copyUrl() {
        let tapticFeedback = UINotificationFeedbackGenerator()
        tapticFeedback.notificationOccurred(.success)
        UIPasteboard.general.string = "https://math-ege.sdamgia.ru/problem?id=\(number)"
        banner.isHidden = false
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3) {
            self.banner.isHidden = true
        }
    }
    
    @objc
    private func pressFavourite() {
        presenter.favButtonPressed(with: number)
    }
    
    @objc
    private func goBack()
    {
        presenter.backButtonPressed()
    }
    
    private func setupButtons() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
                
        reloadFavButton()
                
        solutionButton.configuration = setupSolButton()
        solutionButton.applyShadow(cornerRadius: 5)
    }
    
    private func setupWebViews() {
        webViewSolution.isOpaque = false
        webViewSolution.backgroundColor = .clear
        webViewSolution.navigationDelegate = self
        webViewSolution.isHidden = true
        
        webViewUslovie.isHidden = true
        webViewUslovie.isOpaque = false
        webViewUslovie.backgroundColor = .clear
        webViewUslovie.navigationDelegate = self
    }
    
    func reloadFavButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createFavButton())
    }
    
    func loadWebViews() {
        webViewUslovie.loadHTMLString(presenter.htmlUslovie, baseURL: .none)
        webViewSolution.loadHTMLString(presenter.htmlSolution, baseURL: .none)
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func webViewDarkModeSupport() {
        let cssSttring = ":root {color-scheme: light dark;}@media (prefers-color-scheme: dark) {img {filter: invert(100%)}}"
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssSttring)'; document.head.appendChild(style);"
        webViewUslovie.evaluateJavaScript(jsString, completionHandler: nil)
        webViewSolution.evaluateJavaScript(jsString, completionHandler: nil)
    }
    
    func setDynamicHeight() {
        webViewUslovie.evaluateJavaScript("document.documentElement.scrollHeight") { (height, error) in
            let height2 = height as? CGFloat ?? 200
            
            self.webViewUslovie.pin.height(self.view.pin.safeArea.top + height2)
            self.webViewUslovie.isHidden = false

            self.solutionButton.pin
                .marginTop(15)
                .below(of: self.webViewUslovie)
                .sizeToFit()
            
            self.solutionButton.isHidden = false
        }
    }
    
    private func createFavButton() -> UIButton {
        var systemImageName: String = ""
        let favButton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 20.0)
        isFav == true ? (systemImageName = "star.fill") : (systemImageName = "star")
        let image = UIImage(systemName: systemImageName, withConfiguration: config)
        favButton.setImage(image, for: .normal)

        favButton.addTarget(self, action: #selector(pressFavourite), for: .touchUpInside)
        return favButton
    }
    
    private func setupSolButton() -> UIButton.Configuration {
        solutionButton.isHidden = true
        solutionButton.addTarget(self, action: #selector(hideUnhide),
                                 for: .touchUpInside)
        var config: UIButton.Configuration = .filled()
        config.title = "Показать решение"
        config.baseBackgroundColor = .systemIndigo
        return config
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
        presenter.webViewFinishedLoading()
    }
}
