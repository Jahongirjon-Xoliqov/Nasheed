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

    
    
    
    
    
    
    func togglePlayback() {
        guard let player = player else { return } // Ensure player exists

        if isPlaying {
            player.pause()
            timer?.invalidate() // Stop progress updates
        } else {
            player.play()
            
            // Start a timer to track progress
            timer?.invalidate() // Stop previous timer
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

   
    func loadNasheed(_ nasheed: NasheedEntity) {
        guard let url = URL(string: nasheed.file) else {
            print("❌ Invalid URL for nasheed file: \(nasheed.file)")
            return
        }
        
        
        
        // Stop previous playback
        player?.pause()
        timer?.invalidate() // Stop previous timer
        
    
        // Load new audio file
        let newItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: newItem)
        

        // Reset progress and update total duration
        progress = 0.0
        totalDuration = 0.0

        // Fetch new duration BEFORE playing
        let asset = AVURLAsset(url: url)
        Task {
            do {
                try await asset.load(.duration)  // Load duration asynchronously
                let durationSeconds = await CMTimeGetSeconds(try! asset.load(.duration))
                
                await MainActor.run {
                    self.totalDuration = durationSeconds.isFinite ? durationSeconds : 0.0
                    
                    if self.totalDuration > 0 {
                        self.player?.play()
                        self.isPlaying = true
                        self.startTimer()
                    } else {
                        }
                }
            } catch {
                print("❌ Failed to load duration: \(error)")
            }
        }
    }



    
    
    

    
    func startTimer() {
        timer?.invalidate() // Stop previous timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.progress < self.totalDuration {
                self.progress += 1
            } else {
                self.timer?.invalidate()
                self.isPlaying = false
            }
        }
    }

    

    

    
    
    func seek(to time: Double) {
        let targetTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: targetTime)
        progress = time
    }
    

  
}

