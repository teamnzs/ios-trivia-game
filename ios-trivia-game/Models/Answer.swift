//
//  Answer.swift
//  ios-trivia-game
//
//  Created by Zhia Chong on 11/13/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class Answer: NSObject {
    var userId: String!
    var answerText: String!
    var questionId: Int!
    var timestamp: String?
    var roomId: String!
    
    init(dictionary: NSDictionary) {
        self.userId = dictionary["user_id"] as? String
        self.answerText = dictionary["answer"] as? String
        self.questionId = dictionary["question_id"] as? Int
        self.timestamp = dictionary["timestamp"] as? String
        self.roomId = dictionary["room_id"] as? String
    }
    
    init(userId: String, answerText: String, questionId: Int, roomId: String) {
        self.userId = userId
        self.answerText = answerText
        self.questionId = questionId
        self.roomId = roomId
        self.timestamp = String(describing: NSDate())
    }
    
    func getJson() -> [String: Any] {
        return [
            "user_id": self.userId as Any,
            "answer": self.answerText as Any,
            "question_id": self.questionId as Any,
            "timestamp": self.timestamp as Any,
            "room_id": self.roomId as Any
        ]
    }
}
