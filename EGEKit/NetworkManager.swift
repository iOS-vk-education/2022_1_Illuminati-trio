//
//  NetworkManager.swift
//  EGEKit
//
//  Created by user on 16.04.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum NetworkError: Error {
    case badName
    case badUrl
}

protocol NetworkManagerProtocol: AnyObject {
    func loadUslovieAndSolution(at number: String) async -> (String,String)
    func loadExercises(with title: String, type: String) async -> [String]
    func loadTheoryNamesAndUrls() async -> ([String],[String])
    func loadNamesSubNames() async -> [ExerciseType]
}

final class NetworkManager : NetworkManagerProtocol {
    var db: Firestore!
    
    static let shared: NetworkManagerProtocol = NetworkManager()
    
    private init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func loadUslovieAndSolution(at number: String) async -> (String,String) {
        do {
            let doc = try await self.db.collection("ExerciseInfo")
                .document("\(number)")
                .getDocument()
            guard let uslovie = doc.get("uslovie") as? String else {
                throw NetworkError.badName
            }
            guard let solution = doc.get("solution") as? String else {
                throw NetworkError.badName
            }
            return (uslovie,solution)
        } catch (let error) {
            return ("\(error)","\(error)")
            }
    }
    
    func loadExercises(with title: String, type: String) async -> [String] {
        do {
            let doc = try await self.db.collection("Exercise")
                .document(type)
                .getDocument()
            guard let data = doc.get(title) as? [String] else {
                throw NetworkError.badName
            }
            return data
        } catch (let error) {
            return ["\(error)"]
            }
    }
    
    func loadTheoryNamesAndUrls() async -> ([String],[String]) {
        do {
            let doc = try await self.db.collection("Theory")
                .document("NamesAndUrls")
                .getDocument()
            guard let dataNames = doc.get("names") as? [String] else {
                throw NetworkError.badName
            }
            guard let dataUrls = doc.get("urls") as? [String] else {
                throw NetworkError.badUrl
            }
            return (dataNames,dataUrls)
        } catch (let error) {
            return (["\(error)"],[])
            }
    }
    
    func loadNamesSubNames() async -> [ExerciseType] {
        var result = [ExerciseType]()
        do {
            let doc = try await self.db
                .collection("Exercise")
                .document("GlobalNames")
                .getDocument()
            result = try doc.data(as: Types.self).exerciseTypes
        } catch (let error) {
            print(error)
        }
        return result
    }

}
