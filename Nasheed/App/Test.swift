//
//  Test.swift
//  Nasheed
//
//  Created by Abdulboriy on 18/03/25.
//

import SwiftUI


struct Test: View {
    @State private var nasheeds: [Nasheed] = []
    
    var body: some View {
      
        VStack(alignment: .leading, spacing: 20) {
                
                ForEach(nasheeds) { nasheed in
                    if let url = URL(string: nasheed.reciterPhoto) {
                        HStack{
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle()) // Makes it rounded
                            } placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading){
                                Text(nasheed.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(nasheed.reciter)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding()
        .onAppear {
            APIManager.shared.requestNasheedsList { fetchedNasheeds in
                nasheeds = fetchedNasheeds
            }
        }
    }
}

#Preview {
    Test()
}

