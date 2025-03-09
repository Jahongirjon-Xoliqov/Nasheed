//
//  RecitersViewModel.swift
//  Nasheed
//
//  Created by Abdulboriy on 28/02/25.
//

import Foundation
import SwiftUI

class RecitersViewModel: ObservableObject {
    @Published var reciters: [ReciterData] = [
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
    ]
    
    func toggleLike(for reciter: ReciterData) {
        if let index = reciters.firstIndex(where: { $0.id == reciter.id }) {
            reciters[index].isLiked.toggle()
            objectWillChange.send()
        }
    }
    
    
    var likedReciters: [ReciterData] {
        reciters.filter { $0.isLiked }
    }
    
    
    func toggleDownload(for reciter: ReciterData) {
        if let index = reciters.firstIndex(where: { $0.id == reciter.id }) {
            DispatchQueue.global().asyncAfter(deadline: .now() + 4.5) {
                DispatchQueue.main.async {
                    
            self.reciters[index].isDownloaded = true
                    self.objectWillChange.send()
                }
            }
        }
    }
//    
    var savedReciters: [ReciterData] {
        reciters.filter { $0.isDownloaded }
    }
    
}
