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

//import Foundation
//final class APIManager {
//    static let shared = APIManager()
//    private init() {}
//
//    func requestNasheedsList() async -> [Nasheed] {
//        let urlString = "https://getcontent-zonuxl5i3a-uc.a.run.app"
//        
//        guard let url = URL(string: urlString) else {
//            print("❌ Invalid URL")
//            return []
//        }
//
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//
//            // Convert JSON to string and print it
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("📜 JSON Response: \(jsonString)")
//            }
//
//            return try JSONDecoder().decode([Nasheed].self, from: data)
//        } catch {
//            print("❌ API Error: \(error.localizedDescription)")
//            return []
//        }
//    }
//}


//MARK: - Last edition
import Foundation
import SwiftData

final class APIManager {
    static let shared = APIManager()
    private init() {}

    @MainActor
    func requestNasheedsList(modelContext: ModelContext) async {
        let urlString = "https://getcontent-zonuxl5i3a-uc.a.run.app"
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            // Convert JSON to string and print it (for debugging)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📜 JSON Response: \(jsonString)")
            }

            // Decode API response
            let fetchedNasheeds = try JSONDecoder().decode([Nasheed].self, from: data)
            print("✅ Decoded Nasheeds: \(fetchedNasheeds)")
            print("D1")

            // Fetch existing Nasheeds from SwiftData
            let fetchDescriptor = FetchDescriptor<NasheedEntity>()
            let testFetch = try! modelContext.fetch(fetchDescriptor)
            print("🧐 TEST FETCH: \(testFetch)")
           
            let existingNasheeds = try modelContext.fetch(fetchDescriptor)
            print("📌 Existing Nasheeds Count: \(existingNasheeds.count)")
            

            for nasheed in fetchedNasheeds {
                // Check if this nasheed already exists in SwiftData
                let alreadyExists = existingNasheeds.contains { $0.id == nasheed.id }
                            print("🔍 Checking if exists: \(nasheed.id) -> \(alreadyExists)")
                
                if !existingNasheeds.contains(where: { $0.id == nasheed.id }) {
                    let newNasheed = NasheedEntity(
                        id: nasheed.id,
                        reciter: nasheed.reciter,
                        title: nasheed.title,
                        file: nasheed.file,
                        reciterPhoto: nasheed.reciterPhoto,
                        cover: nasheed.cover
                        
                    )
                    print("✅ Inserting Nasheed: \(newNasheed)")
                    modelContext.insert(newNasheed)
                }
            }

            // Save changes to SwiftData
            
            
            try modelContext.save()
            print("💾 SwiftData Save Successful")
            // 🟢 Fetch again to confirm data is saved
            
            
            
            let updatedNasheeds = try modelContext.fetch(fetchDescriptor)
            print("✅ New Nasheeds in SwiftData: \(updatedNasheeds)")

        } catch {
            print("❌ API Error: \(error.localizedDescription)")
        }
    }
}
