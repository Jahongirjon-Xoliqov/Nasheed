//
//  LikeView.swift
//  Nasheed
//
//  Created by Abdulboriy on 19/02/25.
//

import SwiftUI

struct LikeView: View {
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
            return viewModel.likedReciters
        } else {
            return viewModel.likedReciters.filter {
                searchMode == .nasheed ? $0.nasheedName.localizedCaseInsensitiveContains(searchText) : $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    
    var body: some View {
        NavigationStack {
            if viewModel.likedReciters.isEmpty {
                ContentUnavailableView {
                    Label("No liked nasheeds yet.", systemImage: "heart.slash.fill")
                } description: {
                    Text("Like a nasheed to see it here.")
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
                
                .navigationTitle("My Favorites")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.cyan.opacity(0.03), for: .navigationBar)
                .toolbarBackgroundVisibility(.visible, for: .navigationBar)
                
            }
        }
       
    }
}





#Preview {
    LikeView()
}



