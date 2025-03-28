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

///New-----
//struct Nasheed: Codable, Identifiable {
//        var id: String  // Keep the ID from API
//        var title: String
//        var reciter: String
//        var reciterPhoto: String
//        var file: String
//        var cover: String?
//
//        // Add local properties
//        var isDownloaded: Bool = false
//        var isLiked: Bool = false
//    
//    init(id: String, title: String, reciter: String, reciterPhoto: String, file: String, cover: String? = nil) {
//        self.id = id
//        self.title = title
//        self.reciter = reciter
//        self.reciterPhoto = reciterPhoto
//        self.file = file
//        self.cover = cover
//        
//    }
//}

struct Nasheed: Identifiable, Codable {
    let id: String
    let reciter: String
    let title: String
    let file: String
    let reciterPhoto: String
    let cover: String

    var isDownloaded: Bool = false
    var isLiked: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, reciter, title, file, reciterPhoto, cover
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        reciter = try container.decode(String.self, forKey: .reciter)
        title = try container.decode(String.self, forKey: .title)
        file = try container.decode(String.self, forKey: .file)
        reciterPhoto = try container.decode(String.self, forKey: .reciterPhoto)
        cover = try container.decode(String.self, forKey: .cover)

        // Provide default values
        isDownloaded = false
        isLiked = false
    }

    init(id: String, reciter: String, title: String, file: String, reciterPhoto: String, cover: String, isDownloaded: Bool = false, isLiked: Bool = false) {
        self.id = id
        self.reciter = reciter
        self.title = title
        self.file = file
        self.reciterPhoto = reciterPhoto
        self.cover = cover
        self.isDownloaded = isDownloaded
        self.isLiked = isLiked
    }
}


