//
//  Logger.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/12/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation

class Logger {
    static let instance = Logger()
    
    private init() {}
    
    enum LogLevel {
        case error
        case debug
        case info
    }
    
    func log(logLevel: LogLevel = .info, message: Any) {
        var prepend: String
        
        switch logLevel {
        case .error:
            prepend = "LOG.ERROR: "
        case .debug:
            prepend = "LOG.DEBUG: "
        default:
            prepend = "LOG.INFO: "
        }
        
        print("\(prepend)\(message)")
    }
}
