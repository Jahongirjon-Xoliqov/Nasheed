

//MARK: - Hope last edition
import SwiftData
import Foundation
import SwiftUI

@MainActor
class RecitersViewModel: ObservableObject {
    @Published var nasheeds: [NasheedEntity] = []
    private var modelContext: ModelContext

    @Published var currentNasheed: NasheedEntity? = nil
    private let audioPlayer = AudioPlayerManager.shared
    
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
    
 
    
    
    //MARK: - Function section
//    func skipToNext() {
//        guard !nasheeds.isEmpty else {
//            print("No nasheeds available")
//            return
//        }
//        
//        let currentIndex: Int
//        if let current = currentNasheed, let index = nasheeds.firstIndex(where: { $0.id == current.id }) {
//            currentIndex = index
//        } else {
//            // If no current nasheed is set, start with the first one
//            currentIndex = 0
//        }
//        
//        
//        
//        var nextIndex = currentIndex + 1
//        
//        if currentIndex >= nasheeds.count - 1 {
//            nextIndex = 0
//        }
//        
//        
//        let nextNasheed = nasheeds[nextIndex]
//        print("Skipping to next nasheed: \(nextNasheed.title)")
//        
//        currentNasheed = nextNasheed
//        audioPlayer.loadNasheed(nextNasheed)
//    }
    
    
    
//    func skipToPrevious() {
//        guard !nasheeds.isEmpty else {
//            print("No nasheeds available")
//            return
//        }
//        
//        let currentIndex: Int
//        if let current = currentNasheed, let index = nasheeds.firstIndex(where: { $0.id == current.id }) {
//            currentIndex = index
//        } else {
//            // If no current nasheed is set, start with the last one
//            currentIndex = 0
//        }
//        
//        var previousIndex = currentIndex - 1
//        
//        // Wrap around to the end if we're at the first nasheed
//        if previousIndex < 0 {
//            previousIndex = nasheeds.count - 1
//        }
//        
//        let previousNasheed = nasheeds[previousIndex]
//        print("Skipping to previous nasheed: \(previousNasheed.title)")
//        
//        currentNasheed = previousNasheed
//        audioPlayer.loadNasheed(previousNasheed)
//    }


    
    
    //
    func skipToNext() {
        guard !nasheeds.isEmpty else { return }
        
        let currentIndex: Int
        if let current = currentNasheed, let index = nasheeds.firstIndex(where: { $0.id == current.id }) {
            currentIndex = index
        } else {
            currentIndex = 0
        }
        
        let nextIndex = (currentIndex + 1) % nasheeds.count
        updateCurrentNasheed(to: nasheeds[nextIndex])
    }

    func skipToPrevious() {
        guard !nasheeds.isEmpty else { return }
        
        let currentIndex: Int
        if let current = currentNasheed, let index = nasheeds.firstIndex(where: { $0.id == current.id }) {
            currentIndex = index
        } else {
            currentIndex = 0
        }
        
        let prevIndex = (currentIndex - 1 + nasheeds.count) % nasheeds.count
        updateCurrentNasheed(to: nasheeds[prevIndex])
    }

    // New unified update method
    private func updateCurrentNasheed(to nasheed: NasheedEntity) {
        // 1. Update audio
        audioPlayer.loadNasheed(nasheed)
        
        // 2. Update title and image (triggers UI refresh via @Published)
        currentNasheed = nasheed
        
        print("Now Playing: \(nasheed.title) | Image: \(nasheed.reciterPhoto)")
    }
    
    
    
//    New
    func loadNasheeds(select nasheedToPlay: NasheedEntity? = nil) {
        let fetchDescriptor = FetchDescriptor<NasheedEntity>()
        do {
            nasheeds = try modelContext.fetch(fetchDescriptor)

            // Optional: Set and play a specific nasheed after loading all
            if let nasheedToPlay = nasheedToPlay {
                if let matchedNasheed = nasheeds.first(where: { $0.id == nasheedToPlay.id }) {
                    print("✅ Setting currentNasheed to: \(matchedNasheed.title)")
                    currentNasheed = matchedNasheed
                    audioPlayer.loadNasheed(matchedNasheed)
                } else {
                    print("❌ selected nasheed not found in fresh fetch!")
                }
            }

        } catch {
            print("❌ Fetching Error: \(error.localizedDescription)")
        }
    }

    
    
    
    //new
    func fetchNasheeds() async {
        await APIManager.shared.requestNasheedsList(modelContext: modelContext)
        let previousNasheed = currentNasheed // Store the currently playing nasheed
        loadNasheeds() // Reload after fetching

        // Try to find and restore the previously playing nasheed
        if let previousNasheed = previousNasheed,
           let updatedNasheed = nasheeds.first(where: { $0.id == previousNasheed.id }) {
            currentNasheed = updatedNasheed
        }
    }

    
    
    //new
    func toggleLike(for nasheed: NasheedEntity) {
        nasheed.isLiked.toggle()
        try? modelContext.save()

        // Instead of `loadNasheeds()`, update only the liked state
        if let index = nasheeds.firstIndex(where: { $0.id == nasheed.id }) {
            nasheeds[index].isLiked = nasheed.isLiked
        }
    }

    
    
    
    
    func toggleDownload(for nasheed: NasheedEntity) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 4.5) {
            DispatchQueue.main.async {
                nasheed.isDownloaded = true
                try? self.modelContext.save()

                // Instead of `loadNasheeds()`, update only the downloaded state
                if let index = self.nasheeds.firstIndex(where: { $0.id == nasheed.id }) {
                    self.nasheeds[index].isDownloaded = true
                }
            }
        }
    }

}

