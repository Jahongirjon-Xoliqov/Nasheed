//
//  JSONConverter.swift
//  Nasheed
//
//  Created by Dzakhon on 12/03/25.
//

import Foundation


final class JSONConverter {
    func getData() -> [Nasheed] {
        guard let path = Bundle.main.path(forResource: "JSONData", ofType: "json") else { return [] }

        let url = URL(fileURLWithPath: path)

        do {

            let data = try Data(contentsOf: url)

            let json = try JSONDecoder().decode([Nasheed].self, from: data)
            
            return json

        } catch {

            print(error)
        }
        
        return []
    }
}


struct Nasheed: Decodable {
    var title: String
    var author: String
    var authorPhoto: String
    var coverUrl: String
    var fileUrl: String
}
