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
    static let INVITE_TABLE_NAME = "invites"
    
    // For segues
    static let LOGIN_MODAL_SEGUE = "com.iostriviagame.loginSegue"
    static let ANSWER_TO_RESULTS_SEGUE = "com.iostriviagame.answertoresultssegue"
    static let GAME_OPTIONS_TO_COUNTDOWN_SEGUE = "com.iostriviagame.gameoptionstocountdownsegue"
    
    // UI Identifiers
    static let MAIN_TAB_VIEW_CONTROLLER = "com.iostriviagame.maintabviewcontroller"
    static let QUESTION_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.questionnavigationviewcontroller"
    static let FINAL_SCORE_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.finalscorenavigationviewcontroller"
    static let ANSWER_TABLE_VIEW_CELL = "com.iostriviagame.answertableviewcell"
    static let SELECT_FRIENDS_VIEW_CONTROLLER = "com.iostriviagame.selectfriendsviewcontroller"
    static let GAME_OPTIONS_VIEW_CONTROLLER = "com.iostriviagame.gameoptionsviewcontroller"
    static let COUNTDOWN_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.countdownnavigationviewcontroller"
    static let COUNTDOWN_GAME_VIEW_CONTROLLER = "com.iostriviagame.countdowngameviewcontroller"
    static let RESULT_TABLE_VIEW_CELL = "com.iostriviagame.resulttableviewcell"
    static let FINAL_SCORE_TABLE_VIEW_CELL = "com.iostriviagame.finalscoretableviewcell"
    static let INVITE_TABLE_VIEW_CELL = "com.iostriviagame.invitetableviewcell"
}

