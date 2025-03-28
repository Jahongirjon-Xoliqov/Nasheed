//import SwiftUI
//
//struct ReciterView: View {
//    @State private var searchText: String = ""
//    @State private var selectedReciter: ReciterData? = nil
//    @State private var isMinimized: Bool = false // Track if the player is minimized
//    @State private var minimizedReciter: ReciterData? = nil // Track the minimized reciter
//    
//    @EnvironmentObject var viewModel: RecitersViewModel
//    @Environment(\.colorScheme) var colorScheme
//    
//    @State var searchMode: SearchMode = .nasheed
//    
//    var backgroundColor: Color {
//        colorScheme == .dark ? Color(red: 0.0, green: 0.4, blue: 0.6) : Color.white
//    }
//    
//    enum SearchMode {
//        case reciter
//        case nasheed
//    }
//
//    var filteredReciters: [ReciterData] {
//        viewModel.reciters.filter { reciter in
//            searchText.isEmpty || (
//                searchMode == .nasheed
//                ? reciter.nasheedName.localizedCaseInsensitiveContains(searchText)
//                : reciter.name.localizedCaseInsensitiveContains(searchText)
//            )
//        }
//    }
//    
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .bottom) {
//                List {
//                    ForEach(filteredReciters.indices, id: \.self) { index in
//                        let reciter = filteredReciters[index]
//                        
//                        Button(action: {
//                            selectedReciter = reciter
//                            isMinimized = false
//                        }) {
//                            ReciterRow(reciter: reciter, viewModel: _viewModel)
//                        }
//                        .listRowSeparator(index == 0 ? .hidden : .visible, edges: .top)
//                        .listRowSeparator(index == filteredReciters.count - 1 ? .hidden : .visible, edges: .bottom)
//                        .listRowSpacing(0)
//                    }
//                }
//                .listStyle(.insetGrouped)
//                .safeAreaInset(edge: .top) { Color.clear.frame(height: 12) }
//                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: isMinimized ? 64 : 10) }
//                .scrollIndicators(.hidden)
//                .searchable(
//                    text: $searchText,
//                    prompt: searchMode == .reciter ? "Search a reciter..." : "Search a nasheed..."
//                )
//            }
//            
//            // MARK: - Minimizing logic
//            if isMinimized, let minimizedReciter = minimizedReciter {
//                GeometryReader { geometry in
//                    MinimizedPlayerView(reciter: minimizedReciter) {
//                        withAnimation {
//                            selectedReciter = minimizedReciter
//                            isMinimized = false
//                        }
//                    }
//                    .position(x: geometry.size.width / 2, y: geometry.size.height - 36)
//                }
//                .frame(height: 0)
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Menu {
//                    Button("Search by Reciter Name") { searchMode = .reciter }
//                    Button("Search by Nasheed Name") { searchMode = .nasheed }
//                } label: {
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                        Text(searchMode == .reciter ? "Reciter" : "Nasheed")
//                    }
//                    .font(.subheadline)
//                }
//            }
//        }
//        .fullScreenCover(item: $selectedReciter) { reciter in
//            PlayingView(
//                isMinimized: $isMinimized,
//                reciter: reciter,
//                onMinimize: { _ in
//                    selectedReciter = nil
//                    minimizedReciter = reciter
//                }
//            )
//            .onDisappear {
//                minimizedReciter = reciter
//            }
//        }
//        .navigationTitle("All Nasheeds")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbarBackground(.cyan.opacity(0.03), for: .navigationBar)
//        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
//    }
//}
//
//#Preview {
//    ReciterView()
//        .environmentObject(RecitersViewModel()) // Ensure ViewModel is provided
//}




//New code
//import SwiftUI

//struct ReciterView: View {
//    @State private var searchText: String = ""
//    @State private var selectedReciter: Nasheed? = nil
//    @State private var isMinimized: Bool = false
//    @State private var minimizedReciter: Nasheed? = nil
//    @State private var searchMode: SearchMode = .nasheed
//
//    @EnvironmentObject var viewModel: RecitersViewModel
//    @Environment(\.colorScheme) var colorScheme
//
//    var backgroundColor: Color {
//        colorScheme == .dark ? Color(red: 0.0, green: 0.4, blue: 0.6) : Color.white
//    }
//
//    enum SearchMode {
//        case reciter
//        case nasheed
//    }
//
//    var filteredReciters: [Nasheed] {
//        viewModel.nasheeds.filter { reciter in
//            searchText.isEmpty || (
//                searchMode == .nasheed
//                ? reciter.title.localizedCaseInsensitiveContains(searchText)
//                : reciter.reciter.localizedCaseInsensitiveContains(searchText)
//            )
//        }
//    }
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .bottom) {
//                List {
//                    ForEach(filteredReciters.indices, id: \.self) { index in
//                        let reciter = filteredReciters[index]
//
//                        Button(action: {
//                            selectedReciter = reciter
//                            isMinimized = false
//                        }) {
//                            ReciterRow(reciter: reciter, viewModel: _viewModel)
//                        }
//                        .listRowSeparator(index == 0 ? .hidden : .visible, edges: .top)
//                        .listRowSeparator(index == filteredReciters.count - 1 ? .hidden : .visible, edges: .bottom)
//                        .listRowSpacing(0)
//                    }
//                }
//                .listStyle(.insetGrouped)
//                .safeAreaInset(edge: .top) { Color.clear.frame(height: 12) }
//                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: isMinimized ? 64 : 10) }
//                .scrollIndicators(.hidden)
//                .searchable(
//                    text: $searchText,
//                    prompt: searchMode == .reciter ? "Search a reciter..." : "Search a nasheed..."
//                )
//            }
//
//            // MARK: - Minimizing logic
//            if isMinimized, let minimizedReciter = minimizedReciter {
//                GeometryReader { geometry in
//                    MinimizedPlayerView(reciter: minimizedReciter) {
//                        withAnimation {
//                            selectedReciter = minimizedReciter
//                            isMinimized = false
//                        }
//                    }
//                    .position(x: geometry.size.width / 2, y: geometry.size.height - 36)
//                }
//                .frame(height: 0)
//            }
//        }
//        .onAppear {
//            Task {
//                await viewModel.fetchNasheeds() // ✅ Fetch real data on appear
//            }
//        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Menu {
//                    Button("Search by Reciter Name") { searchMode = .reciter }
//                    Button("Search by Nasheed Name") { searchMode = .nasheed }
//                } label: {
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                        Text(searchMode == .reciter ? "Reciter" : "Nasheed")
//                    }
//                    .font(.subheadline)
//                }
//            }
//        }
//        .fullScreenCover(item: $selectedReciter) { reciter in
//            PlayingView(
//                isMinimized: $isMinimized,
//                reciter: reciter,
//                onMinimize: { _ in
//                    selectedReciter = nil
//                    minimizedReciter = reciter
//                }
//            )
//            .onDisappear {
//                minimizedReciter = reciter
//            }
//        }
//        .navigationTitle("All Nasheeds")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbarBackground(.cyan.opacity(0.03), for: .navigationBar)
//        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
//    }
//}

//#Preview {
//    ReciterView()
//        .environmentObject(RecitersViewModel()) // Ensure ViewModel is provided
//}


//MARK: - Last edition
import SwiftUI
import SwiftData

struct ReciterView: View {
    @State private var searchText: String = ""
    @State private var selectedReciter: NasheedEntity? = nil
    @State private var isMinimized: Bool = false
    @State private var minimizedReciter: NasheedEntity? = nil
    @State private var searchMode: SearchMode = .nasheed

    @EnvironmentObject var viewModel: RecitersViewModel
    @Environment(\.colorScheme) var colorScheme

    var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.0, green: 0.4, blue: 0.6) : Color.white
    }

    enum SearchMode {
        case reciter
        case nasheed
    }

    var filteredReciters: [NasheedEntity] {
        viewModel.nasheeds.filter { reciter in
            searchText.isEmpty || (
                searchMode == .nasheed
                ? reciter.title.localizedCaseInsensitiveContains(searchText)
                : reciter.reciter.localizedCaseInsensitiveContains(searchText)
            )
        }
    }

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
                            ReciterRow(reciter: reciter, viewModel: _viewModel) // Make sure ReciterRow supports NasheedEntity
                        }
                        .listRowSeparator(index == 0 ? .hidden : .visible, edges: .top)
                        .listRowSeparator(index == filteredReciters.count - 1 ? .hidden : .visible, edges: .bottom)
                        .listRowSpacing(0)
                    }
                }
                .listStyle(.insetGrouped)
                .safeAreaInset(edge: .top) { Color.clear.frame(height: 12) }
                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: isMinimized ? 64 : 10) }
                .scrollIndicators(.hidden)
                .searchable(
                    text: $searchText,
                    prompt: searchMode == .reciter ? "Search a reciter..." : "Search a nasheed..."
                )
            }

            // MARK: - Minimizing logic
            if isMinimized, let minimizedReciter = minimizedReciter {
                GeometryReader { geometry in
                    MinimizedPlayerView(reciter: minimizedReciter) { // Make sure MinimizedPlayerView supports NasheedEntity
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
        .onAppear {
            Task {
                await viewModel.fetchNasheeds() // ✅ Fetch real data on appear
            }
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
        .fullScreenCover(item: $selectedReciter) { reciter in
            PlayingView(
                isMinimized: $isMinimized,
                reciter: reciter, // Now passing NasheedEntity
                onMinimize: { _ in
                    selectedReciter = nil
                    minimizedReciter = reciter
                }
            )
            .onDisappear {
                minimizedReciter = reciter
            }
        }
        .navigationTitle("All Nasheeds")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.cyan.opacity(0.03), for: .navigationBar)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
    }
}

#Preview {
    let container = try! ModelContainer(for: NasheedEntity.self)
    let viewModel = RecitersViewModel(modelContext: container.mainContext)

    ReciterView()
        .environmentObject(viewModel)
}


