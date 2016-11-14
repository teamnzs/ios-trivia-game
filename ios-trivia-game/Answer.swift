//
//  Answer.swift
//  ios-trivia-game
//
//  Created by Zhia Chong on 11/13/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class Answer: NSObject {
    var user_id: String!
    var user_selected_answer_text: String!
    var correct_answer_text: String!
    var question_id: String!
    var timestamp: Date!
    var room_id: String!
    
    init(dictionary: NSDictionary) {
        self.user_id = dictionary["user_id"] as? String
        self.user_selected_answer_text = dictionary["user_selected_answer_text"] as? String
        self.correct_answer_text = dictionary["correct_answer_text"] as? String
        self.question_id = dictionary["question_id"] as? String
        self.timestamp = dictionary["timestamp"] as? Date
        self.room_id = dictionary["room_id"] as? String
    }
    
    func getJson() -> [String: Any] {
        return [
            "user_id": self.user_id as Any,
            "user_selected_answer_text": self.user_selected_answer_text as Any,
            "correct_answer_text": self.correct_answer_text as Any,
            "question_id": self.question_id as Any,
            "timestamp": self.timestamp as Any,
            "room_id": self.room_id as Any
        ]
    }
}
