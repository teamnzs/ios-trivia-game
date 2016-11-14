//
//  TriviaCategory.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/12/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

//{
//    "id": 8118,
//    "title": "gee, you smell terrific",
//    "created_at": "2014-02-11T23:26:15.255Z",
//    "updated_at": "2014-02-11T23:26:15.255Z",
//    "clues_count": 5
//}

class TriviaCategory: NSObject {
    var id: Int?
    var title: String?
    var count: Int?
    
    init(dictionary: NSDictionary) {
        self.id = (dictionary["id"] as? Int) ?? 0
        self.title = (dictionary["title"] as? String) ?? ""
        self.count = (dictionary["clues_count"] as? Int) ?? 0
    }
    
    func getJson() -> [String: Any] {
        return [
            "id": self.id as Any,
            "title": self.title as Any,
            "clues_count": self.count as Any
        ]
    }
}
