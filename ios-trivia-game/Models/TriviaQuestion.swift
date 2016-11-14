//
//  TriviaQuestion.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/12/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

//{
//    "id": 63288,
//    "answer": "Aramis",
//    "question": "This classic men's cologne shares its name with a musketeer",
//    "value": 600,
//    "airdate": "2005-06-22T12:00:00.000Z",
//    "created_at": "2014-02-11T23:26:15.694Z",
//    "updated_at": "2014-02-11T23:26:15.694Z",
//    "category_id": 8118,
//    "game_id": null,
//    "invalid_count": null,
//    "category": {
//        "id": 8118,
//        "title": "gee, you smell terrific",
//        "created_at": "2014-02-11T23:26:15.255Z",
//        "updated_at": "2014-02-11T23:26:15.255Z",
//        "clues_count": 5
//    }
//}

class TriviaQuestion: NSObject {
    var id: Int?
    var answer: String?
    var question: String?
    var value: Int?
    var category: TriviaCategory?
    
    init(dictionary: NSDictionary) {
        self.id = (dictionary["id"] as? Int) ?? 0
        self.answer = (dictionary["answer"] as? String) ?? ""
        self.question = (dictionary["question"] as? String) ?? ""
        self.value = (dictionary["value"] as? Int) ?? 0
        self.category = TriviaCategory(dictionary: (dictionary["category"] as? NSDictionary)!)
    }
    
    func getJson() -> [String: Any] {
        return [
            "id": self.id as Any,
            "question_text": self.question as Any,
            "answer_text": self.answer as Any,
            "category": self.category?.getJson() as Any,
            "value": self.value as Any
        ]
    }
}
