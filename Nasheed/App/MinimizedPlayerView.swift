//
//  MinimizedPlayerView.swift
//  Nasheed
//
//  Created by Abdulboriy on 28/02/25.
//

import Foundation
import SwiftUI


struct MinimizedPlayerView: View {
    var reciter: ReciterData
    var onTap: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var adaptiveBackground: Color {
        colorScheme == .dark ? Color.white : Color.black
    }
    
    var body: some View {
        HStack {
            Image("reciter1")
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(20)
            
            VStack(alignment: .leading) {
                Text(reciter.nasheedName)
                    .font(.headline)
                    .fontDesign(.serif)
                Text(reciter.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                // Play/Pause action
            }) {
                Image(systemName: "play.fill")
                    .imageScale(.large)
                    .foregroundStyle(adaptiveBackground)
                
            }
            
            Button(action: {
                // Next track action
            }) {
                Image(systemName: "forward.fill")
                    .imageScale(.large)
                    .foregroundStyle(adaptiveBackground)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 1)
        .onTapGesture {
            onTap() // Call the function when tapped
        }
    }
}
