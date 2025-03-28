//
//  NasheedEntity.swift
//  Nasheed
//
//  Created by Abdulboriy on 28/03/25.
//

import Foundation
import SwiftData

@Model
class NasheedEntity {
    @Attribute(.unique) var id: String
    var reciter: String
    var title: String
    var file: String
    var reciterPhoto: String
    var cover: String
    var isDownloaded: Bool
    var isLiked: Bool

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

