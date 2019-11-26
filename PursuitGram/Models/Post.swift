//
//  Post.swift
//  firebae-reddit-clone
//
//  Created by David Rifkin on 11/12/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Post {
    let creatorID: String
    let dateCreated: Date?
    let id :String
    let feedImage:Data
    
    init(creatorID: String, dateCreated: Date? = nil, image:Data) {
        self.creatorID = creatorID
        self.dateCreated = dateCreated
         self.id = UUID().description
        self.feedImage = image
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let userID = dict["creatorID"] as? String,
            let image = dict["feedImage"] as? Data,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
        
        self.creatorID = userID
        self.dateCreated = dateCreated
        self.id = id
        self.feedImage = image
    }
    
    var fieldsDict: [String: Any] {
        return [
            "creatorID": self.creatorID,
            "dateCreated": self.dateCreated,
            "feedImage": self.feedImage
        ]
    }
}
