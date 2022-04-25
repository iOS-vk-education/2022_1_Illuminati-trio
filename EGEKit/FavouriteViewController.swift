//
//  FavouriteViewController.swift
//  EGEKit
//
//  Created by Ilia Kosov on xx.04.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestoreSwift

class FavouriteViewController: UIViewController {
    
    var db: Firestore!
    var allTypes = [ExerciseType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBackground
        
//        let settings = FirestoreSettings()
//
//        Firestore.firestore().settings = settings
//        // [END setup]
//        db = Firestore.firestore()
//
//        async {
//            let result = await loadNamesSubNames()
//            switch result {
//            case .success(let res):
//                self.allTypes = res
//                print(allTypes.map{$0.typeName})
//            case .failure(let error):
//                print(error)
//            }
//
//        }
        
        }
    
//    func loadNamesSubNames() async -> Result<[ExerciseType], Error> {
//        do {
//            let doc = try await self.db.collection("Exercise").document("GlobalNames").getDocument()
//            let data = try doc.data(as: Types.self).exerciseTypes
//            return .success(data)
//        } catch {
//            return .failure(error)
//        }
//    }
    
}



        
