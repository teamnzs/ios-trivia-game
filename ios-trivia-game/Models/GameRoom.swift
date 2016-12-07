//
//  GameRoom.swift
//  ios-trivia-game
//
//  Created by Zhia Chong on 11/13/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

// TO be determined
let MAX_NUMBER_OF_PEOPLE = 5
let MAX_NUMBER_OF_QUESTIONS = 10

class GameRoom: NSObject {
    enum State: Int {
        case idle = 0
        case playing = 1
        case end = 2
    }
    
    var id: String!
    var host_id: String!
    var name: String!
    var state: State
    var questions: [Int]
    var category: Int!
    var current_question: Int! // UUID of the current question
    var max_num_of_questions: Int
    var current_num_players: Int
    var max_num_of_people: Int
    var is_public: Bool // Defaults to true
    var created_time: Date
    
    init(dictionary: NSDictionary = NSDictionary()) {
        self.id = dictionary["id"] as? String ?? "0"
        self.name = dictionary["name"] as? String ?? "-- Unnamed Room --"
        self.current_num_players = dictionary["current_num_players"] as? Int ?? 0
        self.max_num_of_people = dictionary["max_num_of_people"] as? Int ?? MAX_NUMBER_OF_PEOPLE
        self.state = State(rawValue: dictionary["state"] as! Int)!
        self.is_public = dictionary["is_public"] as? Bool ?? true
        self.current_question = dictionary["current_question"] as? Int ?? 0
        self.category = dictionary["category"] as? Int ?? 0
        self.max_num_of_questions = dictionary["max_num_of_questions"] as? Int ?? MAX_NUMBER_OF_QUESTIONS
        self.created_time = dictionary["created_time"] is String ? Utilities.convertToDate(dateString: dictionary["created_time"] as! String) : Date()
        self.questions = dictionary["questions"] as? [Int] ?? []
        self.host_id = dictionary["host_id"] as? String ?? "0"
    }
    
    init(id: String, name: String?, currentNumPlayers: Int?, maxNumPlayers: Int?, state: State?, isPublic: Bool?, currentQuestion: Int?, maxNumQuestions: Int?, questions: [Int]?, category: Int?, host_id: String?) {
        self.id = id
        self.name = name ?? "-- Unnamed Room --"
        self.current_num_players = currentNumPlayers ?? 0
        self.max_num_of_people = maxNumPlayers ?? MAX_NUMBER_OF_PEOPLE
        self.state = state ?? .idle
        self.is_public = isPublic ?? true
        self.current_question = currentQuestion ?? 0
        self.max_num_of_questions = maxNumQuestions ?? MAX_NUMBER_OF_QUESTIONS
        self.created_time = Date()
        self.questions = questions ?? []
        self.category = category ?? 0
        self.host_id = host_id ?? "0"
    }
    
    func getJson() -> [String: Any] {
        return [
            "id": self.id as Any,
            "name": self.name as Any,
            "current_num_players": self.current_num_players as Any,
            "max_num_of_people": self.max_num_of_people as Any,
            "state": self.state.rawValue as Any,
            "is_public": self.is_public as Any,
            "category": self.category as Any,
            "current_question": self.current_question as Any,
            "max_num_of_questions": self.max_num_of_questions as Any,
            "created_time": String(describing: self.created_time) as Any,
            "questions": self.questions as Any,
            "host_id": self.host_id as Any
        ]
    }
}
