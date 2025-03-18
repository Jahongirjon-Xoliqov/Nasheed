//
//  APIManager.swift
//  Nasheed
//
//  Created by Dzakhon on 18/03/25.
//

import Foundation

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    func requestNasheedsList(completion: @escaping ([Nasheed]) -> ()) {
        let urlString = "https://getcontent-zonuxl5i3a-uc.a.run.app"
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let json = try JSONDecoder().decode([Nasheed].self, from: data)
                completion(json)
            } catch {
                completion([])
            }
        }
    }
    
}
