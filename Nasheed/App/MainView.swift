import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = RecitersViewModel()
    
    var body: some View {
        MusicPlayerView()
//        TabView {
//            NavigationStack {
//                ReciterView()
//            }
//            .tabItem {
//                Label("Online", systemImage: "headphones")
////                Label("Online", systemImage: "moon.stars")
//            }
//            
//            NavigationStack {
//                LikeView()
//            }
//            .tabItem {
//                Label("Liked", systemImage: "heart.fill")
//            }
//            
//            SavedView()
//                .tabItem {
//                    Label("Saved", systemImage: "bookmark.fill")
//                }
//        }
//        .environmentObject(viewModel) // Pass ViewModel to all views
//        .tint(.red)
        
    }
}

#Preview {
    MainView()
}
