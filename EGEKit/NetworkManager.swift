//
//  NetworkManager.swift
//  EGEKit
//
//  Created by user on 16.04.2022.
//

import Foundation
import HTMLKit
import Firebase
import FirebaseFirestoreSwift

struct Theory {
    let name: String
    let urlString: String
}

class NetworkManager {
    var db: Firestore!
    
    static let shared = NetworkManager()
    
    private init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }

    
    func loadNamesSubNames() async -> Result<[ExerciseType], Error> {
        do {
            let doc = try await self.db.collection("Exercise").document("GlobalNames").getDocument()
            let data = try doc.data(as: Types.self).exerciseTypes
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    let urlString = "https://math-ege.sdamgia.ru/page/theory"
    
    func loadHtml(with url: String) -> HTMLDocument {
        
        guard let myURL = URL(string: url) else {
            print("Error: \(urlString) doesn't seem to be a valid URL")
            return .init()
        }

        guard let myHTMLString = try? String(contentsOf: myURL, encoding: .utf8) else {
            return .init()
        }
        
        return HTMLDocument(string: myHTMLString)
        
    }
    
    func loadTheory(with url: String) -> [Theory] {
        
        let html = self.loadHtml(with: url)
        
        let cellNames = html.querySelectorAll("table")
        
        let theoryName = cellNames[1].querySelectorAll("a")
        
        let theoryUrls: [String] = theoryName.map({ element in
            guard var href = element.attributes["href"] as? String else {
                return ""
            }
            href = href.replacingOccurrences(of: "http", with: "https")
            href = href.replacingOccurrences(of: "html", with: "pdf")
            
            return href
        })
        
        var theorys: [Theory] = []
        
        for i in 0..<theoryName.count {
            theorys.append(Theory(name: theoryName[i].textContent, urlString: theoryUrls[i]))
        }
        
        return theorys
        
    }
    
    func getSubExUrls() -> [[String]] {
        
        let document = self.loadHtml(with: "https://ege.sdamgia.ru/prob_catalog")
        
        let subZ = document.querySelectorAll("a")
        
        var namesSubZUrl: [String] = subZ.compactMap({ element in
            var hr = ""
            
            if element.className == "cat_name" && !element.textContent.isEmpty {
                guard let href = element.attributes["href"] as? String else {
                    return "gg"
                }
                hr = href
            }
            return hr
        })
        
        namesSubZUrl.removeAll{$0.isEmpty}
        
        let add = "https://math-ege.sdamgia.ru"
        let add2 = "&amp;print=true"
    
        for i in 0..<namesSubZUrl.count {
            namesSubZUrl[i] = add + namesSubZUrl[i] + add2
        }
        
        var arrayOfSubZUrl: [[String]] = [[]]
        
        let eachLength2: [Int] = [6,1,9,11,11,4,8,6,7,2,6,7,8,7,4,4,11,4,3,5,3,4,4,7,1,5,6,2,3,1,3,4,4,1,3,4,3]
        
        var array2 = [String]()

        for j in 0..<eachLength2.count {
            array2.removeAll()
            for i in 0..<eachLength2[j] {
                array2.append(namesSubZUrl[i])
            }
            arrayOfSubZUrl.append(array2)
            namesSubZUrl.removeSubrange(0..<eachLength2[j])
        }
        arrayOfSubZUrl.remove(at: 0)
        
        return arrayOfSubZUrl
    }
    
    func getExerciseNumbers(with url: String) -> [String] {
        
        let document = self.loadHtml(with: url)
        
        let elements = document.querySelectorAll("a")
        
        var kekes = elements.map {
            $0.textContent.filter("0123456789".contains)
        }
        
        kekes.removeAll{$0.isEmpty}
        
        kekes = kekes.filter{$0.count > 4}
        
        kekes.forEach {
            print($0)
        }
        
        return kekes
    }
            
    func getExercise(with url: String) -> [String] {
        
        let document = self.loadHtml(with: url)

        let elements = document.querySelectorAll("div")

        var kekes: [String] = elements.map { element in
            var name: String = ""
            
            if element.className == "pbody" {
                name = element.outerHTML
            }
            
            return name
        }

        kekes.removeAll{$0.isEmpty}
    
        return kekes
}
}
