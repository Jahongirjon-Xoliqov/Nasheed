//
//  APIManager.swift
//  Nasheed
//
//  Created by Dzakhon on 13/03/25.
//

import Foundation

final class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func requestNasheeds() async -> [Nasheed] {
        FirebaseDataManager.default.fetchNasheeds(completion: <#T##([Nasheed]) -> ()#>)
    }
}
