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
    weak var tabController: TabBarController?
    
    private let logOutButton = UIButton()
    private let styleButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Настройки"
                
        logOutButton.configuration = setupButton()
        logOutButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
        view.addSubview(logOutButton)
        view.addSubview(styleButton)
        
        let themeMenu = UIMenu(title: "Тема оформления", children: [
            UIAction(title: "Светлая"){_ in
                self.tabController?.overrideUserInterfaceStyle = .light
                UserDefaults.standard.set(self.tabController?.overrideUserInterfaceStyle.rawValue, forKey: "Theme")

            },
            UIAction(title: "Темная"){_ in
                self.tabController?.overrideUserInterfaceStyle = .dark
                UserDefaults.standard.set(self.tabController?.overrideUserInterfaceStyle.rawValue, forKey: "Theme")
            },
            UIAction(title: "Как в системе"){_ in
                self.tabController?.overrideUserInterfaceStyle = .unspecified
                UserDefaults.standard.set(self.tabController?.overrideUserInterfaceStyle.rawValue, forKey: "Theme")
            }
        ])
        
        let themeButton = UIBarButtonItem(image: UIImage(systemName: "moon.circle.fill"), menu: themeMenu)
        navigationItem.rightBarButtonItem = themeButton
        
        
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
