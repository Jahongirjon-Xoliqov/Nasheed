//
//  ReciterListView.swift
//  Nasheed
//
//  Created by Abdulboriy on 25/03/25.
//

import Foundation
import SwiftUI

struct ReciterListView: View {
    let title: String
    let emptyMessage: String
    let emptyIcon: String
    let emptyDescription: String
    let reciters: [NasheedEntity]

    @State private var searchText: String = ""
    @EnvironmentObject var viewModel: RecitersViewModel
    @State private var selectedReciter: NasheedEntity? = nil
    @State private var isMinimized: Bool = false
    @State private var minimizedReciter: NasheedEntity? = nil
    @State private var searchMode: SearchMode = .nasheed

    enum SearchMode {
        case reciter
        case nasheed
    }

    var filteredReciters: [NasheedEntity] {
        if searchText.isEmpty {
            return reciters
        } else {
            return reciters.filter {
                searchMode == .nasheed
                ? $0.title.localizedCaseInsensitiveContains(searchText)
                : $0.reciter.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            if reciters.isEmpty {
                ContentUnavailableView {
                    Label(emptyMessage, systemImage: emptyIcon)
                } description: {
                    Text(emptyDescription)
                }
            } else {
                ZStack(alignment: .bottom) {
                    List {
                        ForEach(Array(filteredReciters).indices, id: \.self) { index in
                            let reciter = filteredReciters[index]

                            Button(action: {
                                selectedReciter = reciter
                                isMinimized = false
                            }) {
                                ReciterRow(reciter: reciter, viewModel: _viewModel)
                            }
                            .listRowSeparator(index == 0 ? .hidden : .visible, edges: .top)
                            .listRowSeparator(index == filteredReciters.count - 1 ? .hidden : .visible, edges: .bottom)
                            .listRowSpacing(0)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .scrollIndicators(.hidden)
                    .safeAreaInset(edge: .top) { Color.clear.frame(height: 12) }
                    .safeAreaInset(edge: .bottom) { Color.clear.frame(height: isMinimized ? 64 : 10) }
                    .searchable(text: $searchText, prompt: searchMode == .reciter ? "Search a reciter..." : "Search a nasheed...")

                    if isMinimized, let minimizedReciter = minimizedReciter {
                        GeometryReader { geometry in
                            MinimizedPlayerView(reciter: minimizedReciter) {
                                withAnimation {
                                    selectedReciter = minimizedReciter
                                    isMinimized = false
                                }
                            }
                            .position(x: geometry.size.width / 2, y: geometry.size.height - 36)
                        }
                        .frame(height: 0)
                    }
                }
                .fullScreenCover(item: $selectedReciter) { reciter in
                    PlayingView(
                        isMinimized: $isMinimized,
                        reciter: reciter,
                        onMinimize: { _ in minimizedReciter = reciter }
                    )
                    .onDisappear { minimizedReciter = reciter }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button("Search by Reciter Name") { searchMode = .reciter }
                            Button("Search by Nasheed Name") { searchMode = .nasheed }
                        } label: {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text(searchMode == .reciter ? "Reciter" : "Nasheed")
                            }
                            .font(.subheadline)
                        }
                    }
                }
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.cyan.opacity(0.03), for: .navigationBar)
                .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            }
        }
    }
}
