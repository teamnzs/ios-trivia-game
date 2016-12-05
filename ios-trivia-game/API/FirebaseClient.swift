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
    
    // creates a user in the user table
    func createUser(user: User, complete: @escaping (Error?, FIRDatabaseReference) -> Void) {
        let path = "\(Constants.USER_TABLE_NAME)/\(user.uid!)"
        let newUser = ref.child(path)
        newUser.setValue(user.getJson(), withCompletionBlock: { (error, ref) in
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: createUser \(path)")
            Logger.instance.log(message: user.getJson())
            complete(error, ref)
        })
    }
    
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
    
    // updates a user
    func updateUser(user: User, fromFacebook: Bool) {
        let path = "\(Constants.USER_TABLE_NAME)/\(user.uid)"
        ref.child(path).runTransactionBlock { (data) -> FIRTransactionResult in
            let value = data.value as? NSDictionary
            
            if (value == nil) {
                return FIRTransactionResult.abort()
            }
            
            let userDb = User(dictionary: value)
            
            if (userDb.name != user.name) {
                userDb.name = user.name
            }
            
            if (userDb.photoUrl != user.photoUrl) {
                userDb.photoUrl = user.photoUrl
            }
            
            if (userDb.facebookId != user.facebookId) {
                userDb.facebookId = user.facebookId
            }
            
            if (userDb.email != user.email) {
                userDb.email = user.email
            }
            
            // Note: all other fields are from our game system so it doesn't require an update from
            if (!fromFacebook) {
                if (userDb.isActive != user.isActive) {
                    userDb.isActive = user.isActive
                }
                
                if (userDb.nickname != user.nickname) {
                    userDb.nickname = user.nickname
                }
                
                if (userDb.ranking != user.ranking) {
                    userDb.ranking = user.ranking
                }
                
                if (userDb.score != user.score) {
                    userDb.score = user.score
                }
            }
            
            data.value = userDb.getJson()
            return FIRTransactionResult.success(withValue: data)
        }

    }
    
    // get users in a game
    func getUsersInGameBy(roomId: String, complete: @escaping (FIRDataSnapshot) -> (), onError: ((Error?) -> ())?) {
        let path = "\(Constants.USER_IN_GAME_TABLE_NAME)"
        ref.child(path).queryOrdered(byChild: "room_id").queryEqual(toValue: roomId).observe(.value, with: { (snapshot) in
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path)")
            complete(snapshot)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path), Error: \(error.localizedDescription)")
            
            if (onError != nil) {
                onError!(error)
            }
        }

    }
    
    // updates score value of user in user table
    func updateScore(userId: String, addValue: Int) {
        let path = "\(Constants.USER_TABLE_NAME)/\(userId)/score"
        ref.child(path).runTransactionBlock { (data) -> FIRTransactionResult in
            let currentScore = data.value as! Int
            data.value = currentScore + addValue
            return FIRTransactionResult.success(withValue: data)
        }
    }
    
    // updates current player count of game
    func updatePlayerCount(roomId: String, change: Int) {
        let gamePath = "\(Constants.GAME_ROOM_TABLE_NAME)/\(roomId)/current_num_players"
        self.ref.child(gamePath).runTransactionBlock { (data) -> FIRTransactionResult in
            let currentNumPlayers = data.value as! Int
            data.value = currentNumPlayers + change
            return FIRTransactionResult.success(withValue: data)
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
        }
    }
    
    // get game by id
    func getGameBy(roomId: String, complete: @escaping (FIRDataSnapshot) -> (), onError: ((Error?) -> ())?) {
        let path = "\(Constants.GAME_ROOM_TABLE_NAME)"
        ref.child(path).queryOrdered(byChild: "id").queryEqual(toValue: roomId).observe(.value, with: { (snapshot) in
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path) id=\(roomId)")
            complete(snapshot)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path) id=\(roomId), Error: \(error.localizedDescription)")
            
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
    
    // remove a game from the game_room table
    func removeGame(roomId: String, complete: (() -> ())?, onError: ((Error?) -> ())?) {
        let path = "\(Constants.GAME_ROOM_TABLE_NAME)/\(roomId)"
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
            if let data = snapshot.value as? NSDictionary {
                let filteredData: NSMutableArray = []
                
                for key in data.allKeys {
                    let entryData = data[key as! String] as? NSDictionary
                    if ((entryData?["question_id"] as? Int) == questionId) {
                        filteredData.add(entryData!)
                    }
                }
                
                Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path) room_id=\(roomId), question_id=\(questionId)")
                complete(filteredData as NSArray)
            }
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path) room_id=\(roomId), question_id=\(questionId), Error: \(error.localizedDescription)")
            
            if (onError != nil) {
                onError!(error)
            }
        }
    }
    
    // gets scored answers by room id and question id
    func getScoredAnswersBy(roomId: String, questionId: Int, complete: @escaping (NSArray) -> (), onError: ((Error?) -> ())?) {
        let path = "\(Constants.SCORED_ANSWER_TABLE_NAME)"
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
    
    // gets scored answers by room id and user id
    func getScoredAnswersBy(roomId: String, userId: String, complete: @escaping (NSArray) -> (), onError: ((Error?) -> ())?) {
        let path = "\(Constants.SCORED_ANSWER_TABLE_NAME)"
        ref.child(path).queryOrdered(byChild: "room_id").queryEqual(toValue: roomId).observe(.value, with: { (snapshot) in
            let data = snapshot.value as! NSDictionary
            let filteredData: NSMutableArray = []
            
            for key in data.allKeys {
                let entryData = data[key as! String] as? NSDictionary
                if ((entryData?["user_id"] as? String) == userId) {
                    filteredData.add(entryData!)
                }
            }
            
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path) room_id=\(roomId), user_id=\(userId)")
            complete(filteredData as NSArray)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path) room_id=\(roomId), user_id=\(userId), Error: \(error.localizedDescription)")
            
            if (onError != nil) {
                onError!(error)
            }
        }
    }
    
    // posts an answer to the answer database table
    func postAnswer(answer: Answer, complete: @escaping (Error?, FIRDatabaseReference) -> Void) {
        let path = "\(Constants.ANSWER_TABLE_NAME)"
        let newAnswer = ref.child(path).childByAutoId()
        answer.timestamp = String(describing: NSDate())
        newAnswer.setValue(answer.getJson(), withCompletionBlock: { (error, ref) in complete(error, ref) })
        Logger.instance.log(logLevel: .info, message: "FirebaseClient: Creating \(path)/\(newAnswer.key)")
    }
    
    // Creates a game
    func createGame(gameRoom: NSDictionary, complete: @escaping (Error?, FIRDatabaseReference) -> Void) {
        let path = "\(Constants.GAME_ROOM_TABLE_NAME)/\(gameRoom["id"]!)"
        let newGameRoom = ref.child(path)
        newGameRoom.setValue(gameRoom, withCompletionBlock: { (error, ref) in complete(error, ref)})
         Logger.instance.log(logLevel: .info, message: "FirebaseClient: Creating \(path)")
    }
    
    // Creates AutoId for GameRoom
    func createGameRoomId() -> FIRDatabaseReference {
        let path = "\(Constants.GAME_ROOM_TABLE_NAME)"
        return ref.child(path).childByAutoId()
    }

    // Joins current user to game
    func joinGame(roomId: String, complete: ((_ remainingCountdownTime: Int) -> ())?, fail: (() -> ())?) {
        
        // get room
        FirebaseClient.instance.getGameBy(roomId: roomId, complete: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                if data.count > 0 {
                    let gameRoom = GameRoom(dictionary: data[data.allKeys.first as! String] as! NSDictionary)
                    
                    // check if we can add a player and whether the countdown isn't done yet
                    let remainingCountdownTime = Date().timeIntervalSince(gameRoom.created_time)
                    if (gameRoom.current_num_players < gameRoom.max_num_of_people && remainingCountdownTime <= Double(Constants.GAME_START_COUNTDOWN)) {
                        
                        // update the user in game table
                        let currentUserId = User.currentUser?.uid!
                        let userInGame = UserInGame(roomId: roomId, userState: 0, userId: currentUserId!)
                        let userInGamePath = "\(Constants.USER_IN_GAME_TABLE_NAME)/\(currentUserId!)"
                        self.ref.child(userInGamePath).setValue(userInGame.getJson(), withCompletionBlock: { (error, setRef) in
                            complete?(Int(remainingCountdownTime))
                        })
                    }
                    else {
                        fail?()
                    }
                }
            }
        }) { (error) in }
    }
    
    // post a scored answer to the scored answer database table
    func postScoredAnswer(scoredAnswer: ScoredAnswer, complete: @escaping (Error?, FIRDatabaseReference) -> Void) {
        let path = "\(Constants.SCORED_ANSWER_TABLE_NAME)"
        let newAnswer = ref.child(path).childByAutoId()
        scoredAnswer.timestamp = String(describing: NSDate())
        newAnswer.setValue(scoredAnswer.getJson(), withCompletionBlock: { (error, ref) in complete(error, ref) })
    }
    
    // gets invites for a user
    func getInvitesFor(userId: String, complete: @escaping (FIRDataSnapshot) -> (), onError: ((Error?) -> ())?) {
        let path = "\(Constants.INVITE_TABLE_NAME)"
        ref.child(path).queryOrdered(byChild: "guest_id").queryEqual(toValue: userId).observe(.value, with: { (snapshot) in
            Logger.instance.log(logLevel: .info, message: "FirebaseClient: Accessing \(path) all invites for userId: \(userId)")

            complete(snapshot)
        }) { (error) in
            Logger.instance.log(logLevel: .error, message: "FirebaseClient, \(path) Failed to get all invites for userId: \(userId), Error: \(error.localizedDescription)")
        }
    }
    
    // creates invite
    func createInviteFor(invite: Invite, complete: @escaping (Error?, FIRDatabaseReference) -> Void) {
        let path = "\(Constants.INVITE_TABLE_NAME)"
        let newInvite = ref.child(path).childByAutoId()
        invite.id = newInvite.key
        newInvite.setValue(invite.getJson(), withCompletionBlock: { (error, ref) in complete(error, ref) })
    }
    
    // removes invite
    func removeInvite(inviteId: String, complete: (() -> ())?, onError: ((Error?) -> ())?) {
        let path = "\(Constants.INVITE_TABLE_NAME)/\(inviteId)"
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
