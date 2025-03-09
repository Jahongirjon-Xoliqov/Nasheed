//  Nasheed
//
//  Created by Abdulboriy on 19/02/25.
//

import SwiftUI

struct MusicProgressView: View {
    @State private var progress: Double = 0.0
    let totalDuration: Double = 200 // Example: 200 seconds
    @State private var isPlaying: Bool = false
    @State private var timer: Timer?
    @State private var isRepeating: Bool = false
    @State private var isLiked: Bool = false
    
    @EnvironmentObject var viewModel: RecitersViewModel
    let reciter: ReciterData
    
    @Environment(\.colorScheme) var colorScheme

    var adaptiveBackground: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    
                    // Custom part
                    GeometryReader { geometry in
                        let sliderWidth = geometry.size.width // Use full width
                        
                        
                        //
                        ZStack(alignment: .leading) {
                            // Custom Track
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 4)
                            
                            // Custom Progress Bar
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.red)
                                .frame(width: (progress / totalDuration) * sliderWidth, height: 4)
                            
                            // Custom SF Symbol Thumb (Draggable)
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 14, height: 14) // Adjust thumb size
                                .foregroundColor(.red)
                                .offset(x: (progress / totalDuration) * sliderWidth - 7) // Fix thumb position
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let newProgress = min(max(0, value.location.x / sliderWidth * totalDuration), totalDuration)
                                            progress = newProgress
                                        }
                                )
                        }
                        .contentShape(Rectangle()) // Make the entire area tappable
                        .onTapGesture { location in
                            let newProgress = min(max(0, location.x / sliderWidth * totalDuration), totalDuration)
                            progress = newProgress
                        }//Zstack
                        
                        
                        
                    }
                    .frame(height: 20) // Ensure enough space for the thumb
                    
                    HStack {
                        Text(formatTime(progress))  // Current time
                        Spacer()
                        Text(formatTime(totalDuration)) // Total duration
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
                    // Rewind 15 seconds
                } label: {
                    Image(systemName: "15.arrow.trianglehead.counterclockwise")
                        .font(.system(size: 24))
                        .padding(.trailing)
                        .foregroundStyle(adaptiveBackground)
                }
                
                Button {
                    // Skip backward
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
                    togglePlayback()
                }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.largeTitle)
                        .padding(.trailing)
                        .foregroundStyle(adaptiveBackground)
                    
                }
                
                
                Button {
                    // Skip forward
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
                    // Fast forward 15 seconds
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
                    isRepeating.toggle()
                }label: {
                    Image(systemName: isRepeating ? "repeat.1" : "repeat")
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
    
    func togglePlayback() {
        if isPlaying {
            timer?.invalidate() // Pause
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if progress < totalDuration {
                    progress += 1
                } else {
                    timer?.invalidate() // Stop when song ends
                    isPlaying = false
                }
            }
        }
        isPlaying.toggle()
    }
}

#Preview {
    MusicProgressView(reciter: ReciterData(name: "Test", nasheedName: "Test"))
//        .colorScheme(.dark)
}
