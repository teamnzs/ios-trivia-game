//
//  Response.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/23/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class ScoredAnswer: Answer {
    var uid: String!
    var score: Int!
    
    override init(dictionary: NSDictionary) {
        self.uid = dictionary["id"] as? String
        self.score = dictionary["score"] as? Int
        super.init(dictionary: dictionary)
    }
    
    init(uid: String, score: Int, answer: Answer) {
        self.uid = uid
        self.score = score
        super.init(userId: answer.userId, answerText: answer.answerText, questionId: answer.questionId, roomId: answer.roomId)
        self.timestamp = answer.timestamp
    }
    
    override func getJson() -> [String: Any] {
        return [
            "uid": self.uid as Any,
            "score": self.score as Any,
            "user_id": self.userId as Any,
            "answer": self.answerText as Any,
            "question_id": self.questionId as Any,
            "timestamp": self.timestamp as Any,
            "room_id": self.roomId as Any
        ]
    }
}
