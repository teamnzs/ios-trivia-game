//
//  Constants.swift
//  ios-trivia-game
//
//  Created by Zhia Chong on 11/12/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class Constants {
    static let GAME_ROOM_TABLE_NAME = "game_room_"
    static let USER_TABLE_NAME = "users"
    static let USER_IN_GAME_TABLE_NAME = "user_in_game"
    static let QUESTION_TABLE_NAME = "questions"
    static let ANSWER_TABLE_NAME = "answers"
    static let RESPONSES_TABLE_NAME = "responses"
    
    // For segues
    static let LOGIN_MODAL_SEGUE = "com.iostriviagame.loginSegue"
    static let ANSWER_TO_RESULTS_SEGUE = "com.iostriviagame.answertoresultssegue"
    
    // UI Identifiers
    static let MAIN_TAB_VIEW_CONTROLLER = "com.iostriviagame.maintabviewcontroller"
    static let ANSWER_TABLE_VIEW_CELL = "com.iostriviagame.answertableviewcell"
}

