//
//  TabBarController.swift
//  EGEKit
//
//  Created by Ilia Kosov on xx.04.2022.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let viewC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginV")
//        
//        self.window?.rootViewController?.present(viewC, animated: false)
        
        let favouriteVC = FavouriteViewController()
        let exerciseVC = ExerciseViewController()
        let theoryVC = TheoryViewController()
        let settingsVC = SettingsViewController()
        
        favouriteVC.title = "Избранное"
        exerciseVC.title = "Задачи"
        theoryVC.title = "Теория"
        settingsVC.title = "Настройки"
//        self.tabBar.backgroundColor = .tertiarySystemFill
        
        let arrayVC : [UIViewController] = [favouriteVC,exerciseVC,theoryVC,settingsVC]
        
        self.setViewControllers(arrayVC, animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["star", "book", "graduationcap", "gear"]

        for i in 0..<arrayVC.count {
            items[i].image = UIImage(systemName: images[i])
        }
        
    }
    
}
