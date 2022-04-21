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

class DetailsViewController: ViewController {
    
    let name: String
    let htmlString: String
    let solutionButton = UIButton()
    let bottomLabel = UILabel()
    
    private let webView: WKWebView = {
        return WKWebView(frame: .zero)
    }()
    
    init(htmlString: String,name: String) {
        self.htmlString = htmlString
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = name
        solutionButton.setTitle("Показать решение", for: .normal)
        solutionButton.setTitleColor(.black, for: .normal)
        
        bottomLabel.text = "Здесь будет решение"
        
        let backbutton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backbutton.setImage(image, for: .normal)
        backbutton.setTitle("Назад", for: .normal)
        backbutton.setTitleColor(.systemBlue, for: .normal)
        backbutton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
        
        view.addSubview(webView)
        view.addSubview(solutionButton)
        view.addSubview(bottomLabel)
        view.backgroundColor = .systemBackground
        
//        webView.contentMode = .scaleAspectFit
        webView.pageZoom = 3
        webView.loadHTMLString(self.htmlString, baseURL: .none)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        solutionButton.pin.center().sizeToFit()
        webView.pin.top().left().right().above(of: solutionButton)
        bottomLabel.pin.bottomCenter(250).sizeToFit()
    }
    
    @objc
    func goBack()
    {
//        self.navigationController?.dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
}
