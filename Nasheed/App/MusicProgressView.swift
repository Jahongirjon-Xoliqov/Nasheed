//  Nasheed
//
//  Created by Abdulboriy on 19/02/25.
//

import SwiftUI

struct MusicProgressView: View {
    
    @ObservedObject var audioManager = AudioPlayerManager.shared
    
    @State private var progress: Double = 0.0
    let totalDuration: Double = 200 // Example: 200 seconds
    @State private var isPlaying: Bool = false

    
    @EnvironmentObject var viewModel: RecitersViewModel
    let reciter: NasheedEntity
    
    @Environment(\.colorScheme) var colorScheme

    var adaptiveBackground: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                                        
                  
                    GeometryReader { geometry in
                        let sliderWidth = geometry.size.width // Use full width
                        
                        ZStack(alignment: .leading) {
                            // Custom Track
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 4)
                            
                            // Custom Progress Bar
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.red)
                                .frame(width: (audioManager.progress / audioManager.totalDuration) * sliderWidth, height: 4)
                            
                            // Custom SF Symbol Thumb (Draggable)
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 14, height: 14) // Adjust thumb size
                                .foregroundColor(.red)
                                .offset(x: (audioManager.progress / audioManager.totalDuration) * sliderWidth - 7) // Fix thumb position
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let newProgress = min(max(0, value.location.x / sliderWidth * audioManager.totalDuration), audioManager.totalDuration)
                                            audioManager.seek(to: newProgress) // 🔥 Tell AVPlayer to move playback
                                        }
                                )
                        }
                        .contentShape(Rectangle()) // Make the entire area tappable
                        .onTapGesture { location in
                            let newProgress = min(max(0, location.x / sliderWidth * audioManager.totalDuration), audioManager.totalDuration)
                            audioManager.seek(to: newProgress) // 🔥 Tell AVPlayer to move playback
                        }
                    }
                    .frame(height: 20) // Ensure enough space for the thumb
                    
                    HStack {
                        Text(formatTime(audioManager.progress))  // Current time
                        Spacer()
                        Text(formatTime(audioManager.totalDuration)) // Total duration
                    }
                    .font(.caption)
                    .foregroundStyle(.primary)
                    
                    
                }//Vstack
                
                
                
                .frame(height: 28) // Keep layout consistent
                .padding(.horizontal)
                // End of Custom part
            }
            
            //MARK: - Audio Controlling Buttons
            HStack(spacing: 16) {
                Button {
                    audioManager.rewind15secs()
                } label: {
                    Image(systemName: "15.arrow.trianglehead.counterclockwise")
                        .font(.system(size: 24))
                        .padding(.trailing)
                        .foregroundStyle(adaptiveBackground)
                }
                
                Button {
                    viewModel.skipToPrevious()
                } label: {
                    HStack(spacing: -5) {
                        Image(systemName: "arrowtriangle.left.fill")
                            .font(.system(size: 19))
                            .foregroundStyle(adaptiveBackground)
                        Image(systemName: "arrowtriangle.left.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(adaptiveBackground)
                    }
                }
                .padding(.trailing)
                
                Button(action: {
                    audioManager.togglePlayback()
                }) {
                    Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                        .padding(.trailing)
                        .foregroundStyle(adaptiveBackground)
                    
                }
                
             
                
                Button {
                    viewModel.skipToNext()
                } label: {
                    HStack(spacing: -5) {
                        Image(systemName: "arrowtriangle.right.fill")
                            .font(.system(size: 22))                            .foregroundStyle(adaptiveBackground)
                        Image(systemName: "arrowtriangle.right.fill")
                            .font(.system(size: 19))
                            .foregroundStyle(adaptiveBackground)
                    }
                }
                
                
                .padding(.trailing)
                
                Button {
                    audioManager.fastForward15secs()
                } label: {
                    Image(systemName: "15.arrow.trianglehead.clockwise")
                        .font(.system(size: 24))
                        .foregroundStyle(adaptiveBackground)
                }
            }//Button HStack
            .padding(.vertical, 26)
            .padding(.bottom, 28)
       
            
            
            HStack {
                Button {
                    //cote to come
                }label: {
                    Image(systemName: "moon.zzz.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .tint(.secondary)
                }
                
                Spacer()
                
                Button {
                    viewModel.toggleLike(for: reciter)
                }label: {
                    Image(systemName: reciter.isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(reciter.isLiked ? .pink : .secondary)
                }
                
                Spacer()
                
                Button {
//                    isRepeating.toggle()
                }label: {
                    Image(systemName: "repeat")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .tint(.secondary)
                }
            }//Final Hstack
            .padding(.horizontal, 55)
            
            
        }//Outer Vstack
    }
    

    
    
    
    //MARK: - Functions
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    

    

}

#Preview {
    MusicProgressView(reciter: NasheedEntity(id: "sdfsdf", reciter: "Abdu", title: "Go go go", file: "https://firebasestorage.googleapis.com:443/v0/b/nasheed-65ef6.firebasestorage.app/o/MP3%2FOsama_al_Safi-Tabalagh_bellqaleel.mp3?alt=media&token=b72092b7-a2bf-4a8c-8cd1-53c212b87c18", reciterPhoto: "https://firebasestorage.googleapis.com:443/v0/b/nasheed-65ef6.firebasestorage.app/o/CoverImages%2FstandartCover.jpeg?alt=media&token=6ade49be-c174-415b-b1db-b0ddbf284895", cover: ""))
//        .colorScheme(.dark)
}
