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
    var name: String!
    var state: State
    var current_question: Int! // UUID of the current question
    var max_num_of_questions: Int
    var current_num_players: Int
    var max_num_of_people: Int
    var is_public: Bool // Defaults to true
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? String ?? "0"
        self.name = dictionary["name"] as? String ?? "-- Unnamed Room --"
        self.current_num_players = dictionary["current_num_players"] as? Int ?? 0
        self.max_num_of_people = dictionary["max_num_people"] as? Int ?? MAX_NUMBER_OF_PEOPLE
        self.state = State(rawValue: dictionary["state"] as! Int)!
        self.is_public = dictionary["is_public"] as? Bool ?? true
        self.current_question = dictionary["current_question"] as? Int ?? 0
        self.max_num_of_questions = dictionary["max_num_of_questions"] as? Int ?? MAX_NUMBER_OF_QUESTIONS
    }
    
    init(id: String, name: String?, currentNumPlayers: Int?, maxNumPlayers: Int?, state: State?, isPublic: Bool?, currentQuestion: Int?, maxNumQuestions: Int?) {
        self.id = id
        self.name = name ?? "-- Unnamed Room --"
        self.current_num_players = currentNumPlayers ?? 0
        self.max_num_of_people = maxNumPlayers ?? MAX_NUMBER_OF_PEOPLE
        self.state = state ?? .idle
        self.is_public = isPublic ?? true
        self.current_question = currentQuestion ?? 0
        self.max_num_of_questions = maxNumQuestions ?? MAX_NUMBER_OF_QUESTIONS
    }
    
    func getJson() -> [String: Any] {
        return [
            "id": self.id as Any,
            "name": self.name as Any,
            "current_num_players": self.current_num_players as Any,
            "max_num_of_people": self.max_num_of_people as Any,
            "state": self.state.rawValue as Any,
            "is_public": self.is_public as Any,
            "current_question": self.current_question as Any,
            "max_num_of_questions": self.max_num_of_questions as Any
        ]
    }
}
