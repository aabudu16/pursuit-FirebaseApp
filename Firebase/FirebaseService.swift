//
//  FirebaseService.swift
//  FavoritePlaces
//
//  Created by Mr Wonderful on 11/21/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FireStoreCollections:String{
    case places
}

class  FireStoreService{
    static let manager = FireStoreService()
    
    private let db = Firestore.firestore()
    
    func createPlace(place: Place, completion: @escaping(Result<(), Error>) -> Void) {
        let fields = place.fieldsDict
        db.collection(FireStoreCollections.places.rawValue).addDocument(data: fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
