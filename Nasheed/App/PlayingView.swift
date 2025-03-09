//  PlayingView.swift
//  Nasheed
//
//  Created by Abdulboriy on 21/02/25.
//
//---------
//import SwiftUI


// Draging effect incompleted!!!
import SwiftUI

struct PlayingView: View {
    @Binding var isMinimized: Bool
    var reciter: ReciterData
    var onMinimize: (ReciterData) -> Void
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: RecitersViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var impactFeedback = UIImpactFeedbackGenerator(style: .medium) // ✅ Haptic Feedback
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color(hex: "1E201E") : Color(hex: "F8F3D9")
    }

    var body: some View {
        NavigationStack {
            VStack {
                // ✅ DRAGGABLE AREA (NAVIGATION STACK)
                VStack {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 170, height: 1)
                        .foregroundStyle(.clear.opacity(0.04))
                        .padding(.top, 10)
                }
//                .background(.ultraThinMaterial)
                .frame(height: 150) // ✅ Ensure it's a tappable area
                .contentShape(Rectangle()) // ✅ Only this part is draggable
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if abs(value.translation.height) > 15 { // ✅ Ignore micro movements
                                isDragging = true
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                    dragOffset = max(value.translation.height, 0) // ✅ Smooth drag
                                }
                            }
                        }
                        .onEnded { value in
                            let dragThreshold: CGFloat = 150
                            if value.translation.height > dragThreshold { // ✅ Dismiss condition
                                impactFeedback.impactOccurred() // ✅ Haptic feedback
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    isMinimized = true
                                    onMinimize(reciter)
                                    dismiss()
                                }
                            } else {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    dragOffset = 0 // ✅ Snap back
                                    isDragging = false
                                }
                            }
                        }
                )

                
                Image("nasheed2")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 4)

                Spacer(minLength: 40)

                VStack(alignment: .center) {
                    Text(reciter.nasheedName)
                        .font(.largeTitle)
                        .fontDesign(.serif)

                    Text(reciter.name)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)

                MusicProgressView(reciter: reciter)
                    .padding(.bottom, 50)

                
            }
            
            //MARK: - Toolbar
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isMinimized = true
                            onMinimize(reciter)
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .imageScale(.medium)
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                            .tint(.red)
                    }
                }
            }
            .navigationTitle(reciter.nasheedName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .background(backgroundColor)
        }
        .offset(y: dragOffset) // ✅ Moves smoothly with drag
    }
}




//---------

//import SwiftUI


//struct PlayingView: View {
//    @Binding var isMinimized: Bool // Control minimization from parent
//    var reciter: ReciterData
//    var onMinimize: (ReciterData) -> Void // Callback function
//    @Environment(\.dismiss) private var dismiss // 👈 Add this
//    @EnvironmentObject var viewModel: RecitersViewModel
//    @Environment(\.colorScheme) var colorScheme
//
//    var backgroundColor: Color {
//        colorScheme == .dark ? Color(hex: "1E201E") /* Hex #243642*/ : Color(hex: "FFF0D1")
//    }
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//
//                Spacer()
//
//                Image("nasheed2")
//                    .resizable()
//                    .frame(width: 300, height: 300)
//                    .clipShape(.rect(cornerRadius: 20))
//                    .shadow(radius: 4)
//
//
//                Spacer()
//
//                VStack(alignment: .center) {
//                    Text(reciter.nasheedName)
//                        .font(.largeTitle)
//                        .fontDesign(.serif)
//
//                    Text(reciter.name)
//                        .font(.headline)
//                        .foregroundColor(.secondary)
//                }
//                .padding(.bottom, 50)
//
//                MusicProgressView(reciter: reciter)
//
//                Spacer()
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0)) {
//                            isMinimized = true
//                            onMinimize(reciter) // ✅ Update minimizedReciter in parent
//                            dismiss() // ✅ Dismiss full-screen cover
//                        }
//                    } label: {
//                        Image(systemName: "chevron.down")
//                            .imageScale(.medium)
//                            .font(.system(size: 25))
//                            .fontWeight(.semibold)
//                            .tint(.red)
//                    }
//                }
//            }
//            .navigationTitle(reciter.nasheedName)
//            .navigationBarTitleDisplayMode(.inline)
////            .toolbarBackground(.cyan.opacity(0.05), for: .navigationBar)//set for top part colors
//            .toolbarBackgroundVisibility(.visible, for: .navigationBar)//make top part visible
//            .background(backgroundColor)
//        }
//
//    }
//}


#Preview {
    @Previewable @State var isMinimized: Bool = false
    
    PlayingView(
        isMinimized: $isMinimized,
        reciter: ReciterData(name: "Abdulboriy", nasheedName: "Kuntu maitan"),
        onMinimize: { _ in } // Provide an empty closure for preview
    )
    .colorScheme(.light)
}



