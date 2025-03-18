//
//import Foundation
//
//final class APIManager {
//    
//    static let shared = APIManager()
//    private init() {}
//    
//    func requestNasheedsList(completion: @escaping ([Nasheed]) -> ()) {
//        let urlString = "https://getcontent-zonuxl5i3a-uc.a.run.app"
//        
//        guard let url = URL(string: urlString) else {
//            completion([])
//            return
//        }
//        
//        Task {
//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                let json = try JSONDecoder().decode([Nasheed].self, from: data)
//                completion(json)
//            } catch {
//                completion([])
//            }
//        }
//    }
//    
//}

//--------------

import Foundation

final class APIManager {
    static let shared = APIManager()
    private init() {}

    func requestNasheedsList(completion: @escaping ([Nasheed]) -> ()) {
        let urlString = "https://getcontent-zonuxl5i3a-uc.a.run.app"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion([])
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                // Convert JSON to string and print it
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("📜 JSON Response: \(jsonString)")
                } else {
                    print("❌ Failed to convert data to string")
                }

                let json = try JSONDecoder().decode([Nasheed].self, from: data)
                DispatchQueue.main.async {
                    completion(json)
                }
            } catch {
                print("❌ API Error: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}



