//
//  SettingsViewController.swift
//  EGEKit
//
//  Created by Ilia Kosov on xx.04.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import PinLayout

class SettingsViewController: UIViewController {
    
    private let logOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutButton.configuration = setupButton()
        logOutButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
        view.addSubview(logOutButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logOutButton.pin.center().sizeToFit()
    }
    
    private func setupButton() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.title = "Выйти из аккаунта"
        config.baseBackgroundColor = .systemIndigo
        return config
    }
    
    @objc
    private func handleLogOut() {
        do {
            try Auth.auth().signOut()
        
            let loginViewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialLoginViewController")
            
            let navC = UINavigationController(rootViewController: loginViewController)
            navC.modalPresentationStyle = .fullScreen
            self.present(navC, animated: true)
            self.tabBarController?.selectedIndex = 0
        } catch let signOutError as NSError {
            print("Error signing out \(signOutError)")
        }
    }
}
