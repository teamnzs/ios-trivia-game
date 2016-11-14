//
//  Question.swift
//  ios-trivia-game
//
//  Created by Zhia Chong on 11/13/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class Question: NSObject {
    var id: String!
    var room_id: String!
    var question_text: String!
    var answer_text: String!
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String
        self.room_id = dictionary["room_id"] as? String
        self.question_text = dictionary["question_text"] as? String
        self.answer_text = dictionary["answer_text"] as? String
    }
    
    func getJson() -> [String: Any] {
        return [
            "id": self.id,
            "room_id": self.room_id,
            "question_text": self.question_text,
            "answer_text": self.answer_text
        ]
    }
}
