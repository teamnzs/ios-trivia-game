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
    static let CATEGORY_TABLE_NAME = "categories"
    static let SUGGESTION_TABLE_NAME = "suggestions"

    // For segues
    static let LOGIN_MODAL_SEGUE = "com.iostriviagame.loginSegue"
    static let COUNTDOWN_TO_QUESTION_SEGUE = "com.iostriviagame.countdowntoquestionsegue"
    static let QUESTION_TO_ANSWER_SEGUE = "com.iostriviagame.questiontoanswersegue"
    static let ANSWER_TO_RESULTS_SEGUE = "com.iostriviagame.answertoresultssegue"
    static let GAME_OPTIONS_TO_COUNTDOWN_SEGUE = "com.iostriviagame.gameoptionstocountdownsegue"
    static let SPLASH_TO_LOGIN_SEGUE = "com.iostriviagame.splashToLoginSegue"
    static let SPLASH_TO_MAIN_SEGUE = "com.iostriviagame.splashToMainSegue"
    
    // UI Identifiers
    static let LOGIN_VIEW_CONTROLLER = "com.iostriviagame.loginviewcontroller"
    static let TUTORIAL_VIEW_CONTROLLER = "com.iostriviagame.tutorialviewcontroller"
    static let MAIN_TAB_VIEW_CONTROLLER = "com.iostriviagame.maintabviewcontroller"
    static let QUESTION_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.questionnavigationviewcontroller"
    static let FINAL_SCORE_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.finalscorenavigationviewcontroller"
    static let ANSWER_TABLE_VIEW_CELL = "com.iostriviagame.answertableviewcell"
    static let SELECT_FRIENDS_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.selectfriendsnavigationviewcontroller"
    static let SELECT_FRIENDS_VIEW_CONTROLLER = "com.iostriviagame.selectfriendsviewcontroller"
    static let GAME_OPTIONS_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.gameoptionsnavigationviewcontroller"
    static let GAME_OPTIONS_VIEW_CONTROLLER = "com.iostriviagame.gameoptionsviewcontroller"
    static let COUNTDOWN_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.countdownnavigationviewcontroller"
    static let COUNTDOWN_GAME_VIEW_CONTROLLER = "com.iostriviagame.countdowngameviewcontroller"
    static let RESULT_TABLE_VIEW_CELL = "com.iostriviagame.resulttableviewcell"
    static let FINAL_SCORE_TABLE_VIEW_CELL = "com.iostriviagame.finalscoretableviewcell"
    static let INVITE_TABLE_VIEW_CELL = "com.iostriviagame.invitetableviewcell"
    static let SELECT_FRIENDS_TABLE_VIEW_CELL = "com.iostriviagame.selectfriendstableviewcell"
    static let CREATE_GAME_NAVIGATION_VIEW_CONTROLLER = "com.iostriviagame.creategamenavigationviewcontroller"
    static let HOME_TABLE_VIEW_CELL = "com.iostriviagame.hometableviewcell"
    
    static let GAME_START_COUNTDOWN = 30
    static let GAME_QUESTION_ANSWER_COUNTDOWN = 20
    static let REFRESH_GAME_ROOM_INTERVAL = 86400
    
    // Color Themes
    static let TRIVIA_RED = "#fffc4349"
    static let TRIVIA_NAVY = "#ff2c3e50"
    static let TRIVIA_GRAY = "#ffd7dadb"
    static let TRIVIA_BLUE = "#ff6dbcdb"
    static let TRIVIA_WHITE = "#ffffffff"
}

