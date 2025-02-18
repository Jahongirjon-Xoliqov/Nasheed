//
//  MainView.swift
//  Nasheed
//
//  Created by Dzakhon on 18/02/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Assalomu alaykum")
            HStack(spacing: 0) {
                Text("Nasheed")
                    .bold()
                Text("ga hush kelibsiz")
            }
        }
    }
}

#Preview {
    MainView()
}
