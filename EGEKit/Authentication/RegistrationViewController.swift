//
//  RegistrationViewController.swift
//  EGEKit
//
//  Created by user on 13.05.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var regButton: CustomButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    private var email: String { emailField.text! }
    private var password: String { passField.text! }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regButton.addTarget(self, action: #selector(makeLogin), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        supportDarkTheme()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    @objc
    private func makeLogin() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            guard error == nil else {
                self?.errorLabel.text = error?.localizedDescription
                self?.errorLabel.isHidden = false
                return
            }
            
            let db = NetworkManager.shared.db
            
            db!.collection("users").document((self?.email)!).setData([:])
            
            NetworkManager.userEmail = (self?.email)!
            
//            UserDefaults.standard.set([], forKey: FavouriteManager.favouritesKey)
            FavouriteManager.shared.eraseFavourites()
            
//            NotificationCenter.default.post(name: FavouriteManager.favouritesNotificationKey, object: nil)
            
            self?.dismiss(animated: true)
        }
    }
}
