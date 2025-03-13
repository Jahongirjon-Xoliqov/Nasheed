//
//  FirebaseDataManager.swift
//  Nasheed
//
//  Created by Dzakhon on 13/03/25.
//

import Firebase
import Foundation

final class FirebaseDataManager {
    
    static let `default` = FirebaseDataManager()
    
    private let db = Firestore.firestore(database: "version1db")
    
    private init() {}
    
    func fetchNasheeds(completion: @escaping ([Nasheed]) -> ()) {
        var nasheeds: [Nasheed] = []
        db.collection("Nasheed").document("4YFaYi9aX2vBuI3VmhEV").getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                let nasheed = Nasheed(
                    title: data["title"] as! String,
                    author:  data["author"] as! String,
                    authorPhoto:  data["authorPhoto"] as! String,
                    coverUrl:  data["coverUrl"] as! String,
                    fileUrl:  data["fileUrl"] as! String
                )
                nasheeds.append(nasheed)
                completion(nasheeds)
            }
        }
    }
    
    func fetchNasheed(byDocumentId docId: String, completion: @escaping (Nasheed) -> ()) {
        db.collection("Nasheed").document(docId).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                let nasheed = Nasheed(
                    title: data["title"] as! String,
                    author:  data["author"] as! String,
                    authorPhoto:  data["authorPhoto"] as! String,
                    coverUrl:  data["coverUrl"] as! String,
                    fileUrl:  data["fileUrl"] as! String
                )
                completion(nasheed)
            }
        }
    }
    
}
