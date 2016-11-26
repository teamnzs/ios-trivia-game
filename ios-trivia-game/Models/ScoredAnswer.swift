//
//  Response.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/23/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class ScoredAnswer: Answer {
    var score: Int!
    
    override init(dictionary: NSDictionary) {
        self.score = dictionary["score"] as? Int
        super.init(dictionary: dictionary)
    }
    
    init(score: Int, userId: String, answerText: String, questionId: Int, roomId: String) {
        self.score = score
        super.init(userId: userId, answerText: answerText, questionId: questionId, roomId: roomId)
    }
    
    init(score: Int, answer: Answer) {
        self.score = score
        super.init(userId: answer.userId, answerText: answer.answerText, questionId: answer.questionId, roomId: answer.roomId)
    }
    
    override func getJson() -> [String: Any] {
        return [
            "score": self.score as Any,
            "user_id": self.userId as Any,
            "answer": self.answerText as Any,
            "question_id": self.questionId as Any,
            "timestamp": self.timestamp as Any,
            "room_id": self.roomId as Any
        ]
    }
}
