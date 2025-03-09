//
//  ReciterData.swift
//  Nasheed
//
//  Created by Abdulboriy on 19/02/25.
//

import Foundation
import SwiftUICore
class ReciterData: Identifiable {
    var name: String
    var nasheedName: String
    var picture: Image?
    var isDownloaded: Bool = false
    var id: UUID = UUID()
    var isLiked: Bool = false
    
  init (name: String, nasheedName: String, picture: Image? = nil) {
        self.name = name
        self.nasheedName = nasheedName
        self.picture = picture
      
    }
}
