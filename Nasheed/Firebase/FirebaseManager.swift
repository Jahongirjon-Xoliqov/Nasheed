//
//  FirebaseManager.swift
//  Nasheed
//
//  Created by Dzakhon on 18/03/25.
//
import Foundation
import FirebaseStorage

final class FirebaseManager {
    static let shared = FirebaseManager()
    private let storage = Storage.storage()
    private init() {}
    func getPublicUrl(from firebaseInternalUrl: String, completion: @escaping (String) -> ()){
        let fileFirebaseUrl = storage.reference().child(firebaseInternalUrl.extractPath())
        fileFirebaseUrl.downloadURL { url, error in
            if let url {
                completion(url.absoluteString)
            } else {
                completion("")
            }
        }
        
    }
}

fileprivate extension String {
    func extractPath() -> String {
        self.replacingOccurrences(of: "gs://nasheed-65ef6.firebasestorage.app/", with: "")
    }
}
