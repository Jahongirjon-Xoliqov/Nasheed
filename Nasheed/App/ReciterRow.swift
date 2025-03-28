import SwiftUI
import SDWebImageSwiftUI

struct ReciterRow: View {
    @Environment(\.colorScheme) var colorScheme

    var textColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }

    var reciter: NasheedEntity
    @EnvironmentObject var viewModel: RecitersViewModel

    @State private var isDownloading = false
    @State private var showCheckmark = false
    @State private var completedParts: Int = 0

    let totalParts: Int = 3

    var body: some View {
        HStack {
            // Load image from reciterPhoto
            WebImage(url: URL(string: reciter.reciterPhoto))
                .resizable()
                .indicator(.activity) // Show loading indicator
                .transition(.fade(duration: 0.3)) // Smooth transition
                .scaledToFill()
                .frame(width: 46, height: 46)
                .clipShape(Circle()) // Ensures a circular image
                .overlay(Circle().stroke(Color.gray, lineWidth: 1)) // Add border
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(reciter.title)
                    .font(.title3)
                    .fontDesign(.serif)
                    .foregroundColor(textColor)

                Text(reciter.reciter)
                    .font(.subheadline)
                    .fontDesign(.serif)
                    .foregroundColor(textColor.opacity(0.7))
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
                            .foregroundColor(.red)
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
    }

    // Download logic
    func startDownload() {
        isDownloading = true
        viewModel.toggleDownload(for: reciter)
        completedParts = 0

        for i in 1...totalParts {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                withAnimation {
                    completedParts = i
                }
            }
        }

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

// Custom progress style
struct QuarterCircleProgressViewStyle: ProgressViewStyle {
    let parts: Int

    func makeBody(configuration: Configuration) -> some View {
        let completedSteps = Int(configuration.fractionCompleted! * Double(parts))
        let partSize = 1 / CGFloat(parts)

        return ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(parts))
                .stroke(Color.gray.opacity(0.3), lineWidth: 2.4)
                .rotationEffect(.degrees(-90))

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
    ReciterRow(reciter: NasheedEntity(id: "d", reciter: "Abdulaziz", title: "Go to war", file: "", reciterPhoto: "https://firebasestorage.googleapis.com:443/v0/b/nasheed-65ef6.firebasestorage.app/o/CoverImages%2FstandartCover.jpeg?alt=media&token=6ade49be-c174-415b-b1db-b0ddbf284895", cover: ""))
}
