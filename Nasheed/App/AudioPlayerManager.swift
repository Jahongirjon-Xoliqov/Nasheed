//
//  AudioPlayerManager.swift
//  Nasheed
//
//  Created by Abdulboriy on 29/03/25.
//

import Foundation
import AVFoundation

class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()
    private var cache: [URL: AVPlayerItem] = [:] // Cache for listened nasheeds
    
//    private var preloadedItems: [String: AVPlayerItem] = [:]
    
    private var player: AVPlayer?
    private var playerObserver: Any?
    
    @Published var isPlaying = false
    @Published var progress: Double = 0.0
    @Published var totalDuration: Double = 0.0
    
    private var timer: Timer?
    
    private init() {}
    
    
    
    func playNasheed(from url: URL) {
        if let cachedItem = cache[url] {
            print("✅ Using cached nasheed")
            
            // ❌ Don't reuse the same AVPlayerItem
            // ❌ player?.replaceCurrentItem(with: cachedItem)

            // ✅ Create a new AVPlayerItem from the same URL
            let newItem = AVPlayerItem(url: url)

            // ✅ Replace it in the cache (optional)
            cache[url] = newItem
            
            // ✅ Assign to player
            player = AVPlayer(playerItem: newItem)
            
        } else {
            print("🆕 Downloading and caching nasheed")
            let newItem = AVPlayerItem(url: url)
            cache[url] = newItem
            player = AVPlayer(playerItem: newItem)
        }

        player?.play()
    }

    
    
//    func prepareNasheed(for url: URL) {
//        if preloadedItems[url.absoluteString] == nil {
//            let playerItem = AVPlayerItem(url: url)
//            preloadedItems[url.absoluteString] = playerItem
//        }
//    }
    


    
//    func playNasheed(from url: URL) {
//        if player?.currentItem == nil || player?.currentItem?.asset != AVURLAsset(url: url) {
//            player = AVPlayer(url: url) // Only set a new player if needed
//        }
//        
//        player?.play()
//        isPlaying = true
//    }
    
    
    
    
    func loadNasheed(_ nasheed: NasheedEntity) {
        guard let url = URL(string: nasheed.file) else {
            print("❌ Invalid URL for nasheed file: \(nasheed.file)")
            return
        }
        
        // Stop previous playback
        player?.pause()
        
        // Load new audio file
        let newItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: newItem)
        
        // Reset progress and update total duration
        progress = 0.0
        totalDuration = 0.0
        
        // Fetch new duration
        let asset = AVURLAsset(url: url)

        Task {
            do {
                try await asset.load(.duration)  // Load duration asynchronously
                let durationSeconds = CMTimeGetSeconds(asset.duration)
                
                await MainActor.run {
                    self.totalDuration = durationSeconds.isFinite ? durationSeconds : 0.0
                }
            } catch {
                print("❌ Failed to load duration: \(error)")
            }
        }

        
        // Play the new nasheed
        player?.play()
        isPlaying = true
    }

    
    
    func seek(to time: Double) {
        let targetTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: targetTime)
        progress = time
    }
    

    func togglePlayback(for nasheed: NasheedEntity) {
        guard let url = URL(string: nasheed.file) else {
            print("❌ Invalid MP3 URL: \(nasheed.file)")
            return
        }
        
        if player == nil {
            player = AVPlayer(url: url)
            
            // Fetch the actual duration using new API (iOS 16+)
            let asset = AVURLAsset(url: url)
            Task {
                do {
                    let duration = try await asset.load(.duration)
                    DispatchQueue.main.async {
                        let durationInSeconds = CMTimeGetSeconds(duration)
                        self.totalDuration = durationInSeconds.isFinite ? durationInSeconds : 0.0
                        print("⏳ MP3 Duration: \(self.totalDuration) seconds")
                    }
                } catch {
                    print("❌ Error loading duration: \(error.localizedDescription)")
                }
            }
            
            // Observer to track playback time updates
            playerObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
                self?.progress = CMTimeGetSeconds(time)
            }
        }

        if isPlaying {
            player?.pause()
            timer?.invalidate() // Stop progress updates
        } else {
            player?.play()
            
            // Start a timer to track progress
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.progress < self.totalDuration {
                    self.progress += 1
                } else {
                    self.timer?.invalidate() // Stop when the nasheed ends
                    self.isPlaying = false
                }
            }
        }
        
        isPlaying.toggle()
    }
}

