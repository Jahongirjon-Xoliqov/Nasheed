
import SwiftUI
import SDWebImageSwiftUI

struct PlayingView: View {
    
    @Binding var isMinimized: Bool
    var reciter: NasheedEntity
    @EnvironmentObject var viewModel: RecitersViewModel

    var onMinimize: (NasheedEntity) -> Void
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    @State private var impactFeedback = UIImpactFeedbackGenerator(style: .medium) // ✅ Haptic Feedback
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color(hex: "1E201E") : Color(hex: "F8F3D9")
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                // ✅ Draggable Area
                VStack {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 170, height: 1)
                        .foregroundStyle(.clear.opacity(0.04))
                        .padding(.top, 10)
                }
                .frame(height: 150) // ✅ Ensure it's a tappable area
                .contentShape(Rectangle()) // ✅ Only this part is draggable
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if abs(value.translation.height) > 15 {
                                isDragging = true
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                                    dragOffset = max(value.translation.height, 0)
                                }
                            }
                        }
                        .onEnded { value in
                            let dragThreshold: CGFloat = 150
                            if value.translation.height > dragThreshold {
                                impactFeedback.impactOccurred()
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                    isMinimized = true
                                    onMinimize(reciter)
                                    dismiss()
                                }
                            } else {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    dragOffset = 0
                                    isDragging = false
                                }
                            }
                        }
                )
                
                // ✅ Display Dynamic Image
                WebImage(url: URL(string: reciter.reciterPhoto))
                    .resizable()
                    .indicator(.activity) // Show loading indicator
                    .transition(.fade(duration: 0.3)) // Smooth transition
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 4)
              

                Spacer(minLength: 40)

                // ✅ Display Reciter's Name and Nasheed Title
                VStack(alignment: .center) {
                    Text(reciter.title)
                        .font(.largeTitle)
                        .fontDesign(.serif)

                    Text(reciter.reciter)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 30)
                
                // ✅ Music Progress
                MusicProgressView(reciter: reciter)
                    .padding(.bottom, 50)
            }
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
            .navigationTitle(reciter.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .background(backgroundColor)
        }
        .offset(y: dragOffset) // ✅ Moves smoothly with drag
    }
}

#Preview {
    @Previewable @State var isMinimized: Bool = false

    PlayingView(
        isMinimized: $isMinimized,
        reciter: NasheedEntity(id: "asa", reciter: "Jeck", title: "GO to THE MOON", file: "", reciterPhoto: "", cover: ""),
        onMinimize: { _ in }
    )
    .colorScheme(.light)
}




