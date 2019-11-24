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
    let title: String
    let creatorID: String
    let dateCreated: Date?
    let feedImage:Data
    
    init(title: String, body: String, creatorID: String, dateCreated: Date? = nil, image:Data) {
        self.title = title
        self.creatorID = creatorID
        self.dateCreated = dateCreated
        self.feedImage = image
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let title = dict["title"] as? String,
            let userID = dict["creatorID"] as? String,
            let image = dict["feedImage"] as? Data,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
        
        self.title = title
        self.creatorID = userID
        self.dateCreated = dateCreated
        self.feedImage = image
    }
    
    var fieldsDict: [String: Any] {
        return [
            "title": self.title,
            "creatorID": self.creatorID,
            "dateCreated": self.feedImage
        ]
    }
}
