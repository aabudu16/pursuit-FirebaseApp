//
//  FirebaseService.swift
//  FavoritePlaces
//
//  Created by Mr Wonderful on 11/21/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FireStoreCollections: String {
    case users
    case posts
    case comments
}

enum SortingCriteria: String {
    case fromNewestToOldest = "dateCreated"
    var shouldSortDescending: Bool {
        switch self {
        case .fromNewestToOldest:
            return true
        }
    }
}

class FirestoreService {
    static let manager = FirestoreService()
    
    private let db = Firestore.firestore()
    
    //MARK: AppUsers
    func createAppUser(user: UserProfile, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = user.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    
    func updateCurrentUser(userName: String? = nil, photoURL: URL? = nil, completion: @escaping (Result<(), Error>) -> ()){
        guard let userId = FirebaseAuthService.manager.currentUser?.uid else {
            //MARK: TODO - handle can't get current user
            return
        }
        var updateFields = [String:Any]()
        
        if let user = userName {
            updateFields["userName"] = user
        }
        
        if let photo = photoURL {
            updateFields["photoURL"] = photo.absoluteString
        }
        
        db.collection(FireStoreCollections.users.rawValue).document(userId).updateData(updateFields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    }
    
    func getAllUsers(completion: @escaping (Result<[UserProfile], Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = snapshot?.documents.compactMap({ (snapshot) -> UserProfile? in
                    let userID = snapshot.documentID
                    let user = UserProfile(from: snapshot.data(), id: userID)
                    return user
                })
                completion(.success(users ?? []))
            }
        }
    }
    
    //MARK: Posts
    func createPost(post: Post, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = post.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.posts.rawValue).addDocument(data: fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
     func getAllPosts(sortingCriteria: SortingCriteria? = nil, completion: @escaping (Result<[Post], Error>) -> ()) {
            let completionHandler: FIRQuerySnapshotBlock = {(snapshot, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
                        let postID = snapshot.documentID
                        let post = Post(from: snapshot.data(), id: postID)
                        return post
                    })
                    completion(.success(posts ?? []))
                }
            }
            
            //type: Collection Reference
            let collection = db.collection(FireStoreCollections.posts.rawValue)
            //If i want to sort, or even to filter my collection, it's going to work with an instance of a different type - FIRQuery
            //collection + sort/filter settings.getDocuments
            if let sortingCriteria = sortingCriteria {
                let query = collection.order(by:sortingCriteria.rawValue, descending: sortingCriteria.shouldSortDescending)
                query.getDocuments(completion: completionHandler)
            } else {
                collection.getDocuments(completion: completionHandler)
            }
        }


    func getPosts(forUserID: String, completion: @escaping (Result<[Post], Error>) -> ()) {
        db.collection(FireStoreCollections.posts.rawValue).whereField("creatorID", isEqualTo: forUserID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
                    let postID = snapshot.documentID
                    let post = Post(from: snapshot.data(), id: postID)
                    return post
                })
                completion(.success(posts ?? []))
            }
        }
        
    }
    
    private init () {}
}
