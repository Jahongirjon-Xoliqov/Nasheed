import SwiftUI
import SwiftData
struct MainView: View {
    @State private var viewModel: RecitersViewModel?
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            NavigationStack {
                ReciterView()
            }
            .tabItem {
                Label("Online", systemImage: "headphones")
//                Label("Online", systemImage: "moon.stars")
            }
            
            NavigationStack {
                LikeView()
            }
            .tabItem {
                Label("Liked", systemImage: "heart.fill")
            }
            
            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }
        }
        .environmentObject(viewModel ?? RecitersViewModel(modelContext: modelContext)) // ✅ Pass the ViewModel
        .onAppear {
                   if viewModel == nil {
                       viewModel = RecitersViewModel(modelContext: modelContext) // ✅ Initialize safely
                   }
               }
//        .environmentObject(viewModel) // Pass ViewModel to all views
        .tint(.red)
        
    }
}

#Preview {
    MainView()
}
