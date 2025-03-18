//
//  Nasheed.swift
//  Nasheed
//
//  Created by Dzakhon on 18/03/25.
//

import Foundation

//struct Nasheed: Codable, Identifiable {
//    var title: String
//    var reciter: String
//    var reciterPhoto: String
//    var cover: String
//    var file: String
//    var id: UUID
//}

struct Nasheed: Codable, Identifiable {
    var id: String  // Changed from UUID to String ✅
    var title: String
    var reciter: String
    var reciterPhoto: String
    var cover: String
    var file: String
}

