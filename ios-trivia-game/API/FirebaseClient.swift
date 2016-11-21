//
//  FirebaseClient.swift
//  ios-trivia-game
//
//  Created by Savio Tsui on 11/20/16.
//  Copyright © 2016 Team NZS. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseClient {
    static let instance = FirebaseClient()
    
    private init() {}
    
    // gets a user from the user table given a userId
    func getUser(userId: String, complete: @escaping (FIRDataSnapshot) -> (), onError: ((Error?) -> ())?) {
        let ref = FIRDatabase.database().reference()
        let path = "\(Constants.USER_TABLE_NAME)/\(userId)"
        ref.child(path).observe(.value, with: { (snapshot) in
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path)")
            complete(snapshot)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path), Error: \(error.localizedDescription)")
            
            if (onError != nil) {
                onError!(error)
            }
        }
    }
    
    // quits game of current user
    func quitGame(complete: (() -> ())?, onError: ((Error?) -> ())?) {
        let currentUserId = User.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        let path = "\(Constants.USER_IN_GAME_TABLE_NAME)/\(currentUserId!)"
        ref.child(path).removeValue { (error, ref) in
            if (error != nil) {
                Logger.instance.log(logLevel: .error, message: "FirebaseClient, Failed to remove: \(path), Error: \(error.debugDescription)")
                
                if (onError != nil) {
                    onError!(error)
                }
            }
            else {
                Logger.instance.log(logLevel: .info, message: "FirebaseClient, Removing: \(path)")
                
                if (complete != nil) {
                    complete!()
                }
            }
        }
    }
}
