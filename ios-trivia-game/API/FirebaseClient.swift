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
    
    fileprivate let ref = FIRDatabase.database().reference()
    
    private init() {}
    
    // gets a user from the user table given a userId
    func getUser(userId: String, complete: @escaping (FIRDataSnapshot) -> (), onError: ((Error?) -> ())?) {
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
    
    // gets all game rooms
    func getGameRooms(complete: ((NSDictionary) -> ())?, onError: ((Error?) -> ())?) {
        let path = "\(Constants.GAME_ROOM_TABLE_NAME)"
        ref.child(path).observe(.value, with: { (snapshot) in
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path) all game rooms")
            
            let value = snapshot.value as? NSDictionary
            complete!(value!)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path) Failed to get all rooms, Error: \(error.localizedDescription)")
            
            if (onError != nil) {
                onError!(error)
            }
        }
    }
    
    // quits game of current user
    func quitGame(complete: (() -> ())?, onError: ((Error?) -> ())?) {
        let currentUserId = User.currentUser?.uid
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
    
    // gets question by id
    func getQuestionBy(questionId: Int, complete: @escaping (FIRDataSnapshot) -> (), onError: ((Error?) -> ())?) {
        let path = "\(Constants.QUESTION_TABLE_NAME)"
        ref.child(path).queryOrdered(byChild: "id").queryEqual(toValue: questionId).observe(.value, with: { (snapshot) in
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path) id=\(questionId)")
            complete(snapshot)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path) id=\(questionId), Error: \(error.localizedDescription)")
            
            if (onError != nil) {
                onError!(error)
            }
        }
    }
    
    // gets questions by categoryId
    // NOTE: I haven't tested that this works yet
    func getQuestionsBy(categoryId: String, complete: @escaping (FIRDataSnapshot) -> (), onError: ((Error?) -> ())?) {
        let path = "\(Constants.QUESTION_TABLE_NAME)"
        ref.child(path).queryOrdered(byChild: "category").queryEqual(toValue: Int(categoryId)!, childKey: "category/id").observe(.value, with: { (snapshot) in
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path) category/id=\(categoryId)")
            complete(snapshot)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path) id=\(categoryId), Error: \(error.localizedDescription)")
            
            if (onError != nil) {
                onError!(error)
            }
        }
    }
    
    // gets answers by room id and question id
    func getAnswersBy(roomId: String, questionId: Int, complete: @escaping (NSArray) -> (), onError: ((Error?) -> ())?) {
        let path = "\(Constants.ANSWER_TABLE_NAME)"
        ref.child(path).queryOrdered(byChild: "room_id").queryEqual(toValue: roomId).observe(.value, with: { (snapshot) in
            let data = snapshot.value as! NSDictionary
            let filteredData: NSMutableArray = []
            
            for key in data.allKeys {
                let entryData = data[key as! String] as? NSDictionary
                if ((entryData?["question_id"] as? Int) == questionId) {
                    filteredData.add(entryData!)
                }
            }
            
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path) room_id=\(roomId), question_id=\(questionId)")
            complete(filteredData as NSArray)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path) room_id=\(roomId), question_id=\(questionId), Error: \(error.localizedDescription)")
            
            if (onError != nil) {
                onError!(error)
            }
        }
    }
    
    // posts an answer to the answer database table
    func postAnswer(answer: Answer, complete: @escaping (Error?, FIRDatabaseReference) -> Void) {
        let path = "\(Constants.RESPONSES_TABLE_NAME)"
        let newAnswer = ref.child(path).childByAutoId()
        answer.timestamp = String(describing: NSDate())
        newAnswer.setValue(answer.getJson(), withCompletionBlock: { (error, ref) in complete(error, ref) })
    }
    
    // Creates a game
    func createGame(gameRoom: NSDictionary, complete: @escaping (Error?, FIRDatabaseReference) -> Void) {
        let path = "\(Constants.GAME_ROOM_TABLE_NAME)"
        let newGameRoom = ref.child(path).childByAutoId()
        newGameRoom.setValue(gameRoom, withCompletionBlock: { (error, ref) in complete(error, ref)})
    }
}
