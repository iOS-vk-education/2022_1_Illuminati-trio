//
//  TheoryDetailsViewController.swift
//  EGEKit
//
//  Created by user on 16.04.2022.
//

import Foundation
import WebKit

final class TheoryDetailsViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let urlString: String
    private let title0: String
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
        
        view.backgroundColor = .systemBackground
        
        supportDarkTheme()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack))
        
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.navigationDelegate = self
        
        guard let url = URL(string: urlString) else {return}
        
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
 
    @objc
    private func goBack()
    {
        self.navigationController?.dismiss(animated: true)
    }
    
}

extension TheoryDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
