//  ReciterView.swift
//  Nasheed
//
//  Created by Abdulboriy on 19/02/25.
//

import SwiftUI
struct ReciterView: View {
    
    var reciter: ReciterData? = nil
    
    @State private var searchText: String = ""
    
    @State private var selectedReciter: ReciterData? = nil
    @State private var isMinimized: Bool = false // Track if the player is minimized
    @State private var minimizedReciter: ReciterData? = nil // Track the minimized reciter
    
    @EnvironmentObject var viewModel: RecitersViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State var searchMode: SearchMode = .nasheed
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.0, green: 0.4, blue: 0.6) : Color.white
    }
    
    
    var filteredReciters: [ReciterData] {
        if searchText.isEmpty {
            return viewModel.reciters
        } else {
            return viewModel.reciters.filter {
                searchMode == .nasheed ? $0.nasheedName.localizedCaseInsensitiveContains(searchText) : $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    enum SearchMode {
        case reciter
        case nasheed
    }
    
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
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
//                List{
//                    ForEach(filteredReciters, id: \.id) { reciter in
//                        Button(action: {
//                            selectedReciter = reciter
//                            isMinimized = false
//                            
//                        }) {
//                            ReciterRow(reciter: reciter, viewModel: _viewModel)
//                        }
//                        .listRowSeparator(.visible)
//                        .listRowSpacing(0)
//                    }
//                }
                .listStyle(.insetGrouped)
                .safeAreaInset(edge: .top) {
                    Color.clear
                        .frame(height: 12)
                }
                
                .safeAreaInset(edge: .bottom) {
                    Color.clear
                        .frame(height: isMinimized ? 64 : 10)
                }
                .scrollIndicators(.hidden)
                .searchable(text: $searchText, 
                            prompt: searchMode == .reciter ? "Search a reciter..." :  "Search a nasheed...")
                
                
                
                
                
            }
            
            
            //MARK: - Minimizing logic
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
        
        .fullScreenCover(item: $selectedReciter) { reciter in
            PlayingView(
                isMinimized: $isMinimized,
                reciter: reciter,
                onMinimize: { _ in
                    selectedReciter = nil // ✅ Dismiss the full-screen view
                    minimizedReciter = reciter } // ✅ Pass a real closure
            )
            .onDisappear {
                minimizedReciter = reciter
            }
        }
        .navigationTitle(Text("All Nasheeds"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.cyan.opacity(0.03), for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        //            .background(backgroundColor) // Extra layer to cover the full screen
        
        
    }
    
}


#Preview {
    
    ReciterView(reciter: ReciterData(name: "Abdulboriy", nasheedName: "Mening Nashidim"))
}
