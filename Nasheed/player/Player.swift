//
//  Player.swift
//  Nasheed
//
//  Created by Dzakhon on 10/03/25.
//

import SwiftUI
import FirebaseStorage
import AVKit

class MusicViewModel: ObservableObject {
    @Published var musicUrl: URL? = nil
    @Published var errorMessage: String? = nil

    func fetchMusicUrl() {
        let storage = Storage.storage()
        let musicRef = storage.reference().child("MP3/Muhammad_Tohir-Xuz_dimana_nashid.mp3")

        musicRef.downloadURL { url, error in
            if let error = error {
                self.errorMessage = "Error fetching URL: \(error.localizedDescription)"
                return
            }
            if let url = url {
                self.musicUrl = url
            }
        }
    }
}

struct MusicPlayerView: View {
    @StateObject private var viewModel = MusicViewModel()
    @State private var player: AVPlayer?

    var body: some View {
        VStack(spacing: 40) {
            if let musicUrl = viewModel.musicUrl {
                Button(action: {
                    print(musicUrl)
                    player = AVPlayer(url: musicUrl)
                    player?.play()
                }) {
                    Text("Play Music")
                }

                Button(action: {
                    downloadMusicFile(from: musicUrl)
                }) {
                    Text("Download Music")
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchMusicUrl()
        }
    }

    func downloadMusicFile(from url: URL) {
        let task = URLSession.shared.downloadTask(with: url) { localUrl, response, error in
            if let localUrl = localUrl {
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)

                do {
                    try FileManager.default.moveItem(at: localUrl, to: destinationUrl)
                    print("File saved to: \(destinationUrl)")
                } catch {
                    print("Error saving file: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}

