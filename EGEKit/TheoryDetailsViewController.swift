//
//  TheoryDetailsViewController.swift
//  EGEKit
//
//  Created by user on 16.04.2022.
//

import Foundation
import WebKit

final class TheoryDetailsViewController: ViewController {
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
        
        let backbutton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backbutton.setImage(image, for: .normal)
        backbutton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        
        
        view.addSubview(webView)
        webView.frame = view.bounds
        webView.navigationDelegate = self
        
        guard let url = URL(string: urlString) else {return}
        
        webView.load(URLRequest(url: url))
    }
 
    @objc
    func goBack()
    {
        self.navigationController?.dismiss(animated: true)
    }
    
    
    
}

extension TheoryDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // yo
    }
}
