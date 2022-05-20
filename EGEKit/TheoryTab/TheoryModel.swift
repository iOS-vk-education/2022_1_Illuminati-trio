import Foundation

final class TheoryModel {
    private let networkManager = NetworkManager.shared
    var theoryNames: [String] = []
    var theoryUrls: [String] = []

    
    func getNamesUrls(completion: @escaping () -> Void) {
        Task {
            let result = await networkManager.loadTheoryNamesAndUrls()
            theoryNames = result.0
            theoryUrls = result.1
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
