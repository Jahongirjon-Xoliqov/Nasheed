//
//  SavedView.swift
//  Nasheed
//
//  Created by Abdulboriy on 19/02/25.
//


//MARK: - Old try
//    let reciter: ReciterData
//    @ObservedObject var viewModel: RecitersViewModel
//    @State private var isDownloading = false
//    @State private var showCheckmark = false
//    @State private var completedParts: Int = 0
//    @State private var isDownloaded = false
//
//    let totalParts: Int = 3 // Change this dynamically based on file size
//
//    var body: some View {
//        HStack {
//            Image("nasheed2")
//                .resizable()
//                .frame(width: 46, height: 46)
//                .cornerRadius(36)
//                .padding(.trailing, 10)
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
//            if !isDownloaded {
//                if isDownloading {
//                    ProgressView(value: Double(completedParts), total: Double(totalParts))
//                        .progressViewStyle(QuarterCircleProgressViewStyle(parts: totalParts))
//                        .frame(width: 24, height: 24)
//                        .transition(.opacity)
//                } else if showCheckmark {
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.green)
//                        .transition(.opacity)
//                } else {
//                    Button(action: startDownload) {
//                        Image(systemName: "arrow.down.circle")
//                            .font(.system(size: 24))
//                    }
//                }
//            }
//        }
//        .padding()
//        .animation(.easeInOut, value: isDownloading)
//        .animation(.easeInOut, value: showCheckmark)
//    }
//
//    func startDownload() {
//        isDownloading = true
//        viewModel.toggleDownload(for: reciter)
//        completedParts = 0
//
//        // Step-by-step update
//        for i in 1...totalParts {
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
//                withAnimation {
//                    completedParts = i
//                }
//            }
//        }
//
//        // After all parts are completed
//        DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalParts)) {
//            isDownloading = false
//            showCheckmark = true
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                showCheckmark = false
//                isDownloaded = true
//            }
//        }
//    }
//}
//
//
//
//
//
//struct QuarterCircleProgressViewStyle: ProgressViewStyle {
//    let parts: Int // Number of steps
//
//    func makeBody(configuration: Configuration) -> some View {
//        let completedSteps = Int(configuration.fractionCompleted! * Double(parts))
//        let partSize = 1 / CGFloat(parts) // Each part fills an equal section
//
//        return ZStack {
////             Background track
//            Circle()
//                .trim(from: 0, to: CGFloat(parts))
//                .stroke(Color.gray.opacity(0.3), lineWidth: 2.4)
//                .rotationEffect(.degrees(-90))
//
//            // Draw completed steps one by one
//            ForEach(0..<completedSteps, id: \.self) { i in
//                Circle()
//                    .trim(from: 0 + (partSize * CGFloat(i)),
//                          to: 0 + (partSize * CGFloat(i + 1)))
//                    .stroke(Color.blue, lineWidth: 2.4)
//                    .rotationEffect(.degrees(-90))
//                    .animation(.easeInOut(duration: 0.3), value: completedSteps)
//            }
//        }
//        .frame(width: 24, height: 24)
//    }
//}



//    @ObservedObject var viewModel: RecitersViewModel
import SwiftUI

struct SavedView: View {
    
    @State private var searchText: String = ""
    
    @EnvironmentObject var viewModel: RecitersViewModel

    @State private var selectedReciter: ReciterData? = nil
    @State private var isMinimized: Bool = false // Track if the player is minimized
    @State private var minimizedReciter: ReciterData? = nil
    
    @State private var searchMode: SearchMode = .nasheed

    enum SearchMode {
        case reciter
        case nasheed
    }
    
    @Environment(\.colorScheme) var colorScheme

    var adaptiveBackground: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var filteredReciters: [ReciterData] {
        if searchText.isEmpty {
            return viewModel.savedReciters
        } else {
            return viewModel.savedReciters.filter {
                searchMode == .nasheed ? $0.nasheedName.localizedCaseInsensitiveContains(searchText) : $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            if viewModel.savedReciters.isEmpty {
                ContentUnavailableView {
                    Label("No Saved Nasheeds Yet.", systemImage: "bookmark.slash.fill")
                } description: {
                    Text("Download a nasheed to see it here.")
                }
            } else {
                
                ZStack(alignment: .bottom) {
                    List {
                        ForEach(filteredReciters.indices, id: \.self) { index in
                            let reciter = filteredReciters[index]
                            
                            Button(action: {
                                selectedReciter = reciter
                                isMinimized = false
                            }) {
                                ReciterRow(reciter: reciter, viewModel: _viewModel)
                            }
                            .listRowSeparator(index == 0 ? .hidden : .visible, edges: .top) // Hide only the top separator of the first row
                            .listRowSeparator(index == filteredReciters.count - 1 ? .hidden : .visible, edges: .bottom) // Hide only the bottom separator of the last row
                            .listRowSpacing(0)
                        }
                    }
                    
                    .scrollIndicators(.hidden)
                    .listStyle(.insetGrouped)
                    .scrollIndicators(.hidden)
                    .safeAreaInset(edge: .top) {
                        Color.clear
                            .frame(height: 12)
                    }
                    
                    .safeAreaInset(edge: .bottom) {
                        Color.clear
                            .frame(height: isMinimized ? 64 : 10)
                    }
                    .searchable(text: $searchText, prompt: searchMode == .reciter ? "Search a reciter..." :  "Search a nasheed...")
                    
                    
                    
                    if isMinimized, let minimizedReciter = minimizedReciter {
                        GeometryReader { geometry in
                            MinimizedPlayerView(reciter: minimizedReciter) {
                                withAnimation {
                                    selectedReciter = minimizedReciter // ✅ Reopens full-screen player
                                    isMinimized = false
                                }
                            }
                            .position(x: geometry.size.width / 2, y: geometry.size.height - 36) // ✅ Sticks to bottom
                        }
                        .frame(height: 0) // ✅ Prevents affecting layout
                    }
                }
                .fullScreenCover(item: $selectedReciter) { reciter in
                    PlayingView(
                        isMinimized: $isMinimized,
                        reciter: reciter,
                        onMinimize: { _ in
                            minimizedReciter = reciter } // ✅ Pass a real closure
                    )
                    .onDisappear {
                        minimizedReciter = reciter
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button("Search by Reciter Name") {
                                searchMode = .reciter // ✅ Change search mode
                            }
                            Button("Search by Nasheed Name") {
                                searchMode = .nasheed // ✅ Change search mode
                            }
                        } label: {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text(searchMode == .reciter ? "Reciter" : "Nasheed") // ✅ Show current mode
                            }
                            .font(.subheadline)
                        }
                    }
                }
                .navigationTitle("Saved Nasheeds")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.cyan.opacity(0.03), for: .navigationBar)
                .toolbarBackgroundVisibility(.visible, for: .navigationBar)
                
            }
        }
    }
}
      



#Preview {
    SavedView()
}
