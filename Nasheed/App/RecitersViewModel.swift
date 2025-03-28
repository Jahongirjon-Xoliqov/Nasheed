//
//  RecitersViewModel.swift
//  Nasheed
//
//  Created by Abdulboriy on 28/02/25.
//

/*
 ReciterData(name: "Muhammad Tohir", nasheedName: "Xuz Dimana"),
 ReciterData(name: "Unknown", nasheedName: "Kun Musliman"),
 ReciterData(name: "Mishary Al Afasy", nasheedName: "Ana Al Abdu"),
 ReciterData(name: "Ahmed Bukhatir", nasheedName: "Ya Adheeman"),
 ReciterData(name: "Amr Diab", nasheedName: "Habibi ya noor el ein"),
 ReciterData(name: "Unknown", nasheedName: "Xuyulun"),
 ReciterData(name: "Mishary Al Afasy", nasheedName: "Aya Man Yadail Fahm"),
 ReciterData(name: "Ahmed Bukhatir", nasheedName: "Dar al Ghuroor"),
 ReciterData(name: "Mishary Al Arada", nasheedName: "Ashku IlAlloh"),
 ReciterData(name: "Unknown", nasheedName: "Qara Bayraqim"),
 ReciterData(name: "Abu Ali", nasheedName: "Fataat Al Khair"),
 ReciterData(name: "Baraa Masoud", nasheedName: "La La Tahsab Annad Dina")
 */

//import Foundation
//import SwiftUI

//class RecitersViewModel: ObservableObject {
//    @Published var reciters: [ReciterData] = []
//    
//    func fetchReciters() async {
//         let nasheeds = await APIManager.shared.requestNasheedsList()
//         
//         self.reciters = nasheeds.map { nasheed in
//             ReciterData(name: nasheed.reciter, nasheedName: nasheed.title)
//         }
//     }
//    
//    var likedReciters: [ReciterData] {
//        reciters.filter { $0.isLiked }
//    }
//    
//    var downloadedReciters: [ReciterData] {
//        reciters.filter { $0.isDownloaded }
//    }
//
//    func toggleLike(for reciter: ReciterData) {
//        if let index = reciters.firstIndex(where: { $0.id == reciter.id }) {
//            reciters[index].isLiked.toggle()
//        }
//    }
//    
//    func toggleDownload(for reciter: ReciterData) {
//        if let index = reciters.firstIndex(where: { $0.id == reciter.id }) {
//            DispatchQueue.global().asyncAfter(deadline: .now() + 4.5) {
//                DispatchQueue.main.async {
//                    self.reciters[index].isDownloaded = true
//                }
//            }
//        }
//    }
//}

/////-----------2nd edition
//@MainActor
//class RecitersViewModel: ObservableObject {
//    @Published var nasheeds: [Nasheed] = []
//    
//    
//    func fetchNasheeds() async {
//        let fetchedNasheeds = await APIManager.shared.requestNasheedsList()
//        
//        
//        self.nasheeds = fetchedNasheeds
//        
//    }
//    
//    var likedNasheeds: [Nasheed] {
//        nasheeds.filter { $0.isLiked }
//    }
//    
//    var downloadedNasheeds: [Nasheed] {
//        nasheeds.filter { $0.isDownloaded }
//    }
//
//    func toggleLike(for nasheed: Nasheed) {
//        if let index = nasheeds.firstIndex(where: { $0.id == nasheed.id }) {
//            nasheeds[index].isLiked.toggle()
//        }
//    }
//    
//    func toggleDownload(for nasheed: Nasheed) {
//        if let index = nasheeds.firstIndex(where: { $0.id == nasheed.id }) {
//            DispatchQueue.global().asyncAfter(deadline: .now() + 4.5) {
//                DispatchQueue.main.async {
//                    self.nasheeds[index].isDownloaded = true
//                }
//            }
//        }
//    }
//}


//MARK: - Hope last edition
import SwiftData
import Foundation
import SwiftUI

@MainActor
class RecitersViewModel: ObservableObject {
    @Published var nasheeds: [NasheedEntity] = []
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadNasheeds()
    }
    
    var likedNasheeds: [NasheedEntity] {
          nasheeds.filter { $0.isLiked }
      }
  
    var downloadedNasheeds: [NasheedEntity] {
          nasheeds.filter { $0.isDownloaded }
      }

    func loadNasheeds() {
        let fetchDescriptor = FetchDescriptor<NasheedEntity>()
        do {
            nasheeds = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("❌ Fetching Error: \(error.localizedDescription)")
        }
    }

    func fetchNasheeds() async {
        await APIManager.shared.requestNasheedsList(modelContext: modelContext)
        loadNasheeds() // Reload after fetching
    }

    func toggleLike(for nasheed: NasheedEntity) {
        nasheed.isLiked.toggle()
        try? modelContext.save()
        loadNasheeds()
    }
    
    func toggleDownload(for nasheed: NasheedEntity) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 4.5) {
            DispatchQueue.main.async {
                nasheed.isDownloaded = true
                try? self.modelContext.save()
                self.loadNasheeds()
            }
        }
    }
}

