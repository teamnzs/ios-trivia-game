//
//  FinalScore.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/27/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class FinalScore: NSObject {
    var roomId: String!
    var user: User!
    var score: Int? = 0
    
    init(roomId: String!, user: User, score: Int) {
        self.roomId = roomId
        self.user = user
        self.score = score
    }
}
