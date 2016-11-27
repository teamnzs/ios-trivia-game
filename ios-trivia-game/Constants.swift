//
//  Constants.swift
//  ios-trivia-game
//
//  Created by Zhia Chong on 11/12/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class Constants {
    static let GAME_ROOM_TABLE_NAME = "game_room"
    static let USER_TABLE_NAME = "users"
    static let USER_IN_GAME_TABLE_NAME = "user_in_game"
    static let QUESTION_TABLE_NAME = "questions"
    static let ANSWER_TABLE_NAME = "answers"
    static let SCORED_ANSWER_TABLE_NAME = "scored_answers"
    
    // For segues
    static let LOGIN_MODAL_SEGUE = "com.iostriviagame.loginSegue"
    static let ANSWER_TO_RESULTS_SEGUE = "com.iostriviagame.answertoresultssegue"
    
    // UI Identifiers
    static let MAIN_TAB_VIEW_CONTROLLER = "com.iostriviagame.maintabviewcontroller"
    static let QUESTION_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.questionnavigationviewcontroller"
    static let FINAL_SCORE_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.finalscorenavigationviewcontroller"
    static let ANSWER_TABLE_VIEW_CELL = "com.iostriviagame.answertableviewcell"
    static let RESULT_TABLE_VIEW_CELL = "com.iostriviagame.resulttableviewcell"
}

