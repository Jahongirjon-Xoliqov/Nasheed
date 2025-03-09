//
//  ReciterRow.swift
//  Nasheed
//
//  Created by Abdulboriy on 28/02/25.
//






//MARK: - New Version
import Foundation
import SwiftUI

struct ReciterRow: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var textColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }

    
    var reciter: ReciterData
    @EnvironmentObject var viewModel: RecitersViewModel
    
    @State private var isDownloading = false
    @State private var showCheckmark = false
    @State private var completedParts: Int = 0
    
    
    let totalParts: Int = 3 // Change this dynamically based on file size

    var body: some View {
        HStack {
            Image("nasheed2")
                .resizable()
                .frame(width: 46, height: 46)
                .cornerRadius(36)
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(reciter.nasheedName).font(.title3)
                    .fontDesign(.serif)
                    .foregroundStyle(textColor)

                Text(reciter.name).font(.subheadline)
                    .fontDesign(.serif)
                    .foregroundStyle(textColor.secondary)
            }
            Spacer()

            if !reciter.isDownloaded {
                if isDownloading {
                    ProgressView(value: Double(completedParts), total: Double(totalParts))
                        .progressViewStyle(QuarterCircleProgressViewStyle(parts: totalParts))
                        .frame(width: 24, height: 24)
                        .transition(.opacity)
                } else if showCheckmark {
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .transition(.opacity)
                } else {
                    Button(action: startDownload) {
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.system(size: 20))
                            .foregroundStyle(.red)
                            .fontWeight(.semibold)
                            .padding(.trailing, 6)
                    }
                }
                
            }
        }
        .padding(.horizontal, 1)
        .padding(.vertical, 2)
        .animation(.easeInOut, value: isDownloading)
        .animation(.easeInOut, value: showCheckmark)
//        .background(.brown)
    }
    
    
    //MARK: - Func
    func startDownload() {
        isDownloading = true
        viewModel.toggleDownload(for: reciter)
        completedParts = 0

        // Step-by-step update
        for i in 1...totalParts {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                withAnimation {
                    completedParts = i
                }
            }
        }

        // After all parts are completed
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalParts)) {
            isDownloading = false
            showCheckmark = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showCheckmark = false
                viewModel.toggleDownload(for: reciter)

            }
        }
    }
}




//MARK: - Custom ProgressViewStyle
struct QuarterCircleProgressViewStyle: ProgressViewStyle {
    let parts: Int // Number of steps

    func makeBody(configuration: Configuration) -> some View {
        let completedSteps = Int(configuration.fractionCompleted! * Double(parts))
        let partSize = 1 / CGFloat(parts) // Each part fills an equal section

        return ZStack {
//             Background track
            Circle()
                .trim(from: 0, to: CGFloat(parts))
                .stroke(Color.gray.opacity(0.3), lineWidth: 2.4)
                .rotationEffect(.degrees(-90))

            // Draw completed steps one by one
            ForEach(0..<completedSteps, id: \.self) { i in
                Circle()
                    .trim(from: 0 + (partSize * CGFloat(i)),
                          to: 0 + (partSize * CGFloat(i + 1)))
                    .stroke(Color.blue, lineWidth: 2.4)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.3), value: completedSteps)
            }
        }
        .frame(width: 24, height: 24)
    }
}
    
    
    
#Preview {
    ReciterRow(reciter: ReciterData(name: "Abdulboriy", nasheedName: "Mening Nashidim"))
}
    
    
    
    
// MARK: - Old version
//    let reciter: ReciterData
//    @ObservedObject var viewModel: RecitersViewModel
//    @State private var isDownloading = false
//    @State private var showCheckmark = false
//    @State private var progress: CGFloat = 0.0
//    
//    var body: some View {
//        HStack {
//            Image("nasheed2")
//                .resizable()
//                .frame(width: 46, height: 46)
//                .cornerRadius(36)
//                .padding(.trailing, 10)
//            //                .padding(.leading, 4)
//            
//            VStack(alignment: .leading) {
//                Text(reciter.nasheedName).font(.title3)
//                    .fontDesign(.serif)
//                
//                Text(reciter.name).font(.subheadline)
//                    .fontDesign(.serif)
//                    .foregroundStyle(.secondary)
//            }
//            Spacer()
//            
//            if isDownloading {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .transition(.opacity)
//            } else if showCheckmark {
//                Image(systemName: "checkmark")
//                    .foregroundColor(.green)
//                    .transition(.opacity)
//            } else {
//                Button(action: {
//                    isDownloading = true
//                    viewModel.toggleDownload(for: reciter)
//                    
//                    // Simulate download completion
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                        isDownloading = false
//                        showCheckmark = true
//                        
//                        // Hide checkmark after 1 second
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            showCheckmark = false
//                        }
//                    }
//                }) {
//                    Image(systemName: "arrow.down.circle")
//                        .font(.system(size: 24))
//                }
//            }
//        }
//        .padding()
//        .animation(.easeInOut, value: isDownloading)
//        .animation(.easeInOut, value: showCheckmark)
//        
//    }
//}

