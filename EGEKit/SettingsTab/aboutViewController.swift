//
//  aboutViewController.swift
//  EGEKit
//
//  Created by user on 30.05.2022.
//

import Foundation
import UIKit
import PinLayout
import MessageUI

final class aboutViewControler: UIViewController {
    
    private let logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    private let logoLabel = UILabel()
    private let aboutLabel = UILabel()
    private let tableOut = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = tableOut.backgroundColor
        
        logoView.image = UIImage(named: "full")
        self.title = "О приложении"
        logoLabel.text = "EGEKit"
        
        tableOut.delegate = self
        tableOut.dataSource = self
        tableOut.isScrollEnabled = false
        tableOut.register(UIViewTableViewCell.self, forCellReuseIdentifier: "cell")
        
        aboutLabel.numberOfLines = 0
        aboutLabel.text = """
        EGEKit - надежный инструмент и карманный помощник для подготовки к Единому государственный экзамену по математике.
        """
        var supportedInterfaceOrientation: UIInterfaceOrientationMask {
            return .portrait
        }
        
        
        view.addSubview(logoView)
        view.addSubview(logoLabel)
        view.addSubview(aboutLabel)
        view.addSubview(tableOut)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoView.pin
            .hCenter()
            .top(10%)
        
        logoLabel.pin
            .below(of: logoView, aligned: .center)
            .sizeToFit()
        
        aboutLabel.pin
            .below(of: logoLabel)
            .left(view.pin.safeArea.left + 20)
            .right(view.pin.safeArea.right + 5)
            .height(70)
        
        tableOut.pin
            .below(of: aboutLabel)
            .left(view.pin.safeArea.left)
            .right(view.pin.safeArea.left)
            .bottom(view.pin.safeArea.bottom)
    }
}

extension aboutViewControler: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Обратная связь"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        
        composer.overrideUserInterfaceStyle = tabBarController!.overrideUserInterfaceStyle
        composer.mailComposeDelegate = self
        composer.setToRecipients(["kosov11@gmail.com"])
        composer.setSubject("EGEKit")
        composer.setMessageBody("Здравствуйте, я бы хотел узнать", isHTML: false)
        present(composer, animated: true)
    }
    
}
    
extension aboutViewControler: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
