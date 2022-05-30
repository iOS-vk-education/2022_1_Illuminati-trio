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
import MessageUI

class SettingsViewController: UIViewController {
    weak var tabController: TabBarController?
    
    private let settingsTable = UITableView(frame: .zero, style: .insetGrouped)
    private let logOutButton = UIButton()
    private let styleButton = UIButton()
    private let model = SettingsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Настройки"
        
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.register(SettingsTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        
        view.backgroundColor = .systemBackground
        view.addSubview(settingsTable)
        setupThemeSwitcher()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTable.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsTable.reloadData()
    }
    
    private func setupThemeSwitcher() {
        let themeMenu = UIMenu(title: "Тема оформления", children: [
            UIAction(title: "Светлая"){_ in
                self.tabController?.overrideUserInterfaceStyle = .light
                UserDefaults.standard.set(self.tabController?.overrideUserInterfaceStyle.rawValue, forKey: "Theme")
                self.settingsTable.reloadData()
            },
            UIAction(title: "Темная"){_ in
                self.tabController?.overrideUserInterfaceStyle = .dark
                UserDefaults.standard.set(self.tabController?.overrideUserInterfaceStyle.rawValue, forKey: "Theme")
                self.settingsTable.reloadData()
            },
            UIAction(title: "Как в системе"){_ in
                self.tabController?.overrideUserInterfaceStyle = .unspecified
                UserDefaults.standard.set(self.tabController?.overrideUserInterfaceStyle.rawValue, forKey: "Theme")
                self.settingsTable.reloadData()
            }
        ])
        
        let themeButton = UIBarButtonItem(image: UIImage(systemName: "moon.circle.fill"), menu: themeMenu)
        navigationItem.rightBarButtonItem = themeButton
        
        view.addSubview(styleButton)
        
    }
    
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

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.Sections[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        model.Sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.Sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? SettingsTableViewCell else { return .init() }
        cell.accessoryType = .none

        cell.midText.isHidden = true
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = model.Sections[indexPath.section].options[indexPath.row].name
        cell.rightText.isHidden = true
        if indexPath.section == 0 {
            let currentTheme = self.tabController?.overrideUserInterfaceStyle.rawValue
            cell.rightText.isHidden = false
            cell.rightText.textColor = .systemBlue
            switch currentTheme {
            case 0:
                cell.rightText.text = "Как в системе"
            case 1:
                cell.rightText.text = "Светлая"
            case 2:
                cell.rightText.text = "Темная"
            default:
                "gg"
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.rightText.isHidden = false
                cell.rightText.text = NetworkManager.userEmail
                cell.rightText.textColor = .systemBlue
            } else if indexPath.row == 3 {
                contentConfig.text = ""
                cell.midText.isHidden = false
                cell.midText.text = "Выйти"
            } else {
                contentConfig.textProperties.color = .systemBlue
            }
        }
        
        if indexPath.section == 2 {
            cell.accessoryType = .disclosureIndicator

        }
        
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            switch indexPath.row {
            case 1:
                FavouriteManager.shared.eraseRecents()
            case 2:
                FavouriteManager.shared.eraseFavourites()
            case 3:
                handleLogOut()
            default:
                "gg"
            }
        }
        if indexPath.section == 2 {
            navigationController?.pushViewController(aboutViewControler(), animated: true)
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
